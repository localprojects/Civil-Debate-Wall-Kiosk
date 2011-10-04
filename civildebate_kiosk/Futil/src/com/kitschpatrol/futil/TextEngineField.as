package com.kitschpatrol.futil {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	
	public class TextEngineField extends Sprite {
		
		
		
		// Abstraction Fields
		private var _backgroundMode:String;
		public static const BACKGROUND_RAGGED_HUG:String = "raggedHug"; // background hugs text rag
		public static const BACKGROUND_CONTAINMENT_RECT:String = "containmentRect"; // background contains everyting in one rectangle
		
		private var _textAlignmentMode:String;
		public static const ALIGN_LEFT:String = TextFormatAlign.LEFT;
		public static const ALIGN_RIGHT:String = TextFormatAlign.RIGHT;
		public static const ALIGN_CENTER:String = TextFormatAlign.CENTER;
		public static const ALIGN_JUSTIFIED:String = TextFormatAlign.JUSTIFY;
		

		// size should ALWAYS be in pixels
		private var _sizeConsiderationSet:String;
		
		// set what we will factor into size based on combination of sets
		public static const SET_OF_UPPERCASE_LETTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		public static const SET_OF_LOWERCASE_LETTERS:String = "abcdefghijklmnopqrstuvwxyz";
		public static const SET_OF_NUMBERS:String = "1234567890";
		public static const SET_OF_PUNCTUATION:String = "!;':\",.?";
		public static const SET_OF_SYMBOLS:String = "-=@#$%^&*()_+{}|[]\/<>`~";
		
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
		
		// Padding
		private var _padding:Number;
		private var _paddingTopBottom:Number;
		private var _paddingLeftRight:Number;
		private var _paddingTop:Number;
		private var _paddingRight:Number;
		private var _paddingBottom:Number;
		private var _paddingLeft:Number;
		
		// Background
		private var _showBackground:Boolean;
		private var _backgroundColor:uint;
		private var _backgroundRadius:Number;
		
		
		// Border
		private var _showBorder:Boolean;
		private var _borderColor:uint;
		private var _borderThickness:Number; // pixels
		private var _borderRadius:Number;
		
		
		private var _growthAnchorMode:String; // how the text field expands to reflect changes in content
		public static const GROWTH_ANCHOR_TOP_LEFT:String = "growthAnchorTopLeft";
		public static const GROWTH_ANCHOR_TOP_RIGHT:String = "growthAnchorTopRight";
		public static const GROWTH_ANCHOR_BOTTOM_LEFT:String = "growthAnchorBottomLeft"
		public static const GROWTH_ANCHOR_BOTTOM_RIGHT:String = "growthAnchorBottomRight";
		public static const GROWTH_ANCHOR_CENTER:String = "growthAnchorCenter";
		public static const GROWTH_ANCHOR_TOP:String = "growthAnchorTop";		
		public static const GROWTH_ANCHOR_BOTTOM:String = "growthAnchorBottom";		
		
		
		private var maxSizeBehavior:String;
		public static const MAX_SIZE_CLIPS:String = "maxSizeClips"; // masks off
		public static const MAX_SIZE_TRUNCATES:String = "maxSizeTruncates"; // ellipses or whatever
		public static const MAX_SIZE_OVERFLOWS:String = "maxSizeOverflows"; // nothing happen, text just sticks out
		public static const MAX_SIZE_BREAKS_LINE:String = "maxSizeBreaksLine"; // nothing happen, text just sticks out		
		
		
		private var _minWidth:Number;
		private var _minHeight:Number;
		private var _maxWidth:Number;
		private var _maxHeight:Number;
		
		
		
		// Interaction
		private var _selectable:Boolean;
		
		
		// Settings
		private const maxTextSize:int = 128; // determines how large of a size we test bounds for. Higher numbers are more flexible but slower.	Max is 127.	
		
		// Guts
		public var textField:TextField;
		public var background:Sprite; // TODO move this to a decorator class, for development of text functions just make it intrinsic
		private var sizeMap:Vector.<Rectangle>;
		private var textSizeField:int; // the text size to use in the actual field, actually index in sizeMap
		private var xOffset:int;
		private var yOffset:int;
		private var widthOffset:int;		
		
		
		
		// Constructor		
		public function TextEngineField()	{
			super();
			
			// Specify a bunch of defaults
			background = new Sprite();
			addChild(background);

			_maxWidth = int.MAX_VALUE;
			_maxHeight = int.MAX_VALUE;
			maxSizeBehavior = MAX_SIZE_OVERFLOWS;
			
			_textAlignmentMode = ALIGN_LEFT;
			
			_paddingTop = 0;
			_paddingRight = 0;
			_paddingBottom = 0;
			_paddingLeft = 0;			
			
			_growthAnchorMode = GROWTH_ANCHOR_TOP_LEFT;
			
			_textColor = 0x000000;			
			_text = "";
			_textFont = "_sans";
			_selectable = false;
			
			
			// generates size map
			_sizeConsiderationSet = SET_OF_ALPHANUMERIC + SET_OF_PUNCTUATION;
			_textSizePixels = 20;
			
			_minWidth = 0;
			_minHeight = 0;
			
			_showBackground = false;
			_backgroundColor = 0xcccccc;
			_backgroundRadius = 0.0;
			
		}
		

		
		internal function generateTextField(t:String = null):TextField {
			if (t == null) t = _text;
			
			// format persists (for adjustment after the fact)
			var textFormat:TextFormat = new TextFormat();
			textFormat.font =  _textFont;
			textFormat.align = _textAlignmentMode;
			textFormat.size = textSizeField;
			//textFormat.letterSpacing = _textLetterSpacing;
			
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
			
			//			tempTextField.x = (_buttonWidth / 2) - (labelField.width / 2) - (strokeWeight / 2);
			//			tempTextField.y = (_buttonHeight / 2) - (labelField.height / 2) - (strokeWeight / 2);			
			
			return tempTextField;
		}
		

		private function regenerateTextField():void {
			if ((textField != null) && contains(textField)) removeChild(textField);
			textField = generateTextField();
			
			
			
			updateBoundingBox();
			addChild(textField);
		}
		
		
		
		
		private var textWidth:Number;
		private var textHeight:Number;
		
		private function updateBoundingBox():void {
			
			// true text width and height
			textWidth = textField.width - widthOffset - xOffset;
			textHeight = _textSizePixels;

			// needs extra box
			//if (minWidth > textWidth) 
			


			
			var w:int;
			var h:int;
			
			if (textWidth > maxWidth) {
				// bunch of conditionals
				if (maxSizeBehavior == MAX_SIZE_OVERFLOWS) {
					w = maxWidth;
				}
				
			}
			else if (textWidth < minWidth) {
				w = minWidth;
			}
			else {
				w = textWidth;
			}
			
			
			if (textHeight > maxHeight) {
				// bunch of conditionals
				if (maxSizeBehavior == MAX_SIZE_OVERFLOWS) {
					h = maxHeight;
				}				
			}
			else if (textHeight < minHeight) {
				h = minHeight;
			}
			else {
				h = textHeight;
			}
			
			
			
			// first, position text field to compensate for overdraw
			textField.x = -xOffset;
			textField.y = -yOffset;
									
			// compensate for growth anchor mode, too
			switch (_growthAnchorMode) {
				case GROWTH_ANCHOR_TOP_LEFT:
					// do nothing, this happens by default
					break;
				case GROWTH_ANCHOR_CENTER:
					textField.x += (w / 2) - (textWidth / 2);
					textField.y += (h / 2) - (textHeight / 2);	
					break;
				case GROWTH_ANCHOR_TOP_RIGHT:
					textField.x += w - textWidth;
					//textField.y += h - textHeight;					
					
					// TODO more cases
				default:
					// TODO error on invalud anchor mode	
			}
			
			

			// padding
			textField.x += paddingLeft;
			textField.y += paddingTop;
			w += paddingLeft + paddingRight;
			h += paddingTop + paddingBottom;
			

			// redraw the background here, for now
			background.graphics.clear();
			background.graphics.beginFill(0xff0000);
			background.graphics.drawRect(0, 0, w, h);
			background.graphics.endFill();			
		}
		

		// Getters and setters
		public function get textSizePixels():Number { return _textSizePixels;	}		
		public function set textSizePixels(size:Number):void {		
			
			// TODO catch bounds and throw error suggesting an increase to maxSize
			
			// update from size map
			var closestSize:int;
			var closestDistance:Number = Number.MAX_VALUE;
			var closestIndex:int;
			
			for (var i:int = 1; i < sizeMap.length; i++) {
				var distance:Number = Math.abs(size - sizeMap[i].height);
				
				if (distance < closestDistance) {
					closestDistance = distance;
					closestIndex = i;
				}
				
				//
			}
			
			trace("Setting to field size: " + closestIndex);			
				
			xOffset = sizeMap[closestIndex].x;
			yOffset = sizeMap[closestIndex].y;
			widthOffset = sizeMap[closestIndex].width; // already calculated to represent diff
			textSizeField = closestIndex;
			_textSizePixels = sizeMap[closestIndex].height; 
			
			trace("xOffset: " + sizeMap[closestIndex]);
			
			regenerateTextField();
		}
		
		
		// takes a size in pixels and returns a size for use with the text field that will actuall give text with that many pixels
		private function getMappedSize(rawSize:Number):Number {
//			// round for now...
//			// TODO bounds checking
//			
//			
//			
//			if (internalSize > -1) {
//				return internalSize;
//			}
//			else {
//				// find the next closest thing
//				
//				var closestSize:int;
//				var closestDistance:Number = Number.MAX_VALUE;
//				var closestIndex:int;
//				
//				for (var i:int = 0; i < sizeMap.length; i++) {
//						// todo Tweening
//					var distance:Number = Math.abs(rawSize - sizeMap[i]);
//					
//					if (distance < closestDistance) {
//						closestDistance = distance;
//						closestIndex = i;
//					}
//				}
//				
//				return closestIndex;
//			}
			
			return 0;
			
		}
		

	
		
		// which glyphs should we consider in defining the "pixel size" of the text field?
		public function get sizeFactorSet():String { return _sizeConsiderationSet; }
		public function set sizeFactorSet(setOfLetters:String):void {
			
			// TODO filter duplicates
			
			_sizeConsiderationSet = setOfLetters;
			
			// could schedule a bunch of functions to avoid duplicate execution?
			updateSizeMap();
			//textSize = _textSizePixels; // update to show true glyphs
		}
		
		
		
		private function updateSizeMap():void {
			// rebuilds size set
			var originalSize:Number = _textSizePixels;
			var originalText:String = _text;
			var originalColor:uint = _textColor;
			// start at biggest size, generate a text field at that size
			

			// x is minimum negative x offset
			// y is minimum negative y offset
			// width is minimum negative width offset
			// height is maximum character height (in pixels) for a given internal size
			sizeMap = new Vector.<Rectangle>(maxTextSize);			
			var glyphCanvas:BitmapData;
			var testField:TextField;
			var bounds:Rectangle;
			_textColor = 0x000000;
			
			// map is key: textField size | value: actual pixel size for given glyph set
			for(var i:int = 1; i < sizeMap.length; i++) {
				
				// for each requested size
				// test all glyphs to establish bounds				
				
				var minXOffset:int = int.MAX_VALUE;
				var minYOffset:int = int.MAX_VALUE;
				var minWidthOffset:int = int.MAX_VALUE;
				var maxHeight:int = int.MIN_VALUE;
				
				textSizeField = i;
				
				
				
				for (var j:int = 0; j < _sizeConsiderationSet.length; j++) {
					// go through each glyph of the consideration set,
					// draw each into a bitmap and measure the bounds to establish the
					// true dimensions of the glyph
					_text = _sizeConsiderationSet.charAt(j);
					testField = generateTextField();
					
					glyphCanvas = new BitmapData(testField.width, testField.height, false, 0xffffff);	
					glyphCanvas.draw(testField);
					bounds = glyphCanvas.getColorBoundsRect(0xffffff, 0xffffff, false);
					
					//trace("Size: " + textSizeField + " Char: " + _text+ " Bounds: " + bounds);
					
					minXOffset = Math.min(bounds.x, minXOffset);
					minYOffset = Math.min(bounds.y, minYOffset);
					minWidthOffset = Math.min(testField.width - (bounds.x + bounds.width), minWidthOffset);
					maxHeight = Math.max(bounds.height, maxHeight);							
				}
				
				sizeMap[i] = new Rectangle(minXOffset, minYOffset, minWidthOffset, maxHeight);
				trace("====== EXTREMES ====== Size: " + textSizeField + " Bounds: " + sizeMap[i]);				
								
			}			
			
			
			//addChild(new Bitmap(glyphCanvas));
			_textColor = originalColor;
			_text = originalText;
			textSizePixels = originalSize;
		}
		
		public function get minWidth():Number { return _minWidth; }
		public function set minWidth(w:Number):void {
			_minWidth = w;
			if (_minWidth > _maxWidth) _maxWidth = _minWidth; 
			updateBoundingBox(); // resize
		}
		
		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(h:Number):void {
			_minHeight = h;
			if (_minHeight > _maxHeight) _maxHeight = _minHeight;			
			updateBoundingBox(); // resize
		}		
		
		public function get maxWidth():Number { return _maxWidth; }
		public function set maxWidth(w:Number):void {
			_maxWidth = w;
			if (_maxWidth < _minWidth) _minWidth = _maxWidth;
			updateBoundingBox(); // resize
		}
		
		public function get maxHeight():Number { return _maxHeight; }
		public function set maxHeight(w:Number):void {
			_maxHeight = w;
			if (_maxHeight < _minHeight) _minHeight = _maxHeight;
			updateBoundingBox(); // resize
		}
		
		
		public function get textFont():String { return _textFont;	}		
		public function set textFont(fontName:String):void {
			_textFont = fontName;
			
			// Figure out the size mapping!
			
			// update everything
			// TODO Animation
			regenerateTextField();
		}
		
		public function get text():String { return _text; }
		public function set text(textContent:String):void {
			_text = textContent;
			
			// TODO in-situ vs. overwrite edits?
			regenerateTextField();
		}
		
		public function get textAlignmentMode():String { return _textAlignmentMode; }
		public function set textAlignmentMode(align:String):void {
			_textAlignmentMode = align;	
			// TODO animation
			regenerateTextField();
		}
		
		
		
		public function get growthAnchorMode():String { return _growthAnchorMode; }
		public function set growthAnchorMode(align:String):void {
			_growthAnchorMode = align;	
			// TODO animation
			// For animating "instant" things like this, we basicallyt have to calculate targets coordinates and then define a duration	
			regenerateTextField();
		}
		
		
		
		
		
		// Padding
		// Ready to tween
		public function get paddingTop():Number { return _paddingTop; }
		public function set paddingTop(amount:Number):void {
			_paddingTop = amount;
			updateBoundingBox();
		}
		
		public function get paddingRight():Number { return _paddingRight; }
		public function set paddingRight(amount:Number):void {
			_paddingRight = amount;
			updateBoundingBox();
		}		
		
		
		public function get paddingBottom():Number { return _paddingBottom; }
		public function set paddingBottom(amount:Number):void {
			_paddingBottom = amount;
			updateBoundingBox();
		}
		
		public function get paddingLeft():Number { return _paddingLeft; }
		public function set paddingLeft(amount:Number):void {
			_paddingLeft = amount;
			updateBoundingBox();
		}
		
		// Convenience, getters return -1 if there's not a match...
		public function get paddingTopBottom():Number {
			return (_paddingTop == _paddingBottom) ? _paddingTop : -1;
		}
		public function set paddingTopBottom(amount:Number):void {
			_paddingTop = amount;
			_paddingBottom = amount;
			updateBoundingBox();
		}
		
		public function get paddingLeftRight():Number {
			return (_paddingLeft == _paddingRight) ? _paddingLeft : -1;
		}
		public function set paddingLeftRight(amount:Number):void {
			_paddingLeft = amount;
			_paddingRight = amount;
			updateBoundingBox();
		}
		
		public function get padding():Number {
			return (paddingTopBottom == paddingLeftRight) ? _paddingLeft : -1;
		}
		public function set padding(amount:Number):void {
			_paddingTop = amount;			
			_paddingRight = amount;
			_paddingBottom = amount			
			_paddingLeft = amount;			
			updateBoundingBox();
		}		
		
		
	
	}
}