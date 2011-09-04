package net.localprojects.elements {

	import flash.display.Bitmap;
	
	import net.localprojects.Assets;
	import net.localprojects.blocks.BlockLabel;
	import flash.text.*;

	
	public class NameTag extends BlockLabel {
		
		private var roundColon:Bitmap;
		
		// an immensely terrifying approach to give Jonathan his round colons...
		// pastes a bitmap in where the colon used to be
		// only works in nametag use case
		public function NameTag(text:String, textSize:Number, textColor:uint=0xffffff, backgroundColor:uint=0x000000, font:String=null, showBackground:Boolean=true)
		{
			super(text, textSize, textColor, backgroundColor, font, showBackground);
			roundColon = Assets.getRoundColon();
		}
		
		override public function setText(s:String, instant:Boolean=false):void {
			if (contains(roundColon)) removeChild(roundColon);
			
			super.setText(s, instant);
			
			// now strip the colon
			if (this.textField.text.indexOf(':') > -1) {
				trace("there's a colon! kill it!");
				this.textField.text = textField.text.replace(':', '');	
				
				var metrics:TextLineMetrics = textField.getLineMetrics(0);
				roundColon.x = metrics.width + this.paddingLeft - 2;
				roundColon.y = metrics.height - metrics.ascent + this.paddingTop - 2;
				addChild(roundColon);
			}
		}
	}
}