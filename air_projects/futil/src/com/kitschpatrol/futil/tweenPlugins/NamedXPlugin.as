package com.kitschpatrol.futil.tweenPlugins {
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.core.PropTween;
	import com.greensock.plugins.TweenPlugin;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	
	import flash.display.DisplayObject;
	
	public class NamedXPlugin extends TweenPlugin {
		
		public static const API:Number = 1.0;
		public static var padding:Number = 0;
		
		public function NamedXPlugin() {
			super();
			propName = "x";
			overwriteProps = ["x"];
		}
		
		
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {	
			if (!(target is DisplayObject) || !(value is String)) return false;
			
			var targetX:Number;
			
			switch (value) {
				case Alignment.OFF_STAGE_RIGHT:
					targetX = target.stage.stageWidth + padding;
					break;				
				case Alignment.OFF_STAGE_LEFT:
					targetX = -target.width - padding;
					break;
				case Alignment.CENTER_STAGE:
					targetX = (target.stage.stageWidth - target.width) / 2;
					break;								
				default:
					// Must have been a string for a different reason
					return false;
			}
			
			addTween(target, this.propName, target[this.propName], targetX, this.propName);			
			return true;
		}
		
	}
}






