package com.civildebatewall.kiosk.elements.opinion_text {
	
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.blocks.Padding;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextLineMetrics;
	
	public class BlockTextOpinion extends BlockText	{

		// Adds background drawing and highlighting functionality to block text
		private var _highlightColor:uint;
		private var _highlightText:String;		
		private var _highlightPadding:Padding;
		private var highlightLayer:Shape;
		
		public function BlockTextOpinion(params:Object = null) {
			highlightLayer = new Shape();
			
			_highlightColor = CivilDebateWall.state.highlightWordColor;
			_highlightPadding = new Padding(8, 8, 10, 8);
			_highlightText = (CivilDebateWall.state.highlightWord == null) ? "" : CivilDebateWall.state.highlightWord;
			
			super(params);
			
			content.addChildAt(highlightLayer, getChildIndex(textField));
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			CivilDebateWall.state.addEventListener(State.ON_HIGHLIGHT_WORD_CHANGE, onHighlightChange);
		}
		
		private function onRemovedFromStage(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			CivilDebateWall.state.removeEventListener(State.ON_HIGHLIGHT_WORD_CHANGE, onHighlightChange);			
		}

		override public function update(contentWidth:Number = -1, contentHeight:Number = -1):void {
			super.update(contentWidth, contentHeight);
			drawBackground();
			drawHighlight();			
		}

		protected function drawBackground():void {
			background.graphics.clear();
			
			if (textField != null) {
				var yPos:Number = 0;			
				for (var i:int = 0; i < textField.numLines; i++) {
					var metrics:TextLineMetrics = textField.getLineMetrics(i);				
					background.graphics.beginFill(backgroundColor); // white fill for manipulation by tweenmax			
					
					if (i == 0 || i == textField.numLines - 1) {
						// first or last line
						background.graphics.drawRect(0, yPos, Math.round(metrics.width - 4) + paddingLeft + paddingRight, textSize + paddingTop + paddingBottom);
					}
					else {
						// middle line
						background.graphics.drawRect(0, yPos + 4, Math.round(metrics.width - 4) + paddingLeft + paddingRight, textSize + paddingTop + paddingBottom - 4);					
					}
					
					background.graphics.endFill();
					yPos += metrics.height;				
				}		
			}
		}
		
		private function onHighlightChange(e:Event):void {
			_highlightColor = CivilDebateWall.state.highlightWordColor;
			_highlightText = CivilDebateWall.state.highlightWord;
			update();
		}
		
		public function drawHighlight():void {
			if (textField != null) {
				
				// celar the existing highlight
				highlightLayer.graphics.clear();
				
				if ((_highlightText != null) && (_highlightText != "")) {
					// find locations
					var locations:Array = StringUtil.searchString(_highlightText, text);
					
					// draw if we found anything
					for (var i:int = 0; i < locations.length; i++) {
						drawHighlightRange(locations[i][0], locations[i][1]);
					}
				}
			}
		}

		private function drawHighlightRange(start:int, end:int):void {
			var existingText:String = text;
			var highlightArea:Rectangle = new Rectangle();

			var startBounds:Rectangle = textField.getCharBoundaries(start);
			var endBounds:Rectangle = textField.getCharBoundaries(end);
			
			highlightArea.x = startBounds.x + contentCropLeft - _highlightPadding.left;
			highlightArea.y = startBounds.y - _highlightPadding.top;
			highlightArea.width = endBounds.x - startBounds.x + _highlightPadding.horizontal;
			highlightArea.height = textSize + _highlightPadding.vertical;
			
			// draw the hilite
			highlightLayer.graphics.beginFill(_highlightColor);
			highlightLayer.graphics.drawRect(highlightArea.x, highlightArea.y, highlightArea.width, highlightArea.height);
			highlightLayer.graphics.endFill();
		}

		public function get highlightColor():uint {
			return _highlightColor;
		}		
		
		public function set highlightColor(c:uint):void {
			_highlightColor = c;
			update();			
		}

		public function get highlightText():String {
			return _highlightText;
		}		
		
		public function set highlightText(value:String):void {
			_highlightText = value;
			update();
		}
		
		public function get highlightPaddingTop():Number { return _highlightPadding.top; }
		public function set highlightPaddingTop(amount:Number):void {
			_highlightPadding.top = amount;
			update();
		}
		
		public function get highlightPaddingRight():Number { return _highlightPadding.right; }
		public function set highlightPaddingRight(amount:Number):void {
			_highlightPadding.right = amount;
			update();
		}		
		
		public function get highlightPaddingBottom():Number { return _highlightPadding.bottom; }
		public function set highlightPaddingBottom(amount:Number):void {
			_highlightPadding.bottom = amount;
			update();
		}
		
		public function get highlightPaddingLeft():Number { return _highlightPadding.left; }
		public function set highlightPaddingLeft(amount:Number):void {
			_highlightPadding.left = amount;
			update();
		}
		
		public function get highlightPadding():Number { return _highlightPadding.top;	} // TODO fix this? should really return object
		public function set highlightPadding(amount:Number):void {
			_highlightPadding.horizontal = amount;
			_highlightPadding.vertical = amount;
			update();
		}
		
	}
}
