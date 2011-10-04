package com.kitschpatrol.futil {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.Kerning;
	
	
	
	
	
	
		
	
	
	public class TextBlock extends BlockContainer {

		// TODO write tween plugin
		private var _textAlignmentMode:String;
		public static const ALIGN_LEFT:String = TextFormatAlign.LEFT;
		public static const ALIGN_RIGHT:String = TextFormatAlign.RIGHT;
		public static const ALIGN_CENTER:String = TextFormatAlign.CENTER;
		public static const ALIGN_JUSTIFIED:String = TextFormatAlign.JUSTIFY;
		
		
		// size should ALWAYS be in pixels
		private var _sizeFactorGlyphs:String;
		
		// set what we will factor into size based on combination of sets
		public static const SET_OF_UPPERCASE_LETTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		public static const SET_OF_LOWERCASE_LETTERS:String = "abcdefghijklmnopqrstuvwxyz";
		public static const SET_OF_NUMBERS:String = "1234567890";
		public static const SET_OF_PUNCTUATION:String = "!;':\",.?";
		public static const SET_OF_SYMBOLS:String = "-=@#$%^&*()_+{}|[]\/<>`~";
		
		
		// Optically derrived text metrics? TODO
		private var _ascentHeight:Number; // read only
		private var _descentHeight:Number; // read only
		private var _xHeight:Number; // read only
		
		public static const SET_OF_ASCENT_LETTERS:String = "AEFHIKLMNTVWXYZ"; // NO TOP OR BOTTOM ROUNDED characters that would break the baseline
		public static const SET_OF_DESCENT_LETTERS:String = "gjpqy";
		
		// The above encompas all of ascii, here are some subsets
		public static const SET_OF_ALPHABET:String = SET_OF_UPPERCASE_LETTERS + SET_OF_LOWERCASE_LETTERS;
		public static const SET_OF_ALPHANUMERIC:String = SET_OF_ALPHABET + SET_OF_NUMBERS;
		public static const SET_OF_ASCENDERS_ONLY:String = SET_OF_UPPERCASE_LETTERS + "abcdefghiklmnorstuvwxz";
		public static const SET_OF_ALL_CHARACTERS:String = SET_OF_ALPHANUMERIC + SET_OF_PUNCTUATION + SET_OF_SYMBOLS;
		public static const SET_OF_CURRENT_CONTENT:String = "sizeForCustonSet"; // TODO resizes dynamically based on content of the text field					

		private var _text:String;
		private var _textColor:uint;
		private var _textSizePixels:Number;
		private var _textFont:String;
		private var _textLetterSpacing:Number;
		
		
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
		private var sizeMap:Vector.<TextSizeOffset>;
		private var textSizeField:int; // the text size to use in the actual field, actually index in sizeMap
		private var cropRectangle:Rectangle;
		
		
		
		
		// Constructor
		public function TextBlock(params:Object=null)	{
			super();
			
			// Required Objects
			cropRectangle = new Rectangle();
			textFormat = new TextFormat();			
			changedBounds = true;
			changedFormat = true;
			
			// Sensible defaults.
			_textAlignmentMode = ALIGN_LEFT;
			_textColor = 0x000000;
			_text = "Sample";
			_textFont = DefaultAssets.DEFAULT_FONT
			_sizeFactorGlyphs = TextBlock.SET_OF_ASCENT_LETTERS;
			_boundingMode = OPTICAL_BOUNDING;
			_textSizePixels = 20;		
			_selectable = false;	
			_textLetterSpacing = 0; 
			
			textField = generateTextField(_text, _textSizePixels);
			
			updateSizeMap();	
				
			textSizePixels = _textSizePixels;

			//regenerateTextField();
			
			// generates size map
			

			
			
			addChild(textField);
	

			setParams(params); // TODO doesn't update if null? // Get params?
		}
		
		
		override public function setParams(params:Object):void {
			// hard update
			changedBounds = true;
			changedFormat = true;
			super.setParams(params);
		}
		
		
		// clones the current text field, allow for overrides so we can probe alternative configs
		// should it take a params object instead?
		public function generateTextField(t:String = null, s:Number = -1):TextField {
			if (t == null) t = _text;
			if (s == -1) s = textSizeField; // TODO change to field?

			// format persists (for adjustment after the fact)
			textFormat.font =  _textFont;
			textFormat.align = _textAlignmentMode;
			textFormat.size = s;
			textFormat.letterSpacing = _textLetterSpacing;
			
			
			// field is overwritte
			var tempTextField:TextField = new TextField();
			tempTextField.defaultTextFormat = textFormat;
			tempTextField.embedFonts = true;
			tempTextField.selectable = _selectable;
			//tempTextField.mouseEnabled = false;
			//tempTextField.multiline = false;
			//tempTextField.gridFitType = GridFitType.PIXEL;
			tempTextField.antiAliasType = AntiAliasType.ADVANCED;
			tempTextField.autoSize = TextFieldAutoSize.LEFT;
			

			
			tempTextField.textColor = _textColor;			
			tempTextField.text = t;

			return tempTextField;
		}
		
		
		
		
		
		override internal function update():void {
			trace("Updating text");
	
			
			if (!lockUpdates) {
			
			// TODO empty text is NOT width zero!!!!
			
			
			if (changedFormat) {
				trace("Changed format");
				textField.defaultTextFormat = textFormat;			
				textField.setTextFormat(textFormat);
				changedFormat = false;
			}
			
			
			if (changedBounds) {
				// do something? different? to the parent?
				// update the crop
				
				// compensate for flash's overdraw, without masking content
				
				trace("Changed bounds");
				
				textField.x = contentOffsetX - 2;
				textField.y = contentOffsetY - sizeMap[_textSizePixels].topWhitespace;
				

				
				
//				cropRectangle.x = 2; // constant
//				cropRectangle.y = sizeMap[_textSizePixels].topWhitespace; 
//				cropRectangle.width = _textSizePixels * 10; //textField.textWidth; //textField.getBounds(this).width - 4;
//				cropRectangle.height = _textSizePixels;
//				textField.cacheAsBitmap = true;
//				textField.scrollRect = cropRectangle;
				
					
				
				
				
				
				changedBounds = false;	
				
				
			}
			
			
			
			super.update();			
			
			
			}
			else {
				trace("update was locked");
			}
			
		}		
		
		
		// TODO REIMPLEMENT PIXEL SIZE SETTER!!!
		
		
//		// Getters and setters
//		public function get textSizePixels():Number { return _textSizePixels;	}		
//		public function set textSizePixels(size:Number):void {		
//			
//			// TODO catch bounds and throw error suggesting an increase to maxSize
//			
////			// update from size map
////			var closestSize:int;
////			var closestDistance:Number = Number.MAX_VALUE;
////			var closestIndex:int;
////			
////			for (var i:int = 1; i < sizeMap.length; i++) {
////				var distance:Number = Math.abs(size - sizeMap[i].height);
////				
////				if (distance < closestDistance) {
////					closestDistance = distance;
////					closestIndex = i;
////				}
////				
////				//
////			}
////			
////			trace("Setting to field size: " + size + " via "  + closestIndex);			
////			
////			xOffset = sizeMap[closestIndex].x;
////			yOffset = sizeMap[closestIndex].y;
////			widthOffset = sizeMap[closestIndex].width; // already calculated to represent diff
////			textSizeField = closestIndex;
////			_textSizePixels = sizeMap[closestIndex].height; 
//			textSizeField = size;
//			//race("xOffset: " + sizeMap[closestIndex]);
//			
//			update();
//		}		
//		
		
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
			sizeMap = new Vector.<TextSizeOffset>(128); // TODO cut this down
			
			var glyphCanvas:BitmapData;
			var testField:TextField;
			var originalColor:uint = _textColor;
			var bounds:Rectangle;
			_textColor = 0x000000;
			
			
			sizeMap[0] = new TextSizeOffset(0, 0, 0);
			
			
			trace("Measuring  " + _sizeFactorGlyphs);
			// key: pixel size, value: field size
			for(var i:int = 1; i < 128; i++) {
				
				// for each requested size
				// test all glyphs to establish bounds				
				
				// create the text
				
				testField = generateTextField(_sizeFactorGlyphs, i);
				trace(testField.textHeight);
				
				//testField.type = TextFieldType.DYNAMIC;
				
				// render it into a bitmap and measure the margins 
				glyphCanvas = new BitmapData(testField.width, testField.height, false, 0xffffff);	
				glyphCanvas.draw(testField);
				
				//addChild(new Bitmap(glyphCanvas));
				
				
				// index the field height to the pixel height
				bounds = glyphCanvas.getColorBoundsRect(0xffffff, 0xffffff, false);
				var pixelHeight:int = bounds.height;
				sizeMap[pixelHeight] = new TextSizeOffset(i, int(bounds.top), int(bounds.bottom));
				
				
				trace("Pixel Height: " + pixelHeight + " Field Size: " + i);
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
			_textSizePixels = Math.round(size); // bounds checking
			trace("Pixel Size: " + _textSizePixels); 
			// TODO handle fractions
			// TODO handle oversize scaling
			
			
			textSizeField = sizeMap[_textSizePixels].textFieldSize;
			
			textFormat.size = textSizeField; 
			
			//textFieldtextField.size = textSizeField;
			
			
			trace("Field size: " + textSizeField );
			
			changedFormat = true;
			changedBounds = true;
			update();
		}
		
		public function get textLetterSpacing():Number	{	return _textLetterSpacing;	}		
		public function set textLetterSpacing(spacing:Number):void  {
			_textLetterSpacing = spacing;
			textFormat.letterSpacing = _textLetterSpacing; // requires format reapplication			
			changedFormat = true;
			changedBounds = true;
			update();
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
			update();
		}
		
		
		
		// compensate fot the overdraw
		override public function get width():Number {
			return this.getBounds(this).width - 4;
		}
		
		override public function get height():Number {
			return _textSizePixels;			
		}

		
		
		
	}
}