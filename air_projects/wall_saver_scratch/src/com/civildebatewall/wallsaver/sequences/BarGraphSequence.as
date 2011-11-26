package com.civildebatewall.wallsaver.sequences {
	import com.civildebatewall.resources.Assets;
	import com.civildebatewall.wallsaver.elements.GraphCounter;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quart;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	// Yes / No bar graphs
	public class BarGraphSequence extends Sprite implements ISequence {
		
		// TODO get these from back end
		private var yesResponses:int = 215;
		private var noResponses:int = 15;
		// END back end
		
		private var scrollVelocity:Number;		
		private var yesWidth:int;
		private var noWidth:int;
		private var noHead:Sprite;
		private var noTail:Sprite;
		private var yesHead:Sprite;
		private var yesTail:Sprite;
		
		private var yesBar:Sprite;
		private var noBar:Sprite;		
		
		// redux
		private var counter:GraphCounter;
		private var shader:Shader;
		private var yesShader:Shader;
		private var noShader:Shader;
		private var yesText:Bitmap;
		private var noText:Bitmap;
		private var labelLine:Bitmap;
		
		
		public function BarGraphSequence() {
			super();
			
			// Settings
			scrollVelocity = 50;
			
			// Parse stats
			var totalResponses:int = yesResponses + noResponses;
			
			// raw width
			yesWidth = Math.round((yesResponses / totalResponses) * (Main.totalWidth - Main.physicalScreenWidth)); // less one screen
			noWidth = Math.round((noResponses / totalResponses) * (Main.totalWidth - Main.physicalScreenWidth)); // less one screen			
			
			// first, find where the division between the graphs falls
			var borderIndex:int = Main.pointIsNearScreen(new Point(yesWidth + Main.physicalScreenWidth, Main.totalHeight / 2));
			var labelIndex:int;
			
			
			if (noWidth <= yesWidth) {
				// no is first, and no comes in from the right, so put it one screen to the left of the no border screen
				labelIndex = Math.max(Math.min(borderIndex - 1, 4), 0);
			}
			else {
				// yes is first, and yes comes in from the left, so put it one screen to the right of the yes border screen
				labelIndex = Math.max(Math.min(borderIndex + 1, 4), 0);
			}
			
			
			// label bar
			labelLine = new Bitmap(new BitmapData(702, 9, false, 0xffffff), PixelSnapping.ALWAYS, false);
			labelLine.x = Main.screens[labelIndex].x + 189;
			labelLine.y = (1920 / 2) - (labelLine.height / 2);
			
			// label counter
			counter = new GraphCounter();
			counter.x = Main.screens[labelIndex].x + 189;
			counter.y = labelLine.y + labelLine.height + 100;
			
			// set text blending modes


			yesText = Assets.getGraphLabelYes();
			yesText.x = labelLine.x;
						
			noText = Assets.getGraphLabelNo();
			noText.x = labelLine.x + 46; // centered			

			
			// start color set in tween
			shader = Assets.getMaskBlendFilter();
			yesShader = Assets.getMaskBlendFilter();			
			noShader = Assets.getMaskBlendFilter();			
			
			// only the line and number have dynamic shader colors
			labelLine.blendShader = shader;
			counter.blendShader = shader;
			yesText.blendShader = yesShader;
			noText.blendShader = noShader;
			
			// no graph points left
			noBar = new Sprite();
			noHead = Assets.getOrangeArrowHeadVector();
			noHead.scaleX = -1;
			noHead.x += noHead.width;
			noTail = Assets.getOrangeArrowTailVector();
			noTail.scaleX = -1;
			noBar.addChild(noHead);
			noBar.graphics.beginFill(0xf75e00);
			noBar.graphics.drawRect(noHead.width, 0, noWidth, noHead.height);
			noBar.graphics.endFill();
			noTail.x = noTail.width + noBar.width + noHead.width; // extra bump since it's flipped
			noBar.y = 123;
			noBar.alpha = 0;
			noBar.addChild(noTail);	
			
			// yes graph points right
			yesBar = new Sprite();
			yesHead = Assets.getBlueArrowHeadVector();
			yesTail = Assets.getBlueArrowTailVector();
			yesBar.addChild(yesTail);
			yesBar.graphics.beginFill(0x32b6ff);
			yesBar.graphics.drawRect(yesTail.width, 0, yesWidth, yesTail.height);
			yesBar.graphics.endFill();
			yesHead.x = yesTail.width + yesBar.width;
			yesBar.y = 123;			
			yesBar.alpha = 0;
			yesBar.addChild(yesHead);
			
			
			// make sure the bars are added
			// in the correct order
			if (noResponses <= yesResponses) {
				// no is first
				addChild(noBar);
				addChild(yesBar);				
			}
			else {
				// yes is first
				addChild(yesBar);
				addChild(noBar);				
			}			

			// depth index doesn't matter
			addChild(labelLine);
			addChild(yesText);			
			addChild(noText);	
			addChild(counter);
		}
		
		private function updateShaders():void {
			// applies updates when the data changes
			labelLine.blendShader = shader;
			counter.blendShader = shader;
			noText.blendShader = noShader;
			yesText.blendShader = yesShader;
		}
		
		
		public function getTimelineIn():TimelineMax	{
			var timelineIn:TimelineMax = new TimelineMax({useFrames: true, onUpdate: updateShaders}); // keep the shaders fresh

			
			var yesBarScrollDuration:int = (yesBar.width - yesTail.width) / scrollVelocity;			
			var yesBarTweenIn:TweenMax = TweenMax.fromTo(yesBar, yesBarScrollDuration, {x: -yesBar.width + Main.physicalScreenWidth}, {x: -yesTail.width + Main.physicalScreenWidth, ease: Quart.easeOut});
			
			var noBarScrollDuration:int = (Main.totalWidth - Main.physicalScreenWidth - noWidth - noHead.width)  / scrollVelocity;						
			var noBarTweenIn:TweenMax = TweenMax.fromTo(noBar, noBarScrollDuration, {x: Main.totalWidth}, {x: Main.totalWidth - noWidth - noHead.width, ease: Quart.easeOut});			

			// Smaller bar scrolls in first
			if (noResponses <= yesResponses) {
				
				// No bar and label in (Design calls for steps, look sbetter simultaneously.
				
				// tween to orange, complicated because of the shader				
				
				timelineIn.appendMultiple([
					// main bar tween
					noBarTweenIn,
					TweenMax.to(noBar, 0, {alpha: 1}),
					
					// label line from white to orange
					TweenMax.fromTo(this, 60, {shaderR: 255, shaderG: 255, shaderB: 255}, {shaderR: 247, shaderG: 94, shaderB: 0, ease: Quart.easeOut}),
					
					// counter from white to orange, counts up
					TweenMax.fromTo(counter, 60, {count: 0}, {count: noResponses, ease: Quart.easeOut}),
					
					// no text from white to orange and down from the top
					TweenMax.fromTo(this, 60, {noShaderR: 255, noShaderG: 255, noShaderB: 255}, {noShaderR: 247, noShaderG: 94, noShaderB: 0, ease: Quart.easeOut}),
					TweenMax.fromTo(noText, 60, {y: -noText.height}, {y: labelLine.y - 323, ease: Quart.easeOut})
				], 0, TweenAlign.START, 0);
				
				// No label out, yes bar and label in
				timelineIn.appendMultiple([
					
					// no text to white
					TweenMax.fromTo(this, 60, {noShaderR: 247, noShaderG: 94, noShaderB: 0, ease: Quart.easeOut}, {noShaderR: 255, noShaderG: 255, noShaderB: 255}),					
					
					TweenMax.to(this, 60, {shaderR: 50, shaderG: 25582, shaderB: 255}), // tween to blue, complicated because of the shader
					TweenMax.fromTo(yesText, 60, {y: -yesText.height}, {y: labelLine.y - 323, ease: Quart.easeOut})

					//TweenMax.to(noGraphLabel, 100, {y: Main.screenHeight, ease: Quart.easeOut}),
					//TweenMax.fromTo(yesGraphLabel, 100, {count: 0}, {count: yesResponses}),		
					//TweenMax.fromTo(yesGraphLabel, 100, {y: -yesGraphLabel.height}, {y: 633, ease: Quart.easeOut})
				], 300, TweenAlign.START, 0);
					
				timelineIn.appendMultiple([
					TweenMax.to(yesBar, 0, {alpha: 1}),
					yesBarTweenIn
				], -50, TweenAlign.START, 0);
				
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
				//timelineOut.append(TweenMax.to(yesGraphLabel, 100, {alpha: 0, ease: Quart.easeIn}), 100);
			}
			else {
				// No label out
				//timelineOut.append(TweenMax.to(noGraphLabel, 100, {alpha: 0, ease: Quart.easeIn}), 100); 
			}
			
			
			// Graphs out
			var yesBarOutDuration:int = (yesBar.width - yesTail.width)  / (scrollVelocity - 10); // a bit slower to compensate for easing
			var noBarOutDuration:int = (Main.totalWidth - noWidth - noHead.width)  / (scrollVelocity - 10);
			
			timelineOut.appendMultiple([
				TweenMax.to(noBar, noBarOutDuration, {x: -noBar.width + Main.physicalScreenWidth, ease: Quart.easeIn}),
				TweenMax.to(yesBar, yesBarOutDuration, {x: Main.totalWidth, ease: Quart.easeIn})
			], 100, TweenAlign.START, 0);			
			
			timelineOut.append(TweenMax.to(noBar, 0, {alpha: 0}))
			timelineOut.append(TweenMax.to(yesBar, 0, {alpha: 0}))				

			return timelineOut;
		}
		
		public function getTimeline():TimelineMax {
			var timeline:TimelineMax = new TimelineMax({useFrames: true});
			timeline.append(getTimelineIn());
			timeline.append(getTimelineOut());
			return timeline;
		}
		
		// Accessors for tweening the shader, not ideal
		public function get shaderR():Number { return shader.data.targetColor.value[0] * 255; }
		public function set shaderR(value:Number):void { shader.data.targetColor.value[0] = value / 255; }		
		public function get shaderG():Number { return shader.data.targetColor.value[1] * 255; }
		public function set shaderG(value:Number):void { shader.data.targetColor.value[1] = value / 255; }		
		public function get shaderB():Number { return shader.data.targetColor.value[2] * 255; }
		public function set shaderB(value:Number):void { shader.data.targetColor.value[2] = value / 255; }			
		
		public function get noShaderR():Number { return noShader.data.targetColor.value[0] * 255; }
		public function set noShaderR(value:Number):void { noShader.data.targetColor.value[0] = value / 255; }		
		public function get noShaderG():Number { return noShader.data.targetColor.value[1] * 255; }
		public function set noShaderG(value:Number):void { noShader.data.targetColor.value[1] = value / 255; }		
		public function get noShaderB():Number { return noShader.data.targetColor.value[2] * 255; }
		public function set noShaderB(value:Number):void { noShader.data.targetColor.value[2] = value; }
		
		public function get yesShaderR():Number { return yesShader.data.targetColor.value[0] * 255; }
		public function set yesShaderR(value:Number):void { yesShader.data.targetColor.value[0] = value / 255; }		
		public function get yesShaderG():Number { return yesShader.data.targetColor.value[1] * 255; }
		public function set yesShaderG(value:Number):void { yesShader.data.targetColor.value[1] = value / 255; }		
		public function get yesShaderB():Number { return yesShader.data.targetColor.value[2] * 255; }
		public function set yesShaderB(value:Number):void { yesShader.data.targetColor.value[2] = value / 255; }		
				
		
	}
}