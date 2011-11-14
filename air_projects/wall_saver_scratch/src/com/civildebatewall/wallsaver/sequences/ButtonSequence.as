package com.civildebatewall.wallsaver.sequences {
	import com.civildebatewall.wallsaver.elements.JoinButton;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.data.TweenMaxVars;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	

	public class ButtonSequence extends Sprite implements ISequence {
		
		private var overlays:Vector.<Shape>;
		private var buttons:Vector.<BlockText>;
		
		
		public function ButtonSequence() {
			// Build objects
		
			// Draw the white overlays
			overlays = new Vector.<Shape>(Main.screens.length);
			buttons = new Vector.<BlockText>(Main.screens.length);
			
			for (var i:int = 0; i < Main.screens.length; i++) {
				overlays[i] = GraphicsUtil.shapeFromRect(Main.screens[i], 0xffffff);
				
				buttons[i] = new JoinButton();
				buttons[i].x = Main.screens[i].right - 30; // issues with inconsistent initial X? check futil?
			}
		
			
			// Add them to the Sprite
			for each (var shape:Shape in overlays) addChild(shape);
			for each (var button:BlockText in buttons) addChild(button);
		}
		
		
		public function getTimelineIn():TimelineMax {
			var timelineIn:TimelineMax = new TimelineMax({useFrames: true});
			
			// Overlays block out the background TODO break into own squence?
			var overlayTweens:Array = [];
			for (var i:int = overlays.length - 1; i >= 0; i--) {
				overlayTweens.push(TweenMax.fromTo(overlays[i], 90, {alpha: 0}, {alpha: 1, ease: Quad.easeIn}));
			}
			

			timelineIn.appendMultiple(overlayTweens, 0, TweenAlign.START, 20);
			
			// Buttons
			var buttonTweens:Array = [];
			for (var j:int = 0; j < buttons.length; j++) {
				buttonTweens.push(TweenMax.fromTo(buttons[j], 60, {y: Main.totalHeight + buttons[j].height}, {y: Main.totalHeight - 30, ease: Quint.easeOut, roundProps: ["y"]}));
			}
			
			timelineIn.appendMultiple(buttonTweens, -25, TweenAlign.START, 10);
			
			return timelineIn;
		}
		
		
		public function getTimelineOut():TimelineMax {
			var timelineOut:TimelineMax = new TimelineMax({useFrames: true});
			timelineOut = getTimelineIn();
			timelineOut.reversed = true;
			
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