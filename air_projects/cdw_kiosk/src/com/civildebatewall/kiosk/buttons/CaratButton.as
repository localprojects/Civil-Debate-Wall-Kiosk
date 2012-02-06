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

package com.civildebatewall.kiosk.buttons {
	
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.MouseEvent;
	
	public class CaratButton extends BlockBitmap	{
		
		public function CaratButton(params:Object = null)		{
			super(params);
			buttonMode = true;
			width = 64;
			height = 64;
			backgroundAlpha = 0;
			visible = true;
			alignmentPoint = Alignment.CENTER;

			onButtonDown.push(onDown);
			onStageUp.push(onUp);			
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(this, 0, {alpha: 0.5});			
		}
		
		private function onUp(e:MouseEvent):void {
			TweenMax.to(this, 0.5, {alpha: 1});
		}
		
		public function disable():void {
			TweenMax.to(this, 0, {alpha: 0.5});
			locked = true;
		}
		
		public function enable():void {
			TweenMax.to(this, 0.5, {alpha: 1});
			locked = false;			
		}
	}
}
