package net.localprojects.elements {
	import net.localprojects.*;
	import net.localprojects.blocks.BlockBase;
	import net.localprojects.ui.WordButton;
	
	public class WordCloud extends BlockBase {
		
		
		private var row1:Array;
		private var row2:Array;
		private var row3:Array;
		private var row4:Array;		
		
		private var words:Array;
		
		public function WordCloud()	{
			super();
			
			this.graphics.beginFill(Assets.COLOR_GRAY_5);
			this.graphics.drawRect(0, 0, 1022, 298);
			this.graphics.endFill();
			
			
		}
		
		public function setWords(source:Array):void {
			
			// TODO, call recursively until it fits?
			
			trace("Setting words from : " + source);
			
			row1 = []; 
		  row2 = []; 
			row3 = []; 
			row4 = [];
			
			words = [];
			
			var maxDifference:Number = Number.MIN_VALUE;
			var minDifference:Number = Number.MAX_VALUE;			
			var wordInfo:Object;			
			var difference:Number;
			
			// get ratio			
			for (var i:int = 0; i < source.length; i++) {
				
				wordInfo = source[i];
				
				// raw yes - no difference, will get normalized later
				difference = wordInfo['yesCases'] - wordInfo['noCases']; // higher number is more "yes", more left
				wordInfo['difference'] = difference;
				maxDifference = Math.max(difference, maxDifference);
				minDifference = Math.min(difference, minDifference);				
			}
			
			// normalalize ratio and create objects
			for(var j:int = 0; j < source.length; j++) {
				wordInfo = source[j];
				
				var normalDifference:Number = Utilities.map(wordInfo['difference'], minDifference, maxDifference, 0, 1);
				words.push(new WordButton(wordInfo['word'], normalDifference, wordInfo['threads']));			
			}
			
			
			// sort them by difference
			words = words.sortOn('_normalDifference');
			
			// do the fitting
			
			
			
			trace("Words: " + words.length);
			for (var k:int = 0; k < words.length; k += 4) {
				trace("pushing " + k);
				row1.push(words[k]);
				row2.push(words[k + 1]);
				row3.push(words[k + 2]);
				row4.push(words[k + 3]);				
			}
			
			
			
			
			positionRow(row1, 1);
			positionRow(row2, 2);
			positionRow(row3, 3);
			positionRow(row4, 4);			
			
			trace("Row length: " + row1.length);
			
			
			
			// TODO some kind of weighting system to find out which row combinations make the most sense
			//words.push(new WordButton(wordInfo['word'], 
		}
		
		private function positionRow(row:Array, rowNumber:int):void {
			
			trace("row: " + rowNumber + " " + row);
			
			rowNumber--; // zero it
			var xAccumulator:Number = 15;
			
			for(var i:int = 0; i < row.length; i++) {
				row[i].x = xAccumulator;
				xAccumulator += row[i].width + 15;
				row[i].y = (row[i].height + 15) * (rowNumber) + 15;
				row[i].visible = true;
				if (!this.contains(row[i])) addChild(row[i]);				
			}
			
			// center
			var xOffset:Number = (1022 - xAccumulator) / 2;
			
			trace("X offset: " + xOffset);
			
			for(var j:int = 0; j < row.length; j++) {
				row[j].x += xOffset;
			}
			
			if ((row[row.length - 1].x + row[row.length - 1].width) > 1022) {
				// too big, recurse
				this.removeChildAt(row.pop());
				positionRow(row, rowNumber);
			}
			
			
		}
	}
}