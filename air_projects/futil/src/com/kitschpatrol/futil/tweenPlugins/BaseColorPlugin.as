package com.kitschpatrol.futil.tweenPlugins {

	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.kitschpatrol.futil.blocks.BlockBase;	
	
	
	// Adapted from Jack Doyle's HexColors Plugin
	public class BaseColorPlugin extends TweenPlugin {
		
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		protected var target:BlockBase;
		protected var startColor:uint;
		protected var endColor:uint;
		
		protected var startR:int;
		protected var startG:int;
		protected var startB:int;
		
		protected var differenceR:int;
		protected var differenceG:int;
		protected var differenceB:int;		
		
		// Tweens a color field, is not used directly... other plugins extend it. Do not use directly.
		public function BaseColorPlugin()	{
			super();
		}
		
		
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			if (!(target is BlockBase)) return false;
			
			this.target = target as BlockBase;
			startColor = target[this.propName];
			endColor = uint(value);
			
			if (startColor != endColor) {
				startR = startColor >> 16;
				startG = (startColor >> 8) & 0xff;
				startB = startColor & 0xff;
				
				differenceR = (endColor >> 16) - startR;
				differenceG = ((endColor >> 8) & 0xff) - startG;
				differenceB = (endColor & 0xff) - startB;
				this.overwriteProps = [this.propName];
				return true;
			}

			return false;
		}
		
		
		override public function set changeFactor(n:Number):void {
			target[this.propName] = ((startR + (n * differenceR)) << 16 | (startG + (n * differenceG)) << 8 | (startB + (n * differenceB)));
		}		
		
	}
}