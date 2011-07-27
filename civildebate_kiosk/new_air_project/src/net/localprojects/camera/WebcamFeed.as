package net.localprojects.camera {
	
	import com.adobe.images.*;
	import com.bit101.components.*;
	import com.greensock.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.*;
	
	import net.localprojects.*;	
	
	public class WebcamFeed extends EventDispatcher implements ICameraFeed {
		
		private var cameraWidth:int;
		private var cameraHeight:int;


		
		private var camera:Camera;
		private var video:Video;
		public var frame:BitmapData;
		private var targetFrameRate:int;
		
		
		public function WebcamFeed() {
			super();
			init();
		}
		
		private function init():void {
			cameraWidth = 1024;
			cameraHeight = 768;
			video = new Video(cameraWidth, cameraHeight);
			frame = new BitmapData(cameraWidth, cameraHeight, false);
			targetFrameRate = 30;
			
			camera = Camera.getCamera();
			camera.setMode(cameraWidth, cameraHeight, targetFrameRate);
		}
		
		public function start():void {
			video.addEventListener(Event.ENTER_FRAME, onVideoFrame);
			video.attachCamera(camera);			
		}
		
		public function stop():void {
			this.video.removeEventListener(Event.ENTER_FRAME, onVideoFrame);
			video.attachCamera(null);
		}
		
		public function play():void {
			video.addEventListener(Event.ENTER_FRAME, onVideoFrame);
		}
		
		public function pause():void {
			video.removeEventListener(Event.ENTER_FRAME, onVideoFrame);
		}		
		
		private function onVideoFrame(e:Event):void {
			// draw the frame into a bitmap
			frame.draw(video);
			this.dispatchEvent(new CameraFeedEvent(CameraFeedEvent.NEW_FRAME_EVENT));
		}
	}
}