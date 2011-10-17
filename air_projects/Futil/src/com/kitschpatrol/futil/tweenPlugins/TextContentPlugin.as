package com.kitschpatrol.futil.tweenPlugins {
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.plugins.TweenPlugin;
	import com.kitschpatrol.futil.TextBlock;
	
	import flash.text.TextField;

	

	public class TextContentPlugin extends TweenPlugin {
		
		public static const API:Number = 1.0;	
		
		protected var target:TextBlock;
		protected var oldText:TextField;

		private var oldContentWidth:Number;
		private var oldContentHeight:Number;		
		private var newContentWidth:Number;
		private var newContentHeight:Number;
		
		
		
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
			if (!(target is TextBlock)) return false;
			
			this.target = target as TextBlock;
			
			// put old text  in a new field
			oldText = target.generateTextField(this.target.text);

			// get the starting dimensions
			oldContentWidth = this.target.contentWidth;
			oldContentHeight = this.target.contentHeight;						
			
			// put the new text in the main field
			this.target.text = String(value);
			
			// get the ending dimensions
			newContentWidth = this.target.contentWidth;
			newContentHeight = this.target.contentHeight;
			
			// For now, just support crossfade
			// if MODE = "crossfade"			
			oldText.alpha = 1;
			//oldText.x = this.target.textField.x;
			//oldText.y = this.target.textField.y;
			this.target.addChild(oldText);
			
			this.target.textField.alpha = 0;
			
			
			// override oncomplete function
			this.onComplete = onCrossfadeComplete;
			
			return true;
		}
		
		private function onCrossfadeComplete():void {
			trace("crossfade complete");
			target.removeChild(oldText);
		}
		
		
		
		override public function set changeFactor(n:Number):void {
			// crossfade
			target.textField.alpha = n;
			oldText.alpha = 1 - n;
			
			// content size tweem
			var contentWidth:Number = oldContentWidth + ((newContentWidth - oldContentWidth) * n);
			var contentHeight:Number = oldContentHeight + ((newContentHeight - oldContentHeight) * n);			
			
			target.update(contentWidth, contentHeight);
		}		
		
		
	}
}