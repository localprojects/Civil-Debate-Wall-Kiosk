package com.kitschpatrol.futil {
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.core.TweenCore;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.events.Event;
	import flash.geom.Point;

	
	public class ContentAlignmentModePlugin extends TweenPlugin {
		
		public static const API:Number = 1.0;	
		
		protected var target:BlockContainer;
		protected var targetOffsetPoint:Point;
		
		private var startingOffsetX:Number;
		private var startingOffsetY:Number;
		
		private var targetOffsetX:Number;
		private var targetOffsetY:Number;
		

		// useful plugin tutorial
		// http://blog.designmarco.com/2009/11/12/greensock-tweening-platform-texteffect-plugins/
		
		public function ContentAlignmentModePlugin()	{
			super();
			this.propName = "contentPoint";
			this.overwriteProps = ["contentAlignmentMode"];
		}
		
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {	
			if (!(target is BlockContainer)) return false;

			this.target = target as BlockContainer;
	
			var alignmentModeName:String = String(value);
			
			//startingOffsetX = target

			startingOffsetX = target.contentOffsetNormalX;
			startingOffsetY = target.contentOffsetNormalY;			
			targetOffsetPoint = target.lookupAlignmentMode(alignmentModeName);
			targetOffsetX = targetOffsetPoint.x;
			targetOffsetY = targetOffsetPoint.y;
			

			
			return true;
		}		
		
		override public function set changeFactor(n:Number):void {
			
			target.lockUpdates = true;

			target.contentOffsetNormalX = startingOffsetX + ((targetOffsetX - startingOffsetX) * n);
			target.contentOffsetNormalY = startingOffsetY + ((targetOffsetY - startingOffsetY) * n);
			
			target.lockUpdates = false;
			target.update();
		}		
		
		
	}
}