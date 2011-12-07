package com.civildebatewall.kiosk.camera {

	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	// This class integrates with Windows-only GCDWFoto.exe to control the Canon Rebel XS SLR camera used for high resolution portraits
	
	// Basic Process:
	// 1. Initiate communication with SLR, this passes in target directory for image downloads from the SD to HD
	// 2. Format the SLR's SD card, this makes sure we download the latest image only and prevents the card from filling up
	// 3. Tell the SLR to take a photo
	// 4. Get file name and download start notification from SLR after photo is taken
	// 5. Get notification when file download is complete
	// 6. Wait a little extra time, because it lies
	// 7. Open and process the file in the target directory that matches the file sent from the SLR during step 4	
	
	public class SLRCamera extends EventDispatcher {
		
		private static const logger:ILogger = getLogger(SLRCamera);
		
		private var slrProcess:NativeProcess;
		private var writeDelayTimer:Timer; // wait until the camera is done writing.
		private var timeoutTimer:Timer;
		private var timedOut:Boolean;
		private var imageTargetFile:File;
		private var imageTargetFolder:File;
		private var imageLoader:Loader = new Loader();
		private var loadedBitmap:Bitmap = new Bitmap();
		private var takePhotoStartTime:int;
		public var image:Bitmap;		
		
		public function SLRCamera() {
			logger.info("Setting up SLR...");
			
			// set the image folder, will come from settings
			imageTargetFolder = new File(CivilDebateWall.settings.tempImagePath);
			
			var slrControlApp:File = File.applicationDirectory.resolvePath("native/slrcontrol/GCDWFoto.exe");	
			
			var nativeProcessStartup:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			var args:Vector.<String> = new  Vector.<String>();
			args.push(FileUtil.fileToWindowsPath(imageTargetFolder)); // where to save images
			
			slrProcess = new NativeProcess();
			slrProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			nativeProcessStartup.executable = slrControlApp;
			nativeProcessStartup.arguments = args;
			slrProcess.start(nativeProcessStartup);			
			
			timeoutTimer = new Timer(CivilDebateWall.settings.slrTimeout * 1000); // go back to photo page after five seconds... assume focus is lost
			timeoutTimer.addEventListener(TimerEvent.TIMER, onTimeout);
			
			// format the card before we get started
			formatCard();
			
			logger.info("...Set up SLR");			
		}
		
		
		// SLR CONTROL ================================================================
		
		// Inputs
		private function formatCard():void {
			logger.info("Formatting card...");
			slrProcess.standardInput.writeUTFBytes("f\n");			
		}
		
		public function takePhoto():void {
			logger.info("Taking SLR photo...");
			timeoutTimer.reset();
			timeoutTimer.start();
			timedOut = false;	
			
			takePhotoStartTime = getTimer();
			slrProcess.standardInput.writeUTFBytes("p\n");
		}		
		
		// Outputs
		private function onOutputData(event:ProgressEvent):void 	{
			var stdout:String = slrProcess.standardOutput.readUTFBytes(slrProcess.standardOutput.bytesAvailable); 
			
			// split on newlines
			stdout = stdout.replace("\r", "");
			stdout = stdout.replace("\n\n", "\n");
			var stdoutlines:Array = stdout.split("\n");
			
			for each (var line:String in stdoutlines) {
				if (line.length > 0) {
					logger.info("Raw SLR output: " + line);
					
					if (line.indexOf("Saving image") > -1) {
						// photo is taken, camera is starting download from SD to HD 
						var fileName:String = line.split(" ")[2];
						onDownloadStarted(fileName);
					}
					else if (line.indexOf("Download complete") > -1) {
						// file has downloaded from SD to HD
						onDownloadComplete();	
					}					
					else if (line.indexOf("format complete") > -1) {
						logger.info("...Format complete");
					}
				}
			}
		}
		
		// Output handlers
		private function onDownloadStarted(fileName:String):void {
			logger.info("Image download to file \"" + fileName + "\" starting...");			
			timeoutTimer.stop(); // photo was definitely taken
			imageTargetFile = new File(fileName);
		}
		
		private function onDownloadComplete():void {
			logger.info("...Image download complete");
			
			// Alternative approach might watch file size for stabilization and then trigger load image
			
			if (!timedOut) {
				TweenMax.delayedCall(CivilDebateWall.settings.slrWaitTime, loadImage, [imageTargetFile]);
				TweenMax.delayedCall(CivilDebateWall.settings.slrWaitTime, formatCard); // try delaying the call
			}
		}
		
		
		// IMAGE PROCESSING ============================================================
				
		private function loadImage(file:File):void {
			logger.info("Loading SLR photo \"" + file.url + "\"...");
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleImageLoad);
			imageLoader.load(new URLRequest(file.url.replace("%0d", ""))); // completely weird filename bug
		}
		
		private function handleImageLoad( e:Event ):void {
			logger.info("...SLR photo loaded.");
			
			imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleImageLoad);
			
			loadedBitmap = imageLoader.content as Bitmap;
			loadedBitmap.smoothing = true;
			
			// rotate and flip the image
			var matrix:Matrix = new Matrix();
			matrix.rotate(Math2.degToRad(90));			
			matrix.scale(-1, 1); // flip horizontally
			
			image = new Bitmap(new BitmapData(loadedBitmap.height, loadedBitmap.width), "auto", true);
			image.bitmapData.draw(loadedBitmap, matrix, null, null, null, true);			
			
			logger.info("SLR photo process took " + (getTimer() - takePhotoStartTime));
			
			this.dispatchEvent(new CameraFeedEvent(CameraFeedEvent.NEW_FRAME_EVENT));
			
			// TODO clear the temp folder?
		}

		// ERROR HANDLING ============================================================
		
		private function onTimeout(e:TimerEvent):void {
			logger.error("SLR timed out after " + (getTimer() - takePhotoStartTime) + "ms");
			timeoutTimer.stop();
			timedOut = true;
			this.dispatchEvent(new Event(CameraFeedEvent.CAMERA_TIMEOUT_EVENT));
		}

	}
}