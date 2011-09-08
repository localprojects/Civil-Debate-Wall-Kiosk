package com.civildebatewall.elements {
	import com.civildebatewall.*;
	import com.civildebatewall.blocks.BlockBase;
	import com.civildebatewall.data.Word;
	import com.civildebatewall.ui.WordButton;
	import com.greensock.TweenMax;
	
	import flash.events.*;
	
	public class WordCloud extends BlockBase {
		
		public static const EVENT_WORD_SELECTED:String = "eventWordSelected";
		public static const EVENT_WORD_DESELECTED:String = "eventWordDeselected";		
		
		
		public var activeWord:WordButton;
		
		private var row1:Array;
		private var row2:Array;
		private var row3:Array;
		private var row4:Array;		
		
		private var wordButtons:Array = [];
		
		public function WordCloud()	{
			super();
			
			drawBackground();
			
			
		}
		
		private function drawBackground():void {
			this.graphics.beginFill(Assets.COLOR_GRAY_5);
			this.graphics.drawRect(0, 0, 1022, 299);
			this.graphics.endFill();			
		}
		
		public function setWords(source:Array):void {
			
			
			row1 = [];
			row2 = [];
			row3 = [];
			row4 = [];					
			
			this.graphics.clear();
			this.drawBackground();
			
			// TODO, call recursively until it fits?
			
			// remove existing
			// clear children
			while (this.numChildren > 0) {
				removeChild(this.getChildAt(0));
			}					
			
			trace("Setting words from : " + source);
			var word:Word;						
			var maxDifference:Number = Number.MIN_VALUE;
			var minDifference:Number = Number.MAX_VALUE;			
			var difference:Number;
			
			var wordLimit:uint = 30; // too high?
			
			// get ratio			
			for (var i:int = 0; i < Math.min(wordLimit, source.length); i++) {
				word = source[i];
				
				// raw yes - no difference, will get normalized later
				difference = word.yesCases - word.noCases; // higher number is more "yes", more left
				word.difference = difference;
				maxDifference = Math.max(difference, maxDifference);
				minDifference = Math.min(difference, minDifference);				
			}
			
			// normalalize ratio and create objects
			for(var j:int = 0; j < Math.min(wordLimit, source.length); j++) {
				word = source[j];
				word.normalDifference = Utilities.map(word.difference, minDifference, maxDifference, 0, 1);
				wordButtons.push(new WordButton(word));			
			}
			
			
			// sort them by difference
			wordButtons = wordButtons.sortOn('normalDifference', Array.DESCENDING | Array.NUMERIC);
			
			// do the fitting
			trace("Words: " + wordButtons.length);
			for (var k:int = 0; k < wordButtons.length - 4; k += 4) {
				trace("pushing " + k);
				row1.push(wordButtons[k]);
				row2.push(wordButtons[k + 1]);
				row3.push(wordButtons[k + 2]);
				row4.push(wordButtons[k + 3]);				
			}
			

			positionRow(row1, 1);
			positionRow(row2, 2);
			positionRow(row3, 3);
			positionRow(row4, 4);			
			
			trace("Row length: " + row1.length);
			
			// Add gray boxes
			addGrayBoxes(row1);
			addGrayBoxes(row2);
			addGrayBoxes(row3);
			addGrayBoxes(row4);	

			
			// Add Listeners
			for (var m:int = 0; m < wordButtons.length; m++) {
				wordButtons[m].addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				wordButtons[m].addEventListener(MouseEvent.MOUSE_DOWN, onUp);				
			}
			
			
			// TODO some kind of weighting system to find out which row combinations make the most sense
			//words.push(new WordButton(wordInfo['word'], 
		}
		
		private function addGrayBoxes(row:Array):void {
			// leading box
			if (row[0].x > 15) {
				this.graphics.beginFill(Assets.COLOR_GRAY_20);
				this.graphics.drawRect(0, row[0].y, row[0].x - 15, row[0].height);
				this.graphics.endFill();
			}
			
			// trailing box
			var lastIndex:int = row.length - 1;
			if ((row[lastIndex].x + row[lastIndex].width) < (this.width - 15)) {
				this.graphics.beginFill(Assets.COLOR_GRAY_20);
				this.graphics.drawRect(row[lastIndex].x + row[lastIndex].width + 15, row[lastIndex].y, this.width - (row[lastIndex].x + row[lastIndex].width) - 15, row[lastIndex].height);
				this.graphics.endFill();
			}			
			
		}
		
		
		private function onDown(e:MouseEvent):void {
			//fade everything else
			var selectedWord:WordButton = e.target as WordButton;
			
			
			// TODO dragable reselections
			
			if (selectedWord == activeWord) {
				// un-toggle
				deselect();
				this.dispatchEvent(new Event(EVENT_WORD_DESELECTED, true, true));			
			}			
			else {
				activeWord = selectedWord;
				
				for (var m:int = 0; m < wordButtons.length; m++) {
					if (wordButtons[m] != activeWord) {
						wordButtons[m].tween(0.5, {colorTransform: {tint: 0xffffff, tintAmount: 0.85}});
					}
					else {
						wordButtons[m].tween(0, {colorTransform: {tint: 0xffffff, tintAmount: 0}});						
					}
				}
				
				trace("selected");
				this.dispatchEvent(new Event(EVENT_WORD_SELECTED, true, true));				
			}
			
			
			
		}
		
		
		public function deselect():void {
			for (var n:int = 0; n < wordButtons.length; n++) {
				wordButtons[n].tween(0.5, {colorTransform: {tint: 0xffffff, tintAmount: 0}});
			}
			activeWord = null;
		}
		
		private function onUp(e:MouseEvent):void {
			
		}
		
		private function positionRow(row:Array, rowNumber:int):void {
			
			trace("row: " + rowNumber + " " + row);
			
			rowNumber--; // zero it
			var xAccumulator:Number = 0;
			
			for(var i:int = 0; i < row.length; i++) {
				trace(i + " / " + row.length);
				
	
				
					if (!this.contains(row[i])) addChild(row[i]);				
					
					row[i].x = xAccumulator;
					xAccumulator += row[i].width + 15;
					row[i].y = (row[i].height + 15) * (rowNumber) + 15;
					row[i].visible = true;
				
			}
			
			
			trace("Row width: " + (row[row.length - 1].x + row[row.length - 1].width));
			if ((row[row.length - 1].x + row[row.length - 1].width) > (1022 - 30)) {
				// too big, recurse
				// TODO does this work?
				trace("trimming");
				removeChild(row.pop());
				positionRow(row, ++rowNumber);
			}
			else {
				// center it, we're done
				var xOffset:Number = (1022 - (row[row.length - 1].x + row[row.length - 1].width)) / 2;
				trace("we're done... center itX offset: " + xOffset);
				for(var j:int = 0; j < row.length; j++) {
					row[j].x += xOffset;
				}				
			}
		}
	}
}