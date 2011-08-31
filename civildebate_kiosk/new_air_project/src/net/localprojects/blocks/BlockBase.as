package net.localprojects.blocks {

	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Sprite;
	
	import net.localprojects.CDW;
	import net.localprojects.Utilities;
	import net.localprojects.ui.BlockInputLabel;
	
	
	public class BlockBase extends Sprite {
		
		private var defaultTweenVars:Object;
		public var defaultTweenInVars:Object; // public for the drag transition... TODO better way to expose tween-in X?
		private var defaultTweenOutVars:Object;
		private var defaultDuration:Number;
		private var defaultInDuration:Number;
		private var defaultOutDuration:Number;
		public var active:Boolean; // inactive blocks are marked for tweening out on the screen
		protected var stageWidth:int;
		protected var stageHeight:int;
		
		
		public function BlockBase() {
			super();
			
			// set some default parameters, can be overriden
			defaultTweenVars = {};
			defaultTweenInVars = Utilities.mergeObjects(defaultTweenVars, {ease: Quart.easeOut, onInit: beforeTweenIn, onComplete: afterTweenIn});
			defaultTweenOutVars = Utilities.mergeObjects(defaultTweenVars, {ease: Quart.easeOut, onInit: beforeTweenOut, onComplete: afterTweenOut});
			defaultDuration = 1;
			defaultInDuration = defaultDuration;
			defaultOutDuration = defaultDuration;
			active = false;
			
			visible = false;
			
			// for convenience
			stageWidth = CDW.ref.stage.stageWidth;
			stageHeight = CDW.ref.stage.stageHeight;
		}
		
		
		// TODO add duration control?
		public function setDefaultTweenIn(duration:Number, params:Object):void {
			defaultInDuration = duration;
			defaultTweenInVars = Utilities.mergeObjects(defaultTweenInVars, params);
		}
		
		public function setDefaultTweenOut(duration:Number, params:Object):void {
			defaultOutDuration = duration;
			defaultTweenOutVars = Utilities.mergeObjects(defaultTweenOutVars, params);
		}				

		
		public function setText(s:String, instant:Boolean = false):void {
			// override me
		}		
		
		public function setBackgroundColor(c:uint, instant:Boolean = false):void {
			// override me
			
		}
		
		
		public static const CENTER:String = 'center';
		public static const OFF_TOP_EDGE:String = 'offTopEdge';		
		public static const OFF_RIGHT_EDGE:String = 'offRightEdge';
		public static const OFF_BOTTOM_EDGE:String = 'offBottomEdge';		
		public static const OFF_LEFT_EDGE:String = 'offLeftEdge';
		
		// gives us custom shortcuts like 'center' in the parameter list
		// note that it works on a COPY of the parameters so that they can
		// be re-calculated as the program progresses
		// could do something similar with the dynaprop plugin...
		protected function preprocessParams(params:Object):Object {
			var newParams:Object = {};
			
			for (var key:String in params) {
				// look for any special shortcuts
				if ((key == 'x') && (params[key] == CENTER)) Math.round(newParams[key] = (stageWidth / 2) - (width / 2));
				if ((key == 'y') && (params[key] == CENTER)) Math.round(newParams[key] = (stageHeight / 2) - (height / 2));
				if ((key == 'x') && (params[key] == OFF_LEFT_EDGE)) newParams[key] = -width - 10;
				if ((key == 'x') && (params[key] == OFF_RIGHT_EDGE)) newParams[key] = stageWidth + 10;
				if ((key == 'y') && (params[key] == OFF_TOP_EDGE)) newParams[key] = -height - 10;								
				if ((key == 'y') && (params[key] == OFF_BOTTOM_EDGE))	newParams[key] = stageHeight + 10;
			}
			
			return Utilities.mergeObjects(params, newParams);
		}
		
		
		// A little tweening abstraction... sets overridable default parameters
		// manages visibility / invisibility
		protected function beforeTweenIn():void {
			this.visible = true;
		}
		
		protected function afterTweenIn():void {
			// override me
		}		
		
		
		protected function beforeTweenOut():void {
			// override me			
		}
		
		
		protected function afterTweenOut():void {
			this.visible = false;
			
			// restore position so overriden out tweens restart from their canonical location
			defaultTweenOutVars.onComplete = null;
			
			TweenMax.to(this, 0, preprocessParams(defaultTweenOutVars)); // note that we have to preprocess again othwerise it will try to tween to the name shortcuts
			defaultTweenOutVars.onComplete = afterTweenOut;
		}		
		
		
		public function tween(duration:Number, params:Object):void {
			TweenMax.to(this, duration, Utilities.mergeObjects(defaultTweenVars, params));
			active = true;
		}
		
		
		// Tweens to default location, or takes modifiers if called without arguments
		public function tweenIn(duration:Number = -1, params:Object = null):void {
			
			if (duration == -1) {
				duration = defaultInDuration;
			}
			
			if (params == null) {
				params = defaultTweenInVars;
			}
			else {
				params = Utilities.mergeObjects(defaultTweenInVars, params);
			}
			
			params = preprocessParams(params);
			
			TweenMax.to(this, duration, params);
			active = true;
		}
		
		
		public function tweenOut(duration:Number = -1, params:Object = null):void {
			if (duration == -1) {
				duration = defaultOutDuration;
			}
			
			if (params == null) {
				params = defaultTweenOutVars;
			}
			else {
				params = Utilities.mergeObjects(defaultTweenOutVars, params);
			}
			
			params = preprocessParams(params);			
			
			TweenMax.to(this, duration, params);
			active = true; // TODO WHY WAS THIS FALSE?
		}		
		
	}
}