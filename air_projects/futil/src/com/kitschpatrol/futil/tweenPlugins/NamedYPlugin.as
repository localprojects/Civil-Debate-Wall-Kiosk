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
			var targetHeight:Number = target.height;
			
			// fix for block dimension weirdness?
			//if (target is BlockBase) targetHeight = target.contentHeight;
			
	
			switch (value) {
				case Alignment.OFF_STAGE_TOP:
					targetY = -targetHeight - padding;
					break;				
				case Alignment.OFF_STAGE_BOTTOM:
					targetY = target.stage.stageHeight + padding;
					break;
				case Alignment.CENTER_STAGE:
					targetY = (target.stage.stageHeight - targetHeight) / 2;
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






