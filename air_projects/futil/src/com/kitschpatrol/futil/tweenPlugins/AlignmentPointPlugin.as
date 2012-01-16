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
	import com.kitschpatrol.futil.blocks.BlockBase;
	
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
