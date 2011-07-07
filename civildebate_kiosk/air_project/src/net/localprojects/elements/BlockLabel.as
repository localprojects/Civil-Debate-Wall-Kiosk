package net.localprojects.elements {
	import com.bit101.components.Text;
	
	import flash.display.*;
	import flash.text.*;
	
	import net.localprojects.*;
	
	public class BlockLabel extends Sprite {
		
		private var content:String = "LOREM IPSUM DOLOR SIT AMET PLURBIS UNUM A MASTERIS DAVTIS"; 
		private var backgroundColor:uint = 0xff0000;
		private var textFields:Array = [];
		private var textWidth:Number = 400;
		private var padding:Number = 20;
		
		
		public function BlockLabel() {
			super();
			
			// set up the text format
			var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = true;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.size = 36;
			
			// this is just to make sure line breaks are calculated reasonably
			// since Flash doesn't have line height control (just leading), there's no way
			// to center text vertically on its background. To get around this, we place the text on manually
			// draw background shapes
			textFormat.leftMargin = padding;
			textFormat.rightMargin = padding;
			
			var tempTextField:TextField = new TextField();
			tempTextField.defaultTextFormat = textFormat;
			tempTextField.embedFonts = true;
			tempTextField.selectable = false;
			tempTextField.multiline = true;
			tempTextField.cacheAsBitmap = false;
			tempTextField.mouseEnabled = false;
			tempTextField.backgroundColor = backgroundColor;
			tempTextField.background = true;
			tempTextField.gridFitType = GridFitType.NONE;
			tempTextField.antiAliasType = AntiAliasType.NORMAL;
			tempTextField.textColor = 0;
			tempTextField.width = textWidth;
			tempTextField.autoSize = TextFieldAutoSize.LEFT;
			tempTextField.wordWrap = true;
			tempTextField.text = content;
			
			// break up the lines
			var yPos:Number = 0;			
			for (var i:int = 0; i < tempTextField.numLines; i++) {
				var lineTextField:TextField = generateTextField(tempTextField.getLineText(i));
				var lineBackground:Sprite = new Sprite();

				// middle lines
				var backgroundWidth:Number = lineTextField.width + (padding * 2);
				var backgroundHeight:Number = lineTextField.height + padding;
				var lineTextY:Number = padding / 2;
				var lineTextX:Number = padding;
				
				if(i == 0) {
					// first line
					backgroundHeight = lineTextField.height + padding +  (padding / 2);
				}
				else if(i == tempTextField.numLines - 1) {
					// last line
					backgroundHeight = lineTextField.height + padding +  (padding / 2);
					lineTextY = 0;
				}

				
				
				lineBackground.graphics.beginFill(backgroundColor);				
				lineBackground.graphics.drawRect(0, 0, backgroundWidth, backgroundHeight);
				lineBackground.graphics.endFill();
				lineTextField.x = padding;
				lineTextField.y = lineTextY;				
				lineBackground.addChild(lineTextField);
				lineBackground.y = yPos;
				yPos+= lineBackground.height;
				addChild(lineBackground);
				
			}
			
//			var yPos:Number = 0;
//			for (var j:int = 0; j < textFields.length; j++) {
//				
//
//				textFields[j].y = yPos;
//				addChild(textFields[j]);
//				
//				yPos += textFields[j].height;
//			}
			

			

			
			//addChild();				
			
		}
		
		private function generateTextField(s:String):TextField {
			var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = true;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.size = 36;			
			
			var tempTextField:TextField = new TextField();
			tempTextField.defaultTextFormat = textFormat;
			tempTextField.embedFonts = true;
			tempTextField.selectable = false;
			tempTextField.multiline = false;
			tempTextField.cacheAsBitmap = false;
			tempTextField.mouseEnabled = false;
			tempTextField.gridFitType = GridFitType.NONE;
			tempTextField.antiAliasType = AntiAliasType.NORMAL;
			tempTextField.textColor = 0;
			tempTextField.autoSize = TextFieldAutoSize.LEFT;
			tempTextField.wordWrap = false;			
			tempTextField.text = s;
			
			return tempTextField;
		}
		
		
		
	}
}