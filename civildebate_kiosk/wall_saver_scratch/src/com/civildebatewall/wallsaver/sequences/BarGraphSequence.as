package com.civildebatewall.wallsaver.sequences {
	import com.civildebatewall.wallsaver.elements.GraphLabel;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
	import com.civildebatewall.resources.Assets;
	
	public class BarGraphSequence extends Sprite implements ISequence {
		
		
		
		// TODO get these from back end
		private var yesResponses:int = 215;
		private var noResponses:int = 15;
		
		
		
		private var scrollVelocity:Number;		
		private var yesWidth:int;
		private var noWidth:int;
		private var noHead:Bitmap;
		private var noTail:Bitmap;
		private var yesHead:Bitmap;
		private var yesTail:Bitmap;
		
		
		private var yesBar:Sprite;
		private var noBar:Sprite;		
		private var yesGraphLabel:GraphLabel;
		private var noGraphLabel:GraphLabel;
		
		
		
		
		public function BarGraphSequence() {
			super();
			
			// Settings
			scrollVelocity = 50;
			
			// Parse stats
			var totalResponses:int = yesResponses + noResponses;
			
			// raw width
			yesWidth = Math.round((yesResponses / totalResponses) * Main.totalWidth);
			noWidth = Math.round((noResponses / totalResponses) * Main.totalWidth);			
			
			// first, find where the division between the graphs falls
			var borderIndex:int = Main.pointIsNearScreen(new Point(yesWidth, Main.totalHeight / 2));
			var labelIndex:int;
			
			
			if (noWidth <= yesWidth) {
				// no is first, and no comes in from the right, so put it one screen to the left of the no border screen
				labelIndex = Math.max(Math.min(borderIndex - 1, 4), 0);
			}
			else {
				// yes is first, and yes comes in from the left, so put it one screen to the right of the yes border screen
				labelIndex = Math.max(Math.min(borderIndex + 1, 4), 0);
			}
			
			
			yesGraphLabel = new GraphLabel("yes");
			noGraphLabel = new GraphLabel("no");
			
			// Set text position
			yesGraphLabel.x = Main.screens[labelIndex].x + 189;
			noGraphLabel.x = Main.screens[labelIndex].x + 189;
			
			addChild(yesGraphLabel);
			addChild(noGraphLabel);
			
			// set text blending modes
			var yesShader:Shader = Assets.getMaskBlendFilter();
			yesShader.data.targetColor.value[0] = 50 / 255;
			yesShader.data.targetColor.value[1] = 182 / 255;
			yesShader.data.targetColor.value[2] = 255 / 255;
			yesGraphLabel.blendShader = yesShader;
			
			var noShader:Shader = Assets.getMaskBlendFilter();
			noShader.data.targetColor.value[0] = 247 / 255;
			noShader.data.targetColor.value[1] = 94 / 255;
			noShader.data.targetColor.value[2] = 0 / 255;
			noGraphLabel.blendShader = noShader;			
			

			
			// no points left
			noBar = new Sprite();
			noHead = Assets.getOrangeArrowHead();
			noHead.scaleX = -1;
			noHead.x += noHead.width;
			noTail = Assets.getOrangeArrowTail();
			noTail.scaleX = -1;
			noBar.addChild(noHead);
			noBar.graphics.beginFill(0xf75e00);
			noBar.graphics.drawRect(noHead.width, 0, noWidth, noHead.height);
			noBar.graphics.endFill();
			noTail.x = noTail.width + noBar.width;
			noBar.addChild(noTail);	
			
			// yes points right
			yesBar = new Sprite();
			yesHead = Assets.getBlueArrowHead();
			yesTail = Assets.getBlueArrowTail();
			yesBar.addChild(yesTail);
			yesBar.graphics.beginFill(0x32b6ff);
			yesBar.graphics.drawRect(yesTail.width, 0, yesWidth, yesTail.height);
			yesBar.graphics.endFill();
			yesHead.x = yesBar.width;
			yesBar.addChild(yesHead);
			
			
			// make sure the bars are added
			// in the correct order
			if (noResponses <= yesResponses) {
				// no is first
				addChild(yesBar);
				addChild(noBar);
			}
			else {
				// yes is first
				addChild(noBar);
				addChild(yesBar);
			}			

			// depth index doesn't matter
			addChild(yesGraphLabel);
			addChild(noGraphLabel);			
		}
		
		
		public function getTimelineIn():TimelineMax	{
			var timelineIn:TimelineMax = new TimelineMax({useFrames: true});

			
			var yesBarScrollDuration:int = (yesBar.width - yesTail.width)  / scrollVelocity;			
			var yesBarTweenIn:TweenMax = TweenMax.fromTo(yesBar, yesBarScrollDuration, {x: -yesBar.width}, {x: -yesTail.width});
			
			var noBarScrollDuration:int = (Main.totalWidth - noWidth - noHead.width)  / scrollVelocity;						
			var noBarTweenIn:TweenMax = TweenMax.fromTo(noBar, noBarScrollDuration, {x: Main.totalWidth}, {x: Main.totalWidth - noWidth - noHead.width});			

			// Smalles bar scrolls in first
			if (noResponses <= yesResponses) {
				
				// No bar in
				timelineIn.append(noBarTweenIn);
				
				// No label in
				timelineIn.append(TweenMax.fromTo(noGraphLabel, 100, {y: -noGraphLabel.height, count: 0}, {y: 633, count: noResponses}), -20);
				
				// No label out, yes label in
				timelineIn.appendMultiple([
					TweenMax.to(noGraphLabel, 100, {y: Main.screenHeight}),
					TweenMax.fromTo(yesGraphLabel, 100, {y: -yesGraphLabel.height, count: 0}, {y: 633, count: yesResponses})
				], 300, TweenAlign.START, 0);
				
				// Yes bar in
				timelineIn.append(yesBarTweenIn);				
			}
			else {
				// TODO after above is solid				
			}


			return timelineIn;
		}
		
		public function getTimelineOut():TimelineMax {

			var timelineOut:TimelineMax = new TimelineMax({useFrames: true});			

			
			if (noResponses <= yesResponses) {
				// Yes Label out
				timelineOut.append(TweenMax.to(yesGraphLabel, 100, {alpha: 0}), 100);
			}
			else {
				// No label out
				// TODO 
			}
			
			
			// Graphs out
			var yesBarOutDuration:int = (yesBar.width - yesTail.width)  / scrollVelocity;			
			var noBarOutDuration:int = (Main.totalWidth - noWidth - noHead.width)  / scrollVelocity;
			
			timelineOut.appendMultiple([
				TweenMax.to(noBar, 400, {x: -noBar.width}),
				TweenMax.to(yesBar, 400, {x: Main.totalWidth})
			], 0, TweenAlign.START, 100);			
			

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