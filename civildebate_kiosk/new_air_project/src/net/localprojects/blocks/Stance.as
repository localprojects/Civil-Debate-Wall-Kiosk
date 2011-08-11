package net.localprojects.blocks {
	import flash.display.Sprite;
	
	import net.localprojects.Assets;
	import net.localprojects.elements.*;
	
	public class Stance extends BlockBase {
		
		// TODO extends block label instead?
		private var blockLabel:BlockLabel;
		
		public function Stance() {
			super();
			init();
		}
		
		public function init():void {
			blockLabel = new BlockLabel('', 98, 0xffffff, Assets.COLOR_YES_LIGHT);
			blockLabel.setPadding(7, 24, -2, 28);
			
			
			blockLabel.visible = true;			
			addChild(blockLabel);
		}
		
		public function setStance(s:String):void {
			if (s == 'yes') {
				setText(s);
				blockLabel.setBackgroundColor(Assets.COLOR_YES_LIGHT);
			}
			else if (s == 'no') {
				setText(s);
				blockLabel.setBackgroundColor(Assets.COLOR_NO_LIGHT);				
			}
			else {
				'Unsupported stance "' + s + '"';
			}
		}
		
		
		public function setText(s:String):void {
			blockLabel.setText(s.toUpperCase() + '!');
		}

	}
}