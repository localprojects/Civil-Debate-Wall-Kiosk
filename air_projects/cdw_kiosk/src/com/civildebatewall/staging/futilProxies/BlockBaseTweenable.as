package com.civildebatewall.staging.futilProxies {

	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	
	public class BlockBaseTweenable extends BlockBase {
		public function BlockBaseTweenable(params:Object=null) {
			super(params);
			visible = false;
		}
		
				
		
		// DUPLICATED IN OTHER PROXY CLASSES... my kingdom for multiple inheritance
		
		// Special Tweening Properties for Futil block classes
		private var defaultTweenVars:Object = {cacheAsBitmap: true};
		public var defaultTweenInVars:Object = ObjectUtil.mergeObjects(defaultTweenVars, {ease: Quart.easeOut, onInit: beforeTweenIn, onComplete: afterTweenIn}); // public for the drag transition... TODO better way to expose tween-in X?
		private var defaultTweenOutVars:Object = ObjectUtil.mergeObjects(defaultTweenVars, {ease: Quart.easeOut, onInit: beforeTweenOut, onComplete: afterTweenOut});
		private var defaultDuration:Number = 1;
		private var defaultInDuration:Number = defaultDuration;
		private var defaultOutDuration:Number = defaultDuration;
		public var active:Boolean = false; // inactive blocks are marked for tweening out on the screen
		
		// TODO add duration control?
		public function setDefaultTweenIn(duration:Number, params:Object):void {
			defaultInDuration = duration;
			defaultTweenInVars = ObjectUtil.mergeObjects(defaultTweenInVars, params);
		}
		
		public function setDefaultTweenOut(duration:Number, params:Object):void {
			defaultOutDuration = duration;
			defaultTweenOutVars = ObjectUtil.mergeObjects(defaultTweenOutVars, params);
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
			TweenMax.to(this, 0, defaultTweenOutVars); // note that we have to preprocess again othwerise it will try to tween to the name shortcuts
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
			if (duration == -1) duration = defaultOutDuration;			
			params = (params == null) ? defaultTweenOutVars : ObjectUtil.mergeObjects(defaultTweenInVars, params);			
			params = params;
			TweenMax.to(this, duration, params);
		}
		
		public function tweenOut(duration:Number = -1, params:Object = null):void {
			if (duration == -1) duration = defaultOutDuration;
			params = (params == null) ? defaultTweenOutVars : ObjectUtil.mergeObjects(defaultTweenOutVars, params); 
			params = params;
			TweenMax.to(this, duration, params);
			active = true; // TODO WHY WAS THIS FALSE?
		}						
		
	}
}