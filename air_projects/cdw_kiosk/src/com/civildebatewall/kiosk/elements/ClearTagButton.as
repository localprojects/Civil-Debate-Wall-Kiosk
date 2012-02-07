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

package com.civildebatewall.kiosk.elements {

	import com.civildebatewall.Assets;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ClearTagButton extends BlockText	{
		
		public static const CLEAR_TAG_EVENT:String = "clearTagEvent";		
		
		private var divider:Shape;
		private var icon:Bitmap;
		
		public function ClearTagButton() {
			super({
				width: 212,
				height: 64,
				text: "Clear Tag",
				textColor: 0xffffff,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 18,
				letterSpacing: -1,
				buttonMode: true,
				paddingLeft: 29,
				alignmentY: 0.5,
				backgroundColor: 0x000000
			});
			
			divider = GraphicsUtil.shapeFromSize(1, 18, 0xFFFFFF);
			divider.x = 153;
			divider.y = 23;
			background.addChild(divider);
			
			icon = Assets.getClearIcon();
			icon.x = 164;
			icon.y = 23;
			background.addChild(icon);
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(icon, 0.1, {transformAroundCenter: {scaleX: 0.5, scaleY: 0.5}});			
		}
		
		private function onUp(e:MouseEvent):void {
			this.dispatchEvent(new Event(CLEAR_TAG_EVENT));			
			TweenMax.to(icon, 0.5, {transformAroundCenter: {scaleX: 1, scaleY: 1}});		
		}	

	}
}
