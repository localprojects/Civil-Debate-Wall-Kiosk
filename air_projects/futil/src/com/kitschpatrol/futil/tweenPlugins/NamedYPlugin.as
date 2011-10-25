package com.kitschpatrol.futil.tweenPlugins {
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.core.PropTween;
	import com.greensock.plugins.TweenPlugin;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	
	import flash.display.DisplayObject;
	
	public class NamedYPlugin extends TweenPlugin {
		
		public static const API:Number = 1.0;
		public static var padding:Number = 0;
		
		public function NamedYPlugin() {
			super();
			propName = "y";
			overwriteProps = ["y"];
		}
		
		
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {	
			if (!(target is DisplayObject) || !(value is String)) return false;
			
			var targetY:Number;
	
			switch (value) {
				case Alignment.OFF_STAGE_TOP:
					targetY = -target.height - padding;
					break;				
				case Alignment.OFF_STAGE_BOTTOM:
					targetY = target.stage.stageHeight + padding;
					break;
				case Alignment.CENTER_STAGE:
					targetY = (target.stage.stageHeight - target.height) / 2;
					break;				
				default:
					// Must have been a string for a different reason
					return false;
			}
			
			addTween(target, this.propName, target[this.propName], targetY, this.propName);			
			return true;
		}
		
	}
}






