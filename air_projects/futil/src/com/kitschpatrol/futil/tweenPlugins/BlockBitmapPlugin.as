package com.kitschpatrol.futil.tweenPlugins {
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	
	import flash.display.Bitmap;
	
	public class BlockBitmapPlugin extends TweenPlugin {
		
		public static const API:Number = 1.0;	
		
		protected var target:BlockBitmap;
		private var originalBitmap:Bitmap;
		private var newBitmap:Bitmap;
		
		public function BlockBitmapPlugin()	{
			super();
			propName = "bitmap";
			overwriteProps = ["bitmap"];
		}
		
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {	
			if (!(target is BlockBitmap)) return false;
			
			this.target = target as BlockBitmap;
			
			originalBitmap = target.bitmap;
			newBitmap = value;
			
			var originalBitmapIndex:int = this.target.getChildIndex(target.bitmap);
			this.target.addChildAt(newBitmap, originalBitmapIndex);
			
			return true;
		}
		
		override public function set changeFactor(n:Number):void {
			originalBitmap.alpha = 1 - changeFactor;			
		}
		
	}
}