//-------------------------------------------------------------------------------
// Copyright (c) 2012 Eric Mika
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
// 	
// 	The above copyright notice and this permission notice shall be included in 
// 	all copies or substantial portions of the Software.
// 		
// 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// 	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// 	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// 	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT 
// 	OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
// 	THE	USE OR OTHER DEALINGS IN THE SOFTWARE.
//-------------------------------------------------------------------------------

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
