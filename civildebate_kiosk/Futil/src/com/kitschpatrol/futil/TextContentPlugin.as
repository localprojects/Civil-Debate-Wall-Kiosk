package com.kitschpatrol.futil {
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.events.Event;
	import flash.text.TextField;
	
	
	
	public class TextContentPlugin extends TweenPlugin {
		
		public static const API:Number = 1.0;	
		
		protected var target:TextEngineField;
		protected var newText:TextField;
		
		private var originalOnComplete:Function;
	
		// useful plugin tutorial
		// http://blog.designmarco.com/2009/11/12/greensock-tweening-platform-texteffect-plugins/
		
		public function TextContentPlugin()	{
			super();
			this.propName = "text";
			this.overwriteProps = ["text"];
		}
		
		
		// How to pass in multiple params?
	
		
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {	
			if (!(target is TextEngineField)) return false;
			
			//this.killProps({"text":"die"});
			
			trace("Tween value: " + value);
			
			this.target = target as TextEngineField;
			newText = target.generateTextField(String(value));
			
			// One mode for now
			// if MODE = "crossfade"
			
			newText.alpha = 0;
			newText.x = this.target.textField.x;
			newText.y = this.target.textField.y;
			this.target.addChild(newText);
			
			
			originalOnComplete = this.onComplete;
			this.onComplete = onCrossfadeComplete;
			
			TweenMax.to(this.target.textField, tween.duration, {alpha: 0});
			TweenMax.to(newText, tween.duration, {alpha: 1});			
			
			return true;
		}
		
		private function onCrossfadeComplete():void {
			trace("crossfade complete");
			target.removeChild(target.textField);
			target.textField = newText;
			
			// call original oncomplete
			//originalOnComplete();	
		}
		
		
		
		override public function set changeFactor(n:Number):void {
			trace("Change factor: " + n);
			
			//var valueA:Number = oldLength + (-oldLength * n);
			//var valueB:Number = oldLength + ((newLength - oldLength) * n);
			
			
			// Crossfade
			
			// clone the source field // IMPLEMENT CLONE METHOD!!!
			
			// fade it out
			
			
			
			// fade in the new one
			
			// background wrapper automatically reacts to resizing...

			//target.text = n.toString();
		}		
		
		
	}
}