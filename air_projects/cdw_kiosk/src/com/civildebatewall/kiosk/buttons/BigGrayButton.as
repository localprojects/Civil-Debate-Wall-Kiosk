/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.buttons {

	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	public class BigGrayButton extends BlockBitmap	{
		
		private var _overColor:uint;
		
		public function BigGrayButton(b:Bitmap) {
			super({
				bitmap: b,
				overColor: ColorUtil.gray(77),
				backgroundColor: 0xffffff,
				width: 432,
				height: 142,
				backgroundRadius: 13,
				alignmentPoint: Alignment.CENTER,
				buttonMode: true
			});
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
			onButtonCancel.push(onCancel);
			
			drawUp();
		}

		private function onDown(e:MouseEvent):void {
			drawDown();			
		}
		
		private function onUp(e:MouseEvent):void {
			drawUp();
		}
		
		private function onCancel(e:MouseEvent):void {
			removeStageUpListener();
			drawUp();
		}
		
		private function drawUp():void {
			TweenMax.to(this, 0.5, {backgroundColor: 0xffffff});
			TweenMax.to(bitmap, 0.5, {colorMatrixFilter: {colorize: _overColor, amount: 1}});
		}
		
		private function drawDown():void {
			TweenMax.to(this, 0, {backgroundColor: _overColor});
			TweenMax.to(bitmap, 0, {colorMatrixFilter: {colorize: 0xffffff, amount: 1}});
		}
		
		public function get overColor():uint {return _overColor; }
		public function set overColor(value:uint):void { _overColor = value; }
		
	}
}
