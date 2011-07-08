package net.localprojects.elements {
	import com.bit101.components.Text;
	
	import flash.display.*;
	import flash.text.*;
	
	import net.localprojects.*;
	
	public class BlockLabel extends Sprite {
		
		private var content:String = "Our performance in education has been behind many countries and our youths are going to be unable to compete for jobs in the global market."; 
		private var backgroundColor:uint = 0x00b9ff;
		private var vpadding:Number = 28;
		private var hpadding:Number = 40;
		private var textWidth:Number = 915 - (hpadding * 2);
		
		private var leading:Number = 5;
		
		public function BlockLabel() {
			super();
			
			// set up the text format
			var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = false;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.size = 43;
			
			textFormat.leading = leading;
			
			// this is just to make sure line breaks are calculated reasonably
			// since Flash doesn't have line height control (just leading), there's no way
			// to center text vertically on its background. To get around this, we place the text on manually
			// drawn background shapes
			
			var tempTextField:TextField = new TextField();
			tempTextField.defaultTextFormat = textFormat;
			tempTextField.embedFonts = true;
			tempTextField.selectable = false;
			tempTextField.multiline = true;
			tempTextField.cacheAsBitmap = false;
			tempTextField.mouseEnabled = false;
			tempTextField.gridFitType = GridFitType.NONE;
			tempTextField.antiAliasType = AntiAliasType.ADVANCED;
			tempTextField.textColor = 0xffffff;
			tempTextField.width = textWidth;
			tempTextField.autoSize = TextFieldAutoSize.LEFT;
			tempTextField.wordWrap = true;
			tempTextField.text = content;
			
			
			//draw the background
			var yPos:Number = 0;			
			for (var i:int = 0; i < tempTextField.numLines; i++) {
				this.graphics.beginFill(backgroundColor);				
				
				var metrics:TextLineMetrics = tempTextField.getLineMetrics(i);				
				this.graphics.drawRect(0 - hpadding, yPos - vpadding, metrics.width + hpadding, metrics.height + vpadding);
				yPos += metrics.height;
				
				
				this.graphics.endFill();				
			}	
			
			tempTextField.x = -hpadding / 2;
			tempTextField.y = -vpadding / 2;			
			addChild(tempTextField);			
			
			this.cacheAsBitmap = true;
		}
		
		
		
		
	}
}