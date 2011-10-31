package com.civildebatewall.kiosk {

	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.InactivityEvent;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.kiosk.blocks.*;
	import com.civildebatewall.kiosk.camera.*;
	import com.civildebatewall.kiosk.elements.*;
	import com.civildebatewall.kiosk.keyboard.*;
	import com.civildebatewall.kiosk.ui.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	

	FastEase.activate([Linear, Quad, Cubic, Quart, Quint, Strong]);
	
	// merge this with view?
	
	public class Kiosk extends Sprite {
		
		public static var self:Kiosk;		
		public var view:View;
		public static var testOverlay:Bitmap;

		
		public function Kiosk() {
			self = this;
			
			view = new View();
			addChild(view);
			
			// set up test overlay
			testOverlay = new Bitmap(new BitmapData(1080, 1920));
			testOverlay.visible = false;
			testOverlay.alpha = 0.5;
			
			// Add test overlay
			addChild(testOverlay);			
			
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		private function onDataUpdate(e:Event):void {
			// Initialize some stuff. only runs once at startup.			
			
						
			view.homeView();		
		}
		



		
		private function onInactive(e:InactivityEvent):void {
			trace("inactive!");
			view.inactivityOverlayView();
		}
		


	}
}