package com.kitschpatrol.futil {
	import com.kitschpatrol.futil.constants.CharacterSet;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class TextBlock extends BlockBase {

		// TODO write tween plugin
		private var _textAlignmentMode:String;
		
		// size should ALWAYS be in pixels
		private var _sizeFactorGlyphs:String;
		
		
		// Optically derrived text metrics? TODO
		private var _ascentHeight:Number; // read only
		private var _descentHeight:Number; // read only
		private var _xHeight:Number; // read only
		
		private var _text:String;
		private var _textColor:uint;
		private var _textSizePixels:Number;
		private var _textFont:String;
		private var _letterSpacing:Number;
		
		// TODO Implement this
		private var _boundingMode:String;
		public static const OPTICAL_BOUNDING:String = "opticalBounding"; // use actual pixel measurement
		public static const METRIC_BOUNDING:String = "metricBounding"; // use text metrics
		
		
		// Interaction
		private var _selectable:Boolean;		
		
		// Settings
		private const maxTextSize:int = 128; // determines how large of a size we test bounds for. Higher numbers are more flexible but slower.	Max is 127.	
		
		// Guts
		public var textField:TextField;
		private var textFormat:TextFormat;
		
		// sizing
		private var sizeMap:Vector.<TextSize>;
		private var textSizeOffset:TextSize; // the text size to use in the actual field, actually index in sizeMap
		private var maxTextPixelSize:int;
		
		
		// Constructor
		public function TextBlock(params:Object=null)	{
			//super(null); // get the default block base, we'll pass params laters
			
			// Required Objects
			textFormat = new TextFormat();			
			changedBounds = true;
			changedFormat = true;
			textSizeOffset = new TextSize();
			
			// Initialization
			maxTextPixelSize = 0;
			
			// Sensible defaults.
			_textAlignmentMode = TextFormatAlign.RIGHT;
			_textColor = 0x000000;
			_text = "AA";
			_textFont = DefaultAssets.DEFAULT_FONT
			_sizeFactorGlyphs = CharacterSet.SET_OF_ASCENT_LETTERS;
			_boundingMode = OPTICAL_BOUNDING;
			_textSizePixels = 20;
			_selectable = false;	
			_letterSpacing = 0; 
			
			textField = generateTextField(_text, _textSizePixels);
			
			trace("textField");
			
			updateSizeMap();	
				
			textSizePixels = _textSizePixels;

			//regenerateTextField();
			
			
			addChild(textField);

			
			setParams(params); // TODO doesn't update if null? // Get params?
		}
		
		
		
		// clones the current text field, allow for overrides so we can probe alternative configs
		// should it take a params object instead?
		public function generateTextField(t:String = null, s:Number = -1, wordWrap:Boolean = true):TextField {
			if (t == null) t = _text;
			if (s == -1) s = textSizeOffset.textFieldSize; // TODO change to field?

			// format persists (for adjustment after the fact)
			textFormat.font =  _textFont;
			textFormat.align = _textAlignmentMode;
			textFormat.size = s;
			textFormat.letterSpacing = _letterSpacing;
			
			
			
			//textFormat.kerning = true;
			
			// field is overwritte
			var tempTextField:TextField = new TextField();
			tempTextField.defaultTextFormat = textFormat;
			tempTextField.embedFonts = true;
			tempTextField.selectable = _selectable;
			tempTextField.wordWrap = wordWrap;
			//tempTextField.mouseEnabled = false;
			tempTextField.multiline = true;
			//tempTextField.gridFitType = GridFitType.PIXEL;
			tempTextField.antiAliasType = AntiAliasType.ADVANCED;
			tempTextField.autoSize = TextFieldAutoSize.LEFT;
			tempTextField.condenseWhite = true;
			
			
			tempTextField.textColor = _textColor;			
			tempTextField.text = t;

			return tempTextField;
		}

		
		override public function update(contentWidth:Number = -1, contentHeight:Number = -1):void {
			
			if (!lockUpdates) {
			
				// TODO empty text is NOT width zero!!!!
	
				if (changedBounds) {
					// update the crop
					
					// compensate for flash's overdraw, without masking content
					lockUpdates = true;
					contentCropTop = textSizeOffset.topWhitespace;
					contentCropRight = 2;
					contentCropLeft = 2;
					contentCropBottom =textSizeOffset.bottomWhitespace;
					lockUpdates = false;
					
					// update text field dimensions
	
					// Turn auto size on and off depending on dimensinos
					
					textField.autoSize = TextFieldAutoSize.NONE;
					
					if (textField.width < minWidth) {
						

						
						//textField.autoSize = TextFieldAutoSize.NONE;
						textField.width = minWidth;	
					}
					else if (textField.width >= maxWidth) {
						//textField.autoSize = TextFieldAutoSize.NONE;
						textField.width = maxWidth;						
					}
					else {
						// between limits,
						
						
						// seems to work, but need to handle zero case
					
						// shrink to min limit so long as it's on one line
						while((textField.numLines == 1) && (textField.width > minWidth)) {
							textField.width--;
							textField.text = textField.text; // forces dimensions update							
						}
						textField.width++;
						
						
						// grow to max limit so long as it's one one line
						while ((textField.numLines > 1) && (textField.width < maxWidth)) {
							trace("Lines: " + textField.numLines);
							trace("Width: " + textField.width);
							textField.width++;
							textField.text = textField.text; // forces dimensions update
							trace("bumping...");
						}
						textField.width--;
					}				
					
					

					
					textField.height = 500;
					
					
					
					textField.cacheAsBitmap = true;
					changedBounds = false;
				}
				
				
				if (changedFormat) {
					trace("Changed format");
					textField.defaultTextFormat = textFormat;
				
					textField.setTextFormat(textFormat);
					changedFormat = false;
				}	
				
	
				super.update(contentWidth, contentHeight); // TODO pass bounds vector instead?
				

			
			}			
		}		
		
		
		
		// which glyphs should we consider in defining the "pixel size" of the text field?
		public function get sizeFactorGlyphs():String { return _sizeFactorGlyphs; }
		public function set sizeFactorGlyphs(setOfLetters:String):void {
			
			// TODO filter duplicates
			_sizeFactorGlyphs = setOfLetters;
			
			// could schedule a bunch of functions to avoid duplicate execution?
			//updateSizeMap();
			//textSize = _textSizePixels; // update to show true glyphs
			
			
			//textSizePixels = textSizePixels; 
			
			updateSizeMap();
		}
		
		
		
		
		
		
		private function updateSizeMap():void {
			trace("Building size map");
			// rebuilds size set

			// start at biggest size, generate a text field at that size
			
			// height is maximum character height (in pixels) for a given internal size
			sizeMap = new Vector.<TextSize>(128); // TODO cut this down
			
			var glyphCanvas:BitmapData;
			var testField:TextField;
			var originalColor:uint = _textColor;
			var bounds:Rectangle;
			var pixelHeight:int;
			_textColor = 0x000000;
			
			
			sizeMap[0] = new TextSize();
			
			
			trace("Measuring  " + _sizeFactorGlyphs);
			// key: pixel size, value: field size
			for(var i:int = 1; i < 128; i++) {
				
				// for each requested size
				// test all glyphs to establish bounds				
				
				// create the text
				
				testField = generateTextField(_sizeFactorGlyphs, i, false);
				trace(testField.textHeight);
				
				//testField.type = TextFieldType.DYNAMIC;
				
				// render it into a bitmap and measure the margins 
				glyphCanvas = new BitmapData(testField.width, testField.height, false, 0xffffff);	
				glyphCanvas.draw(testField);
				
				//addChild(new Bitmap(glyphCanvas));
				
				
				// index the field height to the pixel height
				bounds = glyphCanvas.getColorBoundsRect(0xffffff, 0xffffff, false);
				pixelHeight = bounds.height;
				trace("w: " + glyphCanvas.width);
				trace(bounds);
				
				
				
				sizeMap[pixelHeight] = new TextSize(pixelHeight, i, bounds.y, glyphCanvas.width - bounds.width - bounds.x, glyphCanvas.height - bounds.y - bounds.height, bounds.x);

				
				
				trace("Pixel Height: " + pixelHeight + " Field Size: " + i);
				
				if (i == 127) {
					maxTextPixelSize = pixelHeight;
				}
				
			}
			
			_textColor = originalColor;
			
			
			// clean up the size map?
			
//			var largestPixelSize:int;
//			for (var j:int = 5; j < sizeMap.length; j++) {
//				
//				// reached the end, break
//				if (sizeMap[j] == 127) {
//					largestPixelSize = j;
//					break;
//				}
//
//			}
//			


		}		
		
		

		
		
		// DIRECT
		public function get textColor():uint	{	return _textColor;	}
		public function set textColor(c:uint):void  {
			_textColor = c;
			textField.textColor = _textColor;
			// no need to update
		}
		
		private var changedBounds:Boolean;
		private var changedFormat:Boolean;
		
		
		// Format updates
		public function get textSizePixels():Number	{	return _textSizePixels;	}		
		public function set textSizePixels(size:Number):void  {
			
			// ignore negatives
			_textSizePixels = size;
			if (_textSizePixels < 0) _textSizePixels = 0; 
			
			
			
			if (_textSizePixels > maxTextPixelSize) {
				trace("Drastic measures");
				
				// get us 10 pixels (or 1?)
				textFormat.size = sizeMap[maxTextPixelSize].textFieldSize;				
				
				// Scale from the largest true text field sample we have
				var scaleFactor:Number = _textSizePixels / maxTextPixelSize;
				
				textSizeOffset = new TextSize();
				textSizeOffset.textPixelSize = _textSizePixels;
				textSizeOffset.textFieldSize = maxTextPixelSize;
				textSizeOffset.topWhitespace = Math.ceil(sizeMap[maxTextPixelSize].topWhitespace * scaleFactor);
				textSizeOffset.rightWhitespace = Math.ceil(sizeMap[maxTextPixelSize].rightWhitespace * scaleFactor);
				textSizeOffset.bottomWhitespace = Math.ceil(sizeMap[maxTextPixelSize].bottomWhitespace * scaleFactor);
				textSizeOffset.leftWhitespace = Math.ceil(sizeMap[maxTextPixelSize].leftWhitespace * scaleFactor);
				
				textField.scaleX = scaleFactor;
				textField.scaleY = scaleFactor;
				
				
			}
			else {
				// In normal TextField size range.
				textField.scaleX = 1;
				textField.scaleY = 1;
				_textSizePixels = Math2.clamp(size, 0, maxTextPixelSize);
			

				if (_textSizePixels % 1 == 0) {
					// it's whole, grab it right from the array
					textSizeOffset = sizeMap[_textSizePixels];  
				}
				else {
					// it's fractional, lerp the array
					var leftIndex:int = Math.floor(_textSizePixels);
					var rightIndex:int = Math.ceil(_textSizePixels);
					
					//trace("Finding size between " + leftIndex + " / " + sizeMap[leftIndex].textFieldSize + " and " + rightIndex + " / " + sizeMap[rightIndex].textFieldSize);
					
					//trace("Raw size: " + _textSizePixels);
					textSizeOffset = lerpTextOffsets(_textSizePixels - leftIndex, sizeMap[leftIndex], sizeMap[rightIndex]);
					
					//textSizeField = Math2.map(_textSizePixels, leftIndex, rightIndex, sizeMap[leftIndex].textFieldSize, sizeMap[rightIndex].textFieldSize);
				}
	
				
				textFormat.size = textSizeOffset.textFieldSize; 
			}

			//trace("Field size: " + textSizeOffset.textFieldSize);
			
			changedFormat = true;
			changedBounds = true;
			update();
		}
		
		public function get letterSpacing():Number	{	return _letterSpacing;	}		
		public function set letterSpacing(spacing:Number):void  {
			_letterSpacing = spacing;
			textFormat.letterSpacing = _letterSpacing; // requires format reapplication			
			changedFormat = true;
			changedBounds = true;
			update();
		}
		
		
		private function lerpTextOffsets(amount:Number, low:TextSize, high:TextSize):TextSize {
			trace("Amount : " + amount);
			var tempOffset:TextSize = new TextSize();
			tempOffset.textPixelSize = Math2.map(amount, 0, 1, low.textPixelSize, high.textPixelSize);
			tempOffset.textFieldSize = Math2.map(amount, 0, 1, low.textFieldSize, high.textFieldSize);
			tempOffset.topWhitespace = Math2.map(amount, 0, 1, low.topWhitespace, high.topWhitespace);
			tempOffset.rightWhitespace = Math2.map(amount, 0, 1, low.rightWhitespace, high.rightWhitespace);
			tempOffset.bottomWhitespace = Math2.map(amount, 0, 1, low.bottomWhitespace, high.bottomWhitespace);
			tempOffset.leftWhitespace = Math2.map(amount, 0, 1, low.leftWhitespace, high.leftWhitespace);
			return tempOffset;
		}
		
		

		
		// tween plugin overrides
		public function get textFont():String { return _textFont;	}		
		public function set textFont(fontName:String):void {
			_textFont = fontName;
			textFormat.font = _textFont; // requires format reapplication
			updateSizeMap(); // Figure out the size mapping!
			
			// update size
			var lockStatus:Boolean = lockUpdates;
			lockUpdates = true;
			textSizePixels = textSizePixels;
			lockUpdates = lockStatus;
			
			changedFormat = true;
			changedBounds = true;
			update();
		}
		
		
		
		// Tween plugin can override this (but only if duration > 0)
		public function get text():String { return _text; }
		public function set text(textContent:String):void {
			_text = textContent;
			textField.text = _text;
			
			// need to resize...
			changedBounds = true;
			update();
		}
		
		public function get textAlignmentMode():String { return _textAlignmentMode; }
		public function set textAlignmentMode(align:String):void {
			_textAlignmentMode = align;	
			// TODO animation
			changedFormat = true;
			update();
		}
		
		
		
		// Size, override to make sure the text udpates
		override public function set minWidth(width:Number):void {
			changedBounds = true;
			super.minWidth = width;
		}
		
		override public function set minHeight(height:Number):void {
			changedBounds = true;
			super.minHeight = height;
		}		
		
		override public function set maxWidth(width:Number):void {
			changedBounds = true;
			super.maxWidth = width;
		}
		
		override public function set maxHeight(width:Number):void {
			changedBounds = true;
			super.maxHeight = height;
		}				
		
		
		// compensate fot the overdraw
//		override public function get width():Number {
//			
//			
//			trace("Left whitespace: " + textSizeOffset.leftWhitespace);
//			trace("Right whitespace: " + textSizeOffset.rightWhitespace);
//			
//			return this.getBounds(this).width - _letterSpacing - 4; //extSizeOffset.leftWhitespace - textSizeOffset.rightWhitespace - 4;
//		}
//		
//		override public function get height():Number {
//			return _textSizePixels;			
//		}

		
		
		
	}
}