package net.localprojects.camera
{
	import flash.desktop.*;
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.geom.Matrix;
	import flash.net.*;
	import flash.utils.*;
	
	import net.localprojects.*;
	
	
	
	public class SLRCamera extends EventDispatcher 
	{
		
		public static const PHOTO_TIMEOUT_EVENT:String = "photoTimeoutEvent";
		
		private var slrProcess:NativeProcess;
		private var folderWatchTimer:Timer;
		private var writeDelayTimer:Timer; // wait until the camera is done writing.
		private var timeoutTimer:Timer;
		private var onTimeoutFunction:Function;
		
		private var imageFile:File;
		private var imageFolder:File;
		public var image:Bitmap;
		
		public function SLRCamera()
		{
			// set the image folder, will come from settings
			imageFolder = new File();
			imageFolder.nativePath = "c:/temp/";
			
			var slrControlApp:File = File.applicationDirectory.resolvePath('native/slrcontrol/GCDWFoto.exe');	
			
			var nativeProcessStartup:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			var args:Vector.<String> = new  Vector.<String>();
			args.push(fileToWindowsPath(imageFolder)); // where to save images
			
			slrProcess = new NativeProcess();
			slrProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			nativeProcessStartup.executable = slrControlApp;
			nativeProcessStartup.arguments = args;
			slrProcess.start(nativeProcessStartup);			
			
			//var shutterButton:PushButton = new PushButton(this, 10, 10, "TAKE PHOTO", onShutterButton);
			//var formatButton:PushButton = new PushButton(this, 10, 40, "FORMAT CARD", onFormatButton);
			
			folderWatchTimer = new Timer(100);
			folderWatchTimer.addEventListener(TimerEvent.TIMER, onCheckFolder);
			
			timeoutTimer = new Timer(CDW.settings.slrTimeout * 1000); // go back to photo page after five seconds... assume focus is lost
			timeoutTimer.addEventListener(TimerEvent.TIMER, onTimeout);
		}
		
		// move this to utils
		// for passing as arg into the command line app, it needs two forward slashes between folders
		public function fileToWindowsPath(f:File):String {
			// double the slashes and add trailing
			return f.nativePath.replace('\\', '//') + '//';
		}
		
		public function setOnTimeout(f:Function):void {
			onTimeoutFunction = f;
		}
		
		private function listImages():Array {
			var imageDirectoryContents:Array = imageFolder.getDirectoryListing();
			
			// build an array of image files
			var imageFiles:Array = [];
			for each(var file:File in imageDirectoryContents) {
				if (file.extension == 'JPG') {
					imageFiles.push(file);
					file.creationDate
				}
			}
			
			if(imageFiles.length > 0) {
				imageFiles = imageFiles.sortOn('creationDate', Array.DESCENDING);
				trace(imageFiles.length + ' images');
				trace('Latest is: ' + imageFiles[0].name);
				return imageFiles;
			}
			else {
				trace('no images in the folder');
				return [];
			}	
		}
		
		private function onCheckFolder(e:TimerEvent):void {
			var images:Array = listImages();
			trace(images);
			
			if (images.length > 0) {
				// load the latest image
				
				
				
				loadImage(images[0]);
				// stop the checking
				trace("got image");
				folderWatchTimer.stop();
			}
			
		}
		
		// move to utilities
		
		//var imageClip:MovieClip = new MovieClip();
		private var imageLoader:Loader = new Loader();
		private var loadedBitmap:Bitmap = new Bitmap();
		
		
		private function onFormatButton(e:Event):void {
			trace("format");
			formatCard();
		}
		
		private function onShutterButton(e:Event):void {
			trace("shutter");
			takePhoto();
		}
		
		private function formatCard():void {
			slrProcess.standardInput.writeUTFBytes('f\n');			
		}
		
		public function takePhoto():void {
			CDW.dashboard.log("Starting timeout timer");
			timeoutTimer.reset();
			timeoutTimer.start();
			slrProcess.standardInput.writeUTFBytes('p\n');
		}
		
		private function onDownloadComplete():void {
			loadImage(imageFile);
			formatCard();
		}		
		
		private function loadImage(file:File):void {
			trace("loading slr photo " + file.url);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleImageLoad);
			imageLoader.load(new URLRequest(file.url.replace('%0d', ''))); // completely weird filename bug
		}
		
		private function handleImageLoad( e:Event ):void {
			trace("loaded");
			loadedBitmap = imageLoader.content as Bitmap;
			loadedBitmap.smoothing = true;
			
			// rotate and flip the image
			var matrix:Matrix = new Matrix();
			matrix.rotate(Utilities.degToRad(90));			
			matrix.scale(-1, 1); // flip horizontally
			
			image = new Bitmap(new BitmapData(loadedBitmap.height, loadedBitmap.width), "auto", true);
			image.bitmapData.draw(loadedBitmap, matrix, null, null, null, true);			
			
			this.dispatchEvent(new CameraFeedEvent(CameraFeedEvent.NEW_FRAME_EVENT));
			
			// TODO now move or delete the image!
		}
		
		private function onTimeout(e:TimerEvent):void {
			CDW.dashboard.log("timeout!");
			timeoutTimer.stop();
			timeoutTimer.reset();
			onTimeoutFunction(e);
		}
		
		
		private function onOutputData(event:ProgressEvent):void 	{
			var stdout:String = slrProcess.standardOutput.readUTFBytes(slrProcess.standardOutput.bytesAvailable); 
			
			// split on newlines
			stdout = stdout.replace('\r', '');
			stdout = stdout.replace('\n\n', '\n');
			var stdoutlines:Array = stdout.split('\n');
			
			for each (var line:String in stdoutlines) {
				if (line.length > 0) {
					trace("Line: " + line);
					
					if (line.indexOf("Download complete") > -1) {
						// file is here
						onDownloadComplete();	
					}
					else if (line.indexOf("Saving image") > -1) {
						CDW.dashboard.log("Stopping timeout timer");
						timeoutTimer.stop();
						
						var fileName:String = line.split(' ')[2];
						trace("Creating file: " + fileName);
						imageFile = new File();
						imageFile.nativePath = fileName;
					}
					else if (line.indexOf("format complete") > -1) {
						trace("format finished");
					}
				}
			}
		}
		
	}
}