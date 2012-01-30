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

package com.civildebatewall.kiosk.elements {

	import com.civildebatewall.Assets;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class VoteBarGraphLabel extends Sprite {
		
		public var maxScale:Number;
		public var minScale:Number;
		
		private var label:Bitmap;
		private var divider:Shape;
		private var counter:BlockText;
		
		private var _votes:int;
		
		public function VoteBarGraphLabel(label:Bitmap) {
			super();

			maxScale = 1;
			minScale = 13 / 23;			
			_votes = 0;

			// "Yes" or "No" text label
			this.label = label;
			addChild(label);

			// Dividing line
			divider = GraphicsUtil.shapeFromSize(label.width, 1, 0xFFFFFF);
			divider.y = 33;
			addChild(divider);
			
			// Numeric counter
			counter = new BlockText({
				width: label.width,
				height: 23,
				sizeFactorGlyphs: Char.SET_OF_NUMBERS,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textColor: 0xFFFFFF,
				showBackground: false,
				textAlignmentMode: Alignment.TEXT_CENTER,
				textSize: 23, 
				text: _votes.toString(),
				y: 44,
				visible: true
			});
			addChild(counter);
		}
		
		public function set votes(value:int):void {
			_votes = value;
			counter.text = _votes.toString();
		}
		
		public function get votes():int {
			return _votes;
		}
		
	}
}
