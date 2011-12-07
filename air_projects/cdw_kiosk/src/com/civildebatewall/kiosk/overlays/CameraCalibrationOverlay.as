package com.civildebatewall.kiosk.overlays {
	
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Slider;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.kiosk.camera.CameraFeedEvent;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class CameraCalibrationOverlay extends Sprite {

		private var zoomSlider:Slider;
		private var closeButton:PushButton;
		
		private var webcam:Bitmap;
		private var slr:Bitmap;
		private var zoomLabel:Label;
		
		private var faceTarget:Shape;
		
		private var slrIntervalometer:Timer; 
		
		public function CameraCalibrationOverlay()	{
			super();
			GraphicsUtil.fillRect(graphics, 1080, 1920); // background

			webcam = new Bitmap();
			addChild(webcam);
			
			slr = new Bitmap();
			slr.alpha = 0.5;
			addChild(slr);
			
			zoomSlider = new Slider("horizontal", this, 20, 1920 - 100, onZoomSlider);
			zoomSlider.width = 840;
			zoomSlider.height = 80;
			zoomSlider.minimum = 1;
			zoomSlider.maximum = 3;
			zoomSlider.value = CivilDebateWall.kiosk.portraitCamera.getFocalLength();
			
			zoomLabel = new Label(this, 40, 1920 - 80, "ZOOM LEVEL: " + CivilDebateWall.kiosk.portraitCamera.getFocalLength());
			
			closeButton = new PushButton(this, zoomSlider.x + zoomSlider.width + 20, zoomSlider.y, "DONE", onCloseButton);
			closeButton.width = 180;
			closeButton.height = 80;
			
			faceTarget = new Shape();
			faceTarget.graphics.lineStyle(10, 0xffffff);
			faceTarget.graphics.drawRect(CivilDebateWall.state.targetFaceRectangle.x, CivilDebateWall.state.targetFaceRectangle.y, CivilDebateWall.state.targetFaceRectangle.width, CivilDebateWall.state.targetFaceRectangle.height);
			addChild(faceTarget);
			
			// watch slr
			if (CivilDebateWall.settings.useSLR) {
				CivilDebateWall.kiosk.portraitCamera.slr.addEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onSlrCapture);				
			}

			// watch webcam
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			// SLR timer
			slrIntervalometer = new Timer(5000);
			slrIntervalometer.addEventListener(TimerEvent.TIMER, onSlrInterval);
			slrIntervalometer.start();
		}
		
		private function onSlrInterval(e:TimerEvent):void {
			if (CivilDebateWall.settings.useSLR) {
				CivilDebateWall.kiosk.portraitCamera.slr.takePhoto();				
			}			
		}
		
		private function onEnterFrame(e:Event):void {
			CivilDebateWall.kiosk.portraitCamera.takePhoto();
			webcam.bitmapData = CivilDebateWall.kiosk.portraitCamera.cameraBitmap.bitmapData.clone();
		}
		
		private function onZoomSlider(e:Event):void {
			CivilDebateWall.kiosk.portraitCamera.setFocalLength(zoomSlider.value);
			zoomLabel.text = "ZOOM LEVEL: " + CivilDebateWall.kiosk.portraitCamera.getFocalLength();
		}
																	
		private function onSlrCapture(e:CameraFeedEvent):void {
			slr.bitmapData = BitmapUtil.scaleDataToFill(CivilDebateWall.kiosk.portraitCamera.slr.image.bitmapData, 1080, 1920);
		}																	
																	
		private function onCloseButton(e:Event):void {
			close();
		}
		
		public function close():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			slrIntervalometer.stop();
			slrIntervalometer.removeEventListener(TimerEvent.TIMER, onSlrInterval);
			CivilDebateWall.kiosk.portraitCamera.slr.removeEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onSlrCapture);
			CivilDebateWall.kiosk.removeCameraCalibrationOverlayView();
		}
		
	}
}