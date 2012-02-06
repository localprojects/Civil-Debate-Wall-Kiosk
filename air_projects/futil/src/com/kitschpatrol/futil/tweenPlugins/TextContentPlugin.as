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
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	
	import flash.text.TextField;

	public class TextContentPlugin extends TweenPlugin {
		
		public static const API:Number = 1.0;	
		
		protected var target:BlockText;
		protected var oldText:TextField;

		private var oldContentWidth:Number;
		private var oldContentHeight:Number;		
		private var newContentWidth:Number;
		private var newContentHeight:Number;
		
		private var oldFields:Array;
		private var oldAlphas:Array;
		
		private var originalOnComplete:Function;
	
		// useful plugin tutorial
		// http://blog.designmarco.com/2009/11/12/greensock-tweening-platform-texteffect-plugins/
		
		public function TextContentPlugin()	{
			super();
			this.propName = "text";
			this.overwriteProps = ["text"];
		}
		
		// How to pass in multiple params?
		// SEE _propNames usage in BevelFilterPlugin.as
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {	
			if (!(target is BlockText)) return false;
			
			this.target = target as BlockText;
			
			oldFields = [];
			oldAlphas = [];
			
			// put old text  in a new field
			oldText = target.generateTextField(this.target.text);

			// set the text field dimensions
			oldText.width = target.textField.width;
			oldText.height = target.textField.height;
			
			// get the starting dimensions
			oldContentWidth = this.target.contentWidth;
			oldContentHeight = this.target.contentHeight;						
			
			// put the new text in the main field
			this.target.text = String(value);
			
			// remove any lingering transition text fields temporarily so we can measure target dimensinos
			for (var i:int = this.target.numChildren - 1; i >= 0; i--) {
				if ((this.target.getChildAt(i) is TextField) && ((this.target.getChildAt(i) as TextField).text != this.target.text)) {
					oldFields.push(this.target.getChildAt(i) as TextField);
					oldAlphas.push((this.target.getChildAt(i) as TextField).alpha);
					this.target.removeChildAt(i);
				}
			}			
			
			newContentWidth = this.target.contentWidth;
			newContentHeight = this.target.contentHeight;			
			
			oldFields.push(oldText);
			oldAlphas.push(1);
			
			for (var j:int = 0; j < oldFields.length; j++) {			
				this.target.addChild(oldFields[j]);
			}

			// prepare to fade in
			this.target.textField.alpha = 0;
			
			return true;
		}
		
		override public function set changeFactor(n:Number):void {
			// crossfade
			target.textField.alpha = n;
			
			for (var i:int = 0; i < oldFields.length; i++) {
				oldFields[i].alpha = Math2.map(n, 0, 1, oldAlphas[i], 0);
				
				if (oldFields[i].alpha == 0) {
					target.removeChild(oldFields[i]);
					ArrayUtil.removeElement(oldFields, oldFields[i]);
					ArrayUtil.removeElement(oldAlphas, oldAlphas[i]);
				}
			}
			
			// content size tweem
			var contentWidth:Number = oldContentWidth + ((newContentWidth - oldContentWidth) * n);
			var contentHeight:Number = oldContentHeight + ((newContentHeight - oldContentHeight) * n);			
			
			target.update(contentWidth, contentHeight);
		}		
		
		
	}
}
