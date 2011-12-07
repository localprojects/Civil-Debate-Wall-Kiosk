package com.civildebatewall.kiosk.legacy {
	
	import com.civildebatewall.kiosk.core.Kiosk;
	import com.civildebatewall.Utilities;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	
	import flash.display.Sprite;
	
	
	public class OldBlockBase extends Sprite {
		
		private var defaultTweenVars:Object;
		public var defaultTweenInVars:Object; // public for the drag transition... TODO better way to expose tween-in X?
		private var defaultTweenOutVars:Object;
		private var defaultDuration:Number;
		private var defaultInDuration:Number;
		private var defaultOutDuration:Number;
		public var active:Boolean; // inactive blocks are marked for tweening out on the screen
		
		
		public function OldBlockBase() {
			super();
			
			// set some default parameters, can be overriden
			defaultTweenVars = {cacheAsBitmap: true};
			defaultTweenInVars = ObjectUtil.mergeObjects(defaultTweenVars, {ease: Quart.easeOut, onInit: beforeTweenIn, onComplete: afterTweenIn});
			defaultTweenOutVars = ObjectUtil.mergeObjects(defaultTweenVars, {ease: Quart.easeOut, onInit: beforeTweenOut, onComplete: afterTweenOut});
			defaultDuration = 1;
			defaultInDuration = defaultDuration;
			defaultOutDuration = defaultDuration;
			active = false;
			
			visible = false;
		}
		
		
		// TODO add duration control?
		public function setDefaultTweenIn(duration:Number, params:Object):void {
			defaultInDuration = duration;
			defaultTweenInVars = ObjectUtil.mergeObjects(defaultTweenInVars, params);
		}
		
		public function setDefaultTweenOut(duration:Number, params:Object):void {
			defaultOutDuration = duration;
			defaultTweenOutVars = ObjectUtil.mergeObjects(defaultTweenOutVars, params);
		}				
		
		
		public function setText(s:String, instant:Boolean = false):void {
			// override me
		}		
		
		public function setBackgroundColor(c:uint, instant:Boolean = false):void {
			// override me
			
		}
		
		
		public static const CENTER:String = "center";
		public static const OFF_TOP_EDGE:String = "offTopEdge";		
		public static const OFF_RIGHT_EDGE:String = "offRightEdge";
		public static const OFF_BOTTOM_EDGE:String = "offBottomEdge";		
		public static const OFF_LEFT_EDGE:String = "offLeftEdge";
		
		// gives us custom shortcuts like "center" in the parameter list
		// note that it works on a COPY of the parameters so that they can
		// be re-calculated as the program progresses
		// could do something similar with the dynaprop plugin...
		protected function preprocessParams(params:Object):Object {
			var newParams:Object = {};
			
			for (var key:String in params) {
				// look for any special shortcuts
				// TODO wrap these in animation plugin
				if ((key == "x") && (params[key] == CENTER)) Math.round(newParams[key] = (stage.stageWidth / 2) - (width / 2));
				if ((key == "y") && (params[key] == CENTER)) Math.round(newParams[key] = (stage.stageHeight / 2) - (height / 2));
				if ((key == "x") && (params[key] == OFF_LEFT_EDGE)) newParams[key] = -width - 10;
				if ((key == "x") && (params[key] == OFF_RIGHT_EDGE)) newParams[key] = stage.stageWidth + 10;
				if ((key == "y") && (params[key] == OFF_TOP_EDGE)) newParams[key] = -height - 10;								
				if ((key == "y") && (params[key] == OFF_BOTTOM_EDGE))	newParams[key] = stage.stageHeight + 10;
			}
			
			return ObjectUtil.mergeObjects(params, newParams);
		}
		
		
		// A little tweening abstraction... sets overridable default parameters
		// manages visibility / invisibility
		protected function beforeTweenIn():void {
			this.visible = true;
			this.mouseEnabled = true;
			this.mouseChildren = true;			
		}
		
		protected function afterTweenIn():void {
			// override me
		}		
		
		
		protected function beforeTweenOut():void {
			// override me
			this.mouseEnabled = false;
			this.mouseChildren = false;			
		}
		
		
		protected function afterTweenOut():void {
			this.visible = false;
			
			// restore position so overriden out tweens restart from their canonical location
			defaultTweenOutVars.onComplete = null;
			
			TweenMax.to(this, 0, preprocessParams(defaultTweenOutVars)); // note that we have to preprocess again othwerise it will try to tween to the name shortcuts
			defaultTweenOutVars.onComplete = afterTweenOut;
		}		
		
		
		public function tween(duration:Number, params:Object):void {
			TweenMax.to(this, duration, ObjectUtil.mergeObjects(defaultTweenVars, params));
			active = true;
		}
		
		
		// Tweens to default location, or takes modifiers if called without arguments
		public function tweenIn(duration:Number = -1, params:Object = null):void {
			// THIS TRIES TO FIX THE MISSING BLOCK PROBLEM!!! // IT WORKS!s
			TweenMax.killTweensOf(this); // stop tweening out if we're tweening out, keeps afterTweenOut from firing...
			active = true;
			
			if (duration == -1) {
				duration = defaultInDuration;
			}
			
			if (params == null) {
				params = defaultTweenInVars;
			}
			else {
				params = ObjectUtil.mergeObjects(defaultTweenInVars, params);
			}
			
			params = preprocessParams(params);
			
			TweenMax.to(this, duration, params);
			
		}
		
		
		public function tweenOut(duration:Number = -1, params:Object = null):void {
			if (duration == -1) {
				duration = defaultOutDuration;
			}
			
			if (params == null) {
				params = defaultTweenOutVars;
			}
			else {
				params = ObjectUtil.mergeObjects(defaultTweenOutVars, params);
			}
			
			params = preprocessParams(params);			
			
			TweenMax.to(this, duration, params);
			active = true; // TODO WHY WAS THIS FALSE?
		}		
		
	}
}