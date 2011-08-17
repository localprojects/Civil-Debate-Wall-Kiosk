package net.localprojects.blocks {
	import flash.display.Sprite;
	
	import net.localprojects.Assets;
	import net.localprojects.elements.*;
	
	public class Stance extends BlockBase {
		
		// TODO extends block label instead?
		private var blockLabel:BlockLabel;
		private var stance:String;
		
		
		public function Stance() {
			super();
			init();
			
		}
		
		public function init():void {
			blockLabel = new BlockLabel('', 98, 0xffffff, Assets.COLOR_YES_LIGHT);
			blockLabel.setPadding(7, 24, -2, 28);
			
			
			blockLabel.visible = true;			
			addChild(blockLabel);
			
			stance = '';			
		}
		
		public function setStance(s:String, instant:Boolean = false):void {
			
			
			if (stance != s) {
				stance = s;
			if (s == 'yes') {
				setText(s, instant);
				blockLabel.setBackgroundColor(Assets.COLOR_YES_LIGHT, instant);
			}
			else if (s == 'no') {
				setText(s, instant);
				blockLabel.setBackgroundColor(Assets.COLOR_NO_LIGHT, instant);				
			}
			else {
				'Unsupported stance "' + s + '"';
			}
			}
		}
		
		
		override public function setText(s:String, instant:Boolean = false):void {
			// TODO IMPLEMENT INSTANT?
			blockLabel.setText(s.toUpperCase() + '!', instant);
		}

	}
}