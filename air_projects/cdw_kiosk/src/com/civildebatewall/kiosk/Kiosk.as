package com.civildebatewall.kiosk {

	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.InactivityEvent;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.kiosk.buttons.*;
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
			
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		private function onDataUpdate(e:Event):void {
			// Initialize some stuff. only runs once at startup.			
			
			// Start at home // TODO no content conditional?
			CivilDebateWall.state.setView(view.homeView);
			//CivilDebateWall.state.setView(view.smsPromptView);
		}
		
		private function onInactive(e:InactivityEvent):void {
			trace("inactive!");
			view.inactivityOverlayView();
		}
		


	}
}