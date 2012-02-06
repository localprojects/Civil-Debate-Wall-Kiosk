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
