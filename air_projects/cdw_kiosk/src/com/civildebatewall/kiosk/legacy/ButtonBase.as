/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.legacy {
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ButtonBase extends OldBlockBase {
		
		public static const ACTIVE:String = "active";
		public static const INACTIVE:String = "active";
		public static const UP:String = "active";
		public static const DOWN:String = "active";		
		
		protected var onClick:Function;
		protected var onDown:Function;		
		protected var outline:Shape;
		protected var background:Sprite;
		protected var _backgroundColor:uint;
		protected var _backgroundDownColor:uint;
		protected var _disabledColor:uint = 0;		
	
		public function ButtonBase() {
			super();
			init();
		}
			
		private function init():void {
			background = new Sprite();
			onClick = defaultOnClick;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		protected function onMouseDown(e:MouseEvent):void {
			if (onDown != null) onDown(e);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			TweenMax.to(background, 0, {colorTransform: {tint: _backgroundDownColor, tintAmount: 1}});
		}
		
		protected function onMouseUp(e:MouseEvent):void {	
			TweenMax.to(background, 0.3, {ease: Quart.easeOut, colorTransform: {tint: _disabledColor, tintAmount: 1}});
			TweenMax.to(outline, 0.3, {ease: Quart.easeOut, alpha: 0});				
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
			onClick(e);
		}		
		
		protected function defaultOnClick(e:MouseEvent):void {
			// Override me
		}
		
		public function setOnClick(f:Function):void {
			if (f == null) {
				disable();
			}
			else {
				onClick = f;
				enable();
			}
		}
		
		public function setOnDown(f:Function):void {
			if (f == null) {
			}
			else {
				onDown = f;
			}
		}
		
		public function enable():void {
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);			
		}
		
		public function disable():void {
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);			
		}
		
	}
}
