package com.kitschpatrol.futil.tweenPlugins {
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.kitschpatrol.futil.BlockBase;
	
	import flash.geom.Point;
	
	public class AlignmentPointPlugin extends TweenPlugin {
	
		public static const API:Number = 1.0;	
		
		protected var target:BlockBase;

		// useful plugin tutorial
		// http://blog.designmarco.com/2009/11/12/greensock-tweening-platform-texteffect-plugins/
		
		private var startPoint:Point;
		private var endPoint:Point;
		
		public function AlignmentPointPlugin()	{
			super();
			propName = "alignmentPoint";
			overwriteProps = ["alignmentPoint"];
		}
		
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {	
			if (!(target is BlockBase)) return false;
			
			this.target = target as BlockBase;
			
			startPoint = target.alignmentPoint.clone();
			endPoint = value.clone();
			
			return true;
		}		
		
		override public function set changeFactor(n:Number):void {
			target.alignmentPoint.x = startPoint.x + ((endPoint.x - startPoint.x) * n);
			target.alignmentPoint.y = startPoint.y + ((endPoint.y - startPoint.y) * n);
			target.update();
		}
		
	}
}