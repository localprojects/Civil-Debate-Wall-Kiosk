package com.kitschpatrol.futil.tweenPlugins {
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	
	import flash.display.Bitmap;
	
	public class BlockBitmapPlugin extends TweenPlugin {
		
		public static const API:Number = 1.0;	
		
		
		protected var target:BlockBitmap;
		private var oldBitmap:Bitmap;
		
		public function BlockBitmapPlugin()	{
			super();
			propName = "bitmap";
			overwriteProps = ["bitmap"];
		}
		
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {	
			if (!(target is BlockBitmap)) return false;
			
			this.target = target as BlockBitmap;
			
			// what about size?
			oldBitmap = target.bitmap;
			target.bitmap = value;
			
			var oldBitmapIndex:int = this.target.getChildIndex(oldBitmap);
			this.target.addChildAt(target.bitmap, oldBitmapIndex);

			onComplete = onTweenComplete;
			
			return true;
		}
		
		override public function set changeFactor(n:Number):void {
			oldBitmap.alpha = 1 - n;
		}
		
		private function onTweenComplete():void {
			oldBitmap = null; // gc me
		}
		
		
		
	}
}