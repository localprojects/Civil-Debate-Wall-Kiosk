package com.civildebatewall.wallsaver.sequences {
	
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.data.containers.Post;
	import com.civildebatewall.wallsaver.elements.GridPortrait;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
		
	public class FaceGridSequence extends Sprite implements ISequence {
		
		private var portraitData:Array;
		private var gridCells:Array; // Internal
		
		public function FaceGridSequence()	{
			super();
		
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		private function onDataUpdate(e:Event):void {
			buildPortraits();
		}
		
		public function buildPortraits():void {
			// grid settings (make global to class?)
			var gridWidth:int = CivilDebateWall.flashSpan.settings.totalWidth - CivilDebateWall.flashSpan.settings.physicalScreenWidth;			
			var gridSpacing:Number = 30;
			var gridRows:int = 5;
			var gridCols:int = 16;
			var portraitWidth:int = 233;
			var portraitHeight:int = 311;
			var wallsaverPaddingTop:int = 123;					
			
			GraphicsUtil.removeChildren(this);
			
			var portraits:Array = [];			
			
			var borderColIndex:int = Math.round(Math2.map(CivilDebateWall.data.stats.postsYes / CivilDebateWall.data.stats.postsTotal, 0, 1, 0, gridCols - 1));			
			var middleRowIndex:int = Math.floor(gridRows / 2);
			var centerArrowHeight:int = gridRows - middleRowIndex; // TODO test this
			
			
			// create pools of yes and no posts
			var yesPosts:Vector.<Post> = new Vector.<Post>;
			var noPosts:Vector.<Post> = new Vector.<Post>;
			
			for each (var post:Post in CivilDebateWall.data.posts) {
				if (post.user.photo != null) {
					if (post.stance == Post.STANCE_YES) {
						yesPosts.push(post);
					}
					else {
						noPosts.push(post);					
					}
				}
			}
			
			for (var col:int = 0; col < gridCols; col++) {
				portraits[col] = [];
				
				var screen:Rectangle = CivilDebateWall.flashSpan.settings.screens[Math.floor(col / (gridCols / (CivilDebateWall.flashSpan.settings.screenCount - 1))) + 1];
				var screenCol:int = col % (gridCols / (CivilDebateWall.flashSpan.settings.screenCount - 1));
				var arrowHeight:int = Math2.clamp(centerArrowHeight + ((borderColIndex - col) * 2), 0, gridRows); // find out how high the arrow is in this column
				
				for (var row:int = 0; row < gridRows; row++) {
					// set stance based on border index, create an "arrow" shape
					var stance:String = Post.STANCE_NO;
					
					if ((arrowHeight > 0) && (Math.abs(row - middleRowIndex) <= Math.floor(arrowHeight / 2))) {
						stance = Post.STANCE_YES;
					}
					
					// handle low data edge cases
					if (noPosts.length == 0) stance = Post.STANCE_YES;
					if (yesPosts.length == 0) stance = Post.STANCE_NO;
					
					
					var tempPortrait:GridPortrait;
					if (stance == Post.STANCE_YES) {	
						tempPortrait = new GridPortrait(stance, yesPosts[int(CivilDebateWall.flashSpan.random.range(0, yesPosts.length - 1))].user.photo);
					}
					else {
						tempPortrait = new GridPortrait(stance, noPosts[int(CivilDebateWall.flashSpan.random.range(0, noPosts.length - 1))].user.photo);
					}
					
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
				gridTweenIn.push(TweenMax.fromTo(portrait, 40, {step: 0}, {step: 1, ease: Linear.easeNone}));
			}
			
			timelineIn.appendMultiple(gridTweenIn, 0, TweenAlign.START, 2); // compensate for steppiness
			
			
			return timelineIn;
		}
		
		private const pauseAfterPortraitsIn:int = 60;
		
		public function getTimelineOut():TimelineMax	{
			var timelineOut:TimelineMax = new TimelineMax({useFrames: true});
			
			var gridTweenOut:Array = [];
			
			for each (var portrait:GridPortrait in gridCells) {
				gridTweenOut.push(TweenMax.fromTo(portrait, 60, {step: 1}, {step: 0, ease: Expo.easeIn}));
			}
			
			timelineOut.appendMultiple(gridTweenOut, pauseAfterPortraitsIn, TweenAlign.START, 2);
			
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