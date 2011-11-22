package com.kitschpatrol.futil.tweenPlugins {
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	
	
	
	// UNDER CONSTRUCTION... faster to use custom container
	public class BitmapDataPlugin extends TweenPlugin	{
		
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility		
		
		protected var target:Bitmap;		
		protected var startBitmapData:BitmapData;
		protected var endBitmapData:BitmapData;
		
		
		public function BitmapDataPlugin() {
			super();
			this.propName = "bitmapData";
		}
		
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			if (!(target is Bitmap)) return false;
			
			this.target = target as Bitmap;

			startBitmapData = target.bitmapData.clone();
			endBitmapData = value.clone();
			
			this.overwriteProps = [this.propName];			
			return true;
			
			return false;
		}
		
		override public function set changeFactor(n:Number):void {
			
			
			//startBitmapData.
			
			//target[this.propName] = ((startR + (n * differenceR)) << 16 | (startG + (n * differenceG)) << 8 | (startB + (n * differenceB)));
		}				
	}
}