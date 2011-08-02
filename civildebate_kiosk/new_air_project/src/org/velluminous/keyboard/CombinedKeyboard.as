/**
 * Alphanumeric keyboard that allows one to switch between qwerty and numeric 
 */
package org.velluminous.keyboard {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class CombinedKeyboard extends Sprite {
		private var ak:AlphabeticKeyboard;
		private var nk:NumericKeyboard;
		private var w:Number = 10 * 1.4;
		private var h:Number = 10 * 1.2;
		private var del_down:Boolean = false;
		private var millisAtPress:Number = 0;
		private var str:String;
		
		public function CombinedKeyboard() {
			super();
			init();
		}
		
		private function init():void {
			str = '';
			
			ak = new AlphabeticKeyboard();
			nk = new NumericKeyboard();
			
			ak.addEventListener(KeyButtonEvent.PRESS, handleKeyPress);
			nk.addEventListener(KeyButtonEvent.PRESS, handleKeyPress);
			ak.addEventListener(KeyButtonEvent.RELEASE, handleKeyRelease);
			nk.addEventListener(KeyButtonEvent.RELEASE, handleKeyRelease);			
			
			addChild(ak);			
		}

		private function handleKeyPress(e:KeyButtonEvent):void {
			var data:String = e.data;
			trace("handlekeypress: " + data);
			if (data == "DEL") {
				this.del_down = true;
				this.millisAtPress = getTimer();
				this.addEventListener(Event.ENTER_FRAME, handleEnter);
			} 
			else {
				// ?
			}
		}
		
		private function handleEnter(e:Event):void	{
			var t:Number = getTimer();
			if (t - this.millisAtPress > 1000) {
				// deleteChar();
				// TODO
				trace("delete");
			}
		}
		
		private function handleKeyRelease(e:KeyButtonEvent):void {
			var data:String = e.data;
			
			switch (data) {
				case ".?123":
				this.removeChild(ak);
				this.addChild(nk);
				break;
				
				case "ABC":
				this.removeChild(nk);
				this.addChild(ak);
				break;
				
				case "space":
				str += " ";
				break;
				
				case "DEL":
				break;
				
				default:
				str += (data.toLowerCase());
				
			}
			
			trace(data);
			if (del_down) {
				del_down = false;
				deleteChar();
				removeEventListener(Event.ENTER_FRAME, handleEnter);
			}
			
			trace(str);
		}

		

		private function deleteChar():void
		{
			trace("deletechar");
			str = str.substring(0, str.length - 1);
			trace(str);
		}
		
	}
}