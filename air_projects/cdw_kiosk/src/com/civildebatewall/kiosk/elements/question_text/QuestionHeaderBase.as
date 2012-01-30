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

package com.civildebatewall.kiosk.elements.question_text {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Shape;
	import flash.events.Event;
	
	public class QuestionHeaderBase extends BlockText	{
		
		private var _lineWidth:Number;
		private var _lineInset:Number; // distance from top / bottom
		private var _showLines:Boolean;		
		private var _lineThickness:Number;
		
		private var topLine:Shape;
		private var bottomLine:Shape;

		public function QuestionHeaderBase() {
			topLine = new Shape();
			bottomLine = new Shape();
			
			_lineWidth = 5;
			_lineInset = 30;		
			_lineThickness = 5;			
			
			super({
				backgroundColor: 0xffffff,
				backgroundAlpha: 0.85,
				text: "Waiting for question from server",
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textColor: 0x000000,
				textAlignmentMode: Alignment.TEXT_CENTER,
				alignmentPoint: Alignment.CENTER, // for the lines
				showLines: true
			});
			
			background.addChild(topLine); // in the background so it doesn't affect alignment
			background.addChild(bottomLine);			
			
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataChange);
		}
		
		public function get lineWidth():Number { return _lineWidth; }
		public function set lineWidth(value:Number):void {
			_lineWidth = value;
			drawLines();
		}
		
		public function get lineThickness():Number { return _lineThickness; }
		public function set lineThickness(value:Number):void {
			_lineThickness = value;
			drawLines();
		}		
		
		public function get lineInset():Number {return _lineInset; }
		public function set lineInset(value:Number):void {
			_lineInset = value;
			drawLines();
		}
		
		public function get showLines():Boolean { return _showLines; }
		public function set showLines(value:Boolean):void {
			_showLines = value;
			if (_showLines) {
				drawLines();
			}
			else {
				topLine.graphics.clear();
				bottomLine.graphics.clear();
			}
		}
		
		protected function drawLines():void {
			topLine.graphics.clear();
			topLine.graphics.beginFill(Assets.COLOR_YES_LIGHT);
			topLine.graphics.drawRect(0, 0, _lineWidth, _lineThickness);
			topLine.graphics.endFill();
			topLine.x = (width - _lineWidth) / 2;
			topLine.y = _lineInset;
			
			bottomLine.graphics.clear();
			bottomLine.graphics.beginFill(Assets.COLOR_NO_LIGHT);
			bottomLine.graphics.drawRect(0, 0, _lineWidth, _lineThickness);
			bottomLine.graphics.endFill();
			bottomLine.x = topLine.x;
			bottomLine.y = height - _lineInset;
		}

		private function onDataChange(e:Event):void {
			text = CivilDebateWall.state.activeQuestion.text;
		}
		
	}
}
