package com.civildebatewall.wallsaver.sequences {
	import com.civildebatewall.resources.Assets;
	import com.civildebatewall.wallsaver.elements.GridPortrait;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	public class FaceGridSequence extends Sprite implements ISequence {
		
		// TODO get these from back end
		private var yesResponses:int = 215;
		private var noResponses:int = 15;		
		private var portraitData:Array = [Assets.getSamplePortrait1(),
			Assets.getSamplePortrait2(),
			Assets.getSamplePortrait3(),
			Assets.getSamplePortrait4()
		];
		// END back end
		
		// Internal
		private var gridCells:Array;
		
		
		public function FaceGridSequence()	{
			super();
			
			// build the grid
			var gridSpacing:Number = 30;
			var gridRows:int = 5;
			var gridCols:int = 20;
			var portraitWidth:int = 233;
			var portraitHeight:int = 311;
			var wallsaverPaddingTop:int = 123;
			
			var totalResponses:int = yesResponses + noResponses;

			var portraits:Array = [];			
			
			
			var borderColIndex:int = Math.round(Math2.map(yesResponses / totalResponses, 0, 1, 0, gridCols - 1));			
			var middleRowIndex:int = Math.floor(gridRows / 2);
			var centerArrowHeight:int = gridRows - middleRowIndex; // TODO test this
			
			for (var col:int = 0; col < gridCols; col++) {
				portraits[col] = [];
				
				var screen:Rectangle = Main.screens[Math.floor(col / (gridCols / Main.screens.length))];
				var screenCol:int = col % (gridCols / Main.screens.length);
				var arrowHeight:int = Math2.clamp(centerArrowHeight + ((borderColIndex - col) * 2), 0, gridRows); // find out how high the arrow is in this column
				
				for (var row:int = 0; row < gridRows; row++) {
					// set stance based on border index, create an "arrow" shape
					var stance:String = "yes";
					
					if ((arrowHeight > 0) && (Math.abs(row - middleRowIndex) <= Math.floor(arrowHeight / 2))) {
						stance = "no";
					}
					
					var tempPortrait:GridPortrait = new GridPortrait(stance, ArrayUtil.getRandomElement(portraitData));
					tempPortrait.x = (gridSpacing * (screenCol + 1)) + (screenCol * portraitWidth) + screen.x;
					tempPortrait.y = (gridSpacing * row) + (row * portraitHeight) + wallsaverPaddingTop;
					
					portraits[col][row] = addChild(tempPortrait);
				}
				
				
			}
			
			// get a flat array of portraits
			gridCells = ArrayUtil.flatten(portraits);
			
			// shuffle it
			gridCells = ArrayUtil.shuffle(gridCells);			
		}
		
		
		public function getTimelineIn():TimelineMax {
			var timelineIn:TimelineMax = new TimelineMax({useFrames: true});
			
			// build the tweens
			var gridTweenIn:Array = [];
			
			for each (var portrait:GridPortrait in gridCells) {
				gridTweenIn.push(TweenMax.fromTo(portrait, 750, {step: 0}, {step: 1, ease: Linear.easeNone}));
			}
			
			timelineIn.appendMultiple(gridTweenIn, 0, TweenAlign.START, 5); // compensate for steppiness
			
			
			return timelineIn;
		}
		
		
		public function getTimelineOut():TimelineMax	{
			var timelineOut:TimelineMax = new TimelineMax({useFrames: true});
			
			var gridTweenOut:Array = [];
			
			for each (var portrait:GridPortrait in gridCells) {
				gridTweenOut.push(TweenMax.fromTo(portrait, 400, {step: 1}, {step: 0, ease: Expo.easeIn}));
			}
			
			timelineOut.appendMultiple(gridTweenOut, 100, TweenAlign.START, 5);
			
			return timelineOut;
		}
		
		
		public function getTimeline():TimelineMax {
			var timeline:TimelineMax = new TimelineMax({useFrames: true});
			timeline.append(getTimelineIn());
			timeline.append(getTimelineOut());
			return timeline;
		}		
	}
}