package net.localprojects.blocks {

	import com.greensock.*;
	import com.greensock.data.TweenMaxVars;
	import com.greensock.easing.*;
	import com.greensock.events.TweenEvent;
	
	import fl.motion.Color;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import net.localprojects.Utilities;
	
	
	public class BlockBase extends Sprite {
		
		
		private var defaultTweenVars:Object;
		public var defaultTweenInVars:Object; // public for the drag transition... TODO better way to expose tween-in X?
		private var defaultTweenOutVars:Object;
		private var defaultDuration:Number;
		private var defaultInDuration:Number;
		private var defaultOutDuration:Number;
		public var active:Boolean; // inactive blocks are marked for tweening out on the screen 
		
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
		
		
		// A little tweening abstraction... sets overridable default parameters
		// manages visibility / invisibility
		protected function beforeTweenIn():void {
			this.visible = true;
		}
		
		protected function afterTweenIn():void {
			
		}		
		
		protected function beforeTweenOut():void {
			
		}
		
		protected function afterTweenOut():void {
			this.visible = false;
			
			// restore position so overriden out tweens restart from their canonical location
			defaultTweenOutVars.onComplete = null;
			TweenMax.to(this, 0, defaultTweenOutVars);
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
			
			TweenMax.to(this, duration, params);
			active = false; // TODO WHY WAS THIS TRUE?
		}		
		
	}
}