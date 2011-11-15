package com.kitschpatrol.futil.blocks {
	import com.kitschpatrol.futil.DefaultAssets;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.constants.Char;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import flashx.textLayout.formats.Float;
	
	public class BlockText extends BlockBase {

		// TODO write tween plugin
		private var _textAlignmentMode:String;
		
		// size should ALWAYS be in pixels
		private var _sizeFactorGlyphs:String;

		private var _text:String;
		private var _textBold:Boolean;
		private var _textColor:uint;
		private var _textSizePixels:Number;
		private var _textFont:String;
		private var _letterSpacing:Number;
		private var _leading:Number;
		private var _maxChars:int;
		private var _textAlpha:Number;
		private var _input:Boolean;

		
		// TODO Implement this... worth bothering sice text metrics are so bad?
		private var _boundingMode:String;
		public static const OPTICAL_BOUNDING:String = "opticalBounding"; // use actual pixel measurement
		public static const METRIC_BOUNDING:String = "metricBounding"; // use text metrics
		
		// Growth prioririty (buggy?)
		private var _growthMode:String;
		public static const MAXIMIZE_WIDTH:String = "maximizeWidth"; // given plent of maxWidth and maxHeight, grow the width of the text box (fewer rows of text)
		public static const MAXIMIZE_HEIGHT:String = "maximizeHeight"; // given ty of maxWidth and maxHeght, grow the height of the text box (more rows of text)
		

		// Max size behavior, specific to text. TODO Implement these!
		public static const MAX_SIZE_TRUNCATES:String = "maxSizeTruncates"; // ellipses or whatever? this is a text only option!
		public static const MAX_SIZE_RESIZES:String = "maxSizeResizes"; // reduces the textsize until it fits


		// Weird internal flash limits
		private static const MAX_TEXT_FIELD_WIDTH:Number = 107324000;
		
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
		private var fieldLeading:Number; // actual leading passed to textfield
		
		// update flags
		private var changedBounds:Boolean;
		private var changedFormat:Boolean;	
		private var changedTextField:Boolean;
		
		// size caching, automatic singleton?
		public static var sizeMaps:Object = {};
		
		public var onFocus:Vector.<Function>;
		public var onBlur:Vector.<Function>;
		public var onInput:Vector.<Function>;
		
		// Constructor
		public function BlockText(params:Object=null)	{
			//super(null); // get the default block base, we'll pass params laters
			
			// Required Objects
			textFormat = new TextFormat();			
			changedBounds = true;
			changedFormat = true;
			changedTextField = false;
			textSizeOffset = new TextSize();
			
			// Initialization
			maxTextPixelSize = 0;
			fieldLeading = 0;
			
			_maxWidth = MAX_TEXT_FIELD_WIDTH;
			
			// Sensible defaults.
			_textAlignmentMode = TextFormatAlign.LEFT;
			_textColor = 0x000000;
			_textAlpha = 1.0;
			_text = "AA";
			_textBold = false;
			_textFont = DefaultAssets.DEFAULT_FONT
			_sizeFactorGlyphs = Char.SET_OF_ASCENT_LETTERS;
			_boundingMode = OPTICAL_BOUNDING;
			_textSizePixels = 20;
			_selectable = false;	
			_letterSpacing = 0;
			_leading = 0;			
			_growthMode = MAXIMIZE_WIDTH;
			_input = false;
			_maxChars = 0; // unlimited
			
			textField = generateTextField(_text, _textSizePixels);

			updateSizeMap();	
				
			textSize = _textSizePixels;
			
			addChild(textField);
			
			onFocus = new Vector.<Function>(0);
			onBlur = new Vector.<Function>(0);
			onInput = new Vector.<Function>(0);
			
			setParams(params); // TODO doesn't update if null? // Get params?
		}
		
		
		
		// clones the current text field, allow for overrides so we can probe alternative configs
		// should it take a params object instead?
		// use "for measurement" when generating text fields for optical metric analysis
		public function generateTextField(t:String = null, s:Number = -1, forMeasurement:Boolean = false):TextField {
			if (t == null) t = _text;
			if (s == -1) s = textSizeOffset.textFieldSize; // TODO change to field?

			// format persists (for adjustment after the fact)
			textFormat.font =  _textFont;
			textFormat.align = _textAlignmentMode;
			textFormat.size = s;
			textFormat.bold = _textBold;
			
			
			if (forMeasurement) {
				textFormat.leading = 0;
				textFormat.letterSpacing = 0;
			}
			else {
				textFormat.leading = fieldLeading; // adjusted for white space
				textFormat.letterSpacing = _letterSpacing;
			}
			
			// field is overwritte
			var tempTextField:TextField = new TextField();
			
			tempTextField.defaultTextFormat = textFormat;
			tempTextField.embedFonts = true;			
			tempTextField.multiline = true;
			tempTextField.antiAliasType = AntiAliasType.ADVANCED;

			//tempTextField.mouseEnabled = false;			
			//tempTextField.gridFitType = GridFitType.PIXEL;
			tempTextField.gridFitType = GridFitType.SUBPIXEL; // word wrap fix? http://stackoverflow.com/questions/5793032/as3-textfield-antialiastype-breaks-wordwrap			
			tempTextField.condenseWhite = true;

			if (forMeasurement) {
				tempTextField.autoSize = TextFieldAutoSize.LEFT;
				tempTextField.textColor = 0x000000;
				tempTextField.wordWrap = false;
				tempTextField.selectable = false;
				tempTextField.type = TextFieldType.DYNAMIC;
				tempTextField.maxChars = -1;
			}
			else {
				tempTextField.autoSize = TextFieldAutoSize.NONE;
				tempTextField.textColor = _textColor;
				tempTextField.wordWrap = true;
				tempTextField.selectable = _selectable;
				tempTextField.type = _input ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
				if (_input)	{
					tempTextField.addEventListener(Event.CHANGE, onInputInternal);
					tempTextField.addEventListener(FocusEvent.FOCUS_IN, onFocusInternal);
					tempTextField.addEventListener(FocusEvent.FOCUS_OUT, onBlurInternal);
					this.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, onMouseFocusChangeInternal);
					this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseFocusInternal);
				}
				tempTextField.maxChars = _maxChars;
			}
			
			tempTextField.text = t;
			
			return tempTextField;
		}
		

		// width overrides are used for animation
		override public function update(contentWidth:Number = -1, contentHeight:Number = -1):void {
			if (!lockUpdates) {
				
				if (changedTextField) {
					lockUpdates = true; // make sure we don't recurse infinitely
					
					// Have to remove and -re-add to the display list
					//var depthIndex:int = getChildIndex(textField);
					
					if (content.contains(textField)) {
						// Clean up listeners
						if (textField.hasEventListener(Event.CHANGE)) textField.removeEventListener(Event.CHANGE, onInputInternal);
						if (textField.hasEventListener(FocusEvent.FOCUS_IN)) textField.removeEventListener(Event.CHANGE, onFocusInternal);
						if (textField.hasEventListener(FocusEvent.FOCUS_OUT)) textField.removeEventListener(Event.CHANGE, onBlurInternal);
						if (this.hasEventListener(MouseEvent.MOUSE_DOWN)) this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseFocusInternal);
						removeChild(textField);
					}
					textField = generateTextField();
					
					addChild(textField);
					
					changedTextField = false;
					lockUpdates = false;
					changedBounds = true; // have to recalculate bounds
				}
				
				// TODO empty text is NOT width zero!!!!
				if (changedFormat) {
					textField.defaultTextFormat = textFormat;
					textField.setTextFormat(textFormat);
					changedFormat = false;
				}
				
				
				if (changedBounds) {
					//trace("changed bounds");
					var start:int = getTimer();
					
					if ((_minWidth == _maxWidth) && (_growthMode != MAXIMIZE_HEIGHT)) {
						// TODO what about MAXIMIZE_HEIGHT mode?
						textField.width = _minWidth - _padding.horizontal;
					}	
					else {
						// grow while we still have have one line (if possible)
						// var explicitLineBreaks:int = numExplicitLines();
						
						// for some reason can't increment text field width gracefully
						// while textfield is scaled, so temporarily unscale
						var originalScale:Number = textField.scaleX;
						textField.scaleX = 1;
						textField.scaleY = 1;
						textField.text = textField.text;
						
						
						/*
						
						// text flow...
						
						
						if (maximize width...) {
						
							// first grow fat
							// while content < maxWidth, grow horizontally							
							
							// then grow tall
							// while content < maxheight, growVertically							
						
						// while content < maxheight, growVertically
						}
						else if (maximize height...) {
							
							// first grow tall
							// while content < maxheight, growVertically							
							
							
							// then grow fat						
							// while content < maxWidth, grow horizontally								
						}
						
						// then overflow if there
						
						textField.
						
						
						// then resize, if needed
						*/
						
						
						
						
						if (_growthMode == MAXIMIZE_HEIGHT) {
							// normal preparations
							textField.width = _maxWidth - _padding.horizontal;
							textField.text = textField.text;
							textField.width = Math2.clamp(getMaxLineWidth() + 5, _minWidth - _padding.horizontal, _maxWidth - _padding.horizontal);
							textField.text = textField.text;
							
							var desiredLines:int = int((_leading + (_minHeight - _padding.vertical)) / (_leading + _textSizePixels));
							trace("Desired lines for " + textField.text + ": " + desiredLines);
							//desiredLines = 3;
							
							// roughly divide the text width to get started
							
							if (desiredLines == 0) desiredLines = 1; 
							
							if (desiredLines > textField.numLines) {
								trace("Not enough lines");
								
								// jump to roughly the right width
								textField.width /= desiredLines / textField.numLines; // TODO better squaring alogithm instead of dividing
								textField.text = textField.text;
										
								// shirnk if needed, but overshoot to get soething square
								while ((textField.numLines < (desiredLines + 1)) && (textField.width > 4) && (textField.width > (_minWidth - _padding.horizontal))) {
									textField.width--;
									textField.text = textField.text;
								}								
								
//								// grow if needed
//								while ((textField.numLines > desiredLines) && (textField.width < (_maxWidth - _padding.horizontal))) {
//									textField.width++;
//									textField.text = textField.text;
//								}
							}
							
							trace("now we have " + textField.numLines);
							
							if (textField.numLines > desiredLines) {
								trace("Too many lines");								
								// need to expand width
								// jump to roughly the right width
								textField.width /= desiredLines / textField.numLines; // TODO better squaring alogithm instead of dividing
								textField.text = textField.text;

								// grow if needed
								while ((textField.numLines > desiredLines) && (textField.width < (_maxWidth - _padding.horizontal))) {
									textField.width++;
									textField.text = textField.text;
								}								
								
//								// shirnk if needed
//								while ((textField.numLines < desiredLines) && (textField.width > 4) && (textField.width > (_minWidth - _padding.horizontal))) {
//									textField.width--;
//									textField.text = textField.text;
//								}								
//								
								// todo overflow out the bottom
							}
							
							
							// clamp it off
							//textField.width = Math2.clamp(getMaxLineWidth() + 5, _minWidth - _padding.horizontal, _maxWidth - _padding.horizontal);
							textField.text = textField.text;							
						}
						else if (_growthMode == MAXIMIZE_WIDTH) {
							
							var maxLines:int = int((_maxHeight - _padding.vertical) / (_leading + _textSizePixels)); // take the floor
							maxLines = Math.max(maxLines, 1); // at least 1
							trace("Max lines: " + maxLines);
							
							textField.width = _maxWidth - _padding.horizontal;
							textField.text = textField.text;
							textField.width = Math2.clamp(getMaxLineWidth(), _minWidth - _padding.horizontal, _maxWidth - _padding.horizontal);
							textField.text = textField.text;						
							
							
							trace("num lines: " + textField.numLines);
							// todo overflow off the right							
							while (textField.numLines > maxLines) {
								textField.width++;
								textField.text = textField.text;								
							}
							
							
						}	
						
						// rescale
						textField.scaleX = originalScale;
						textField.scaleY = originalScale;
					}
					
					
					// Handle extreme width case?
					// 3360 width limit?
					
					// text height
					textField.text = textField.text;
					
					textField.height = ((textSizeOffset.fieldHeight / textField.scaleX) * textField.numLines) + (fieldLeading * (textField.numLines - 1));
					textField.text = textField.text;
					
					
					// compensate for flash's overdraw, without masking content
					// (That's why setting ScrollRect doesn't cut it, and it's not as trivial as overriding GetBounds since flash actually uses
 					// an internal method to calculate bounds.)
					lockUpdates = true;
					contentCropTop = textSizeOffset.topWhitespace;
					contentCropRight = 2;
					contentCropLeft = 2;
					contentCropBottom = textSizeOffset.bottomWhitespace + (3 * (textField.numLines - 1));
					lockUpdates = false;
					
					//textField.cacheAsBitmap = true;
					changedBounds = false;
					
					var elapsed:int = getTimer() - start;
					// trace("Changing bounds took " + elapsed + " ms");
				}
				
				
				// Update the mask if needed
				// TODO finish this!
				if (_maxSizeBehavior == BlockText.MAX_SIZE_RESIZES) {
					trace("content width: " + contentWidth);
					trace("background width: " + background.width);					
					
					if(contentWidth > background.width) {
						
						// we're oversize!
						trace("fat");
					}
					else if (contentHeight > background.height) {
						trace("tall");						
					}
				}				
				
				
				super.update(contentWidth, contentHeight); // TODO pass bounds vector instead?
			}			
		}		
		
		
		private function getMaxLineWidth():Number {
			var maxLineWidth:Number = 0;
			for (var i:int = 0; i < textField.numLines; i++) {
				maxLineWidth = Math.max(maxLineWidth, textField.getLineMetrics(i).width);
			}
			return maxLineWidth;
		}

		
		// See GIT for non-caching function
		// With caching (broken?)
		private function updateSizeMap():void {
			var startTime:int = getTimer();
			
			// check cache, note weird string index to make sure each change in compensation dimensions
			// yields a fresh swath of cache
			var cacheKey:String = _textFont + _textBold + _sizeFactorGlyphs;
			
			if (BlockText.sizeMaps.hasOwnProperty(cacheKey)) {
				//trace("In the cache, load that: " + cacheKey);
				sizeMap = BlockText.sizeMaps[cacheKey]['sizeMap'];
				maxTextPixelSize = BlockText.sizeMaps[cacheKey]['maxTextPixelSize'];
			}
			else {
				//trace("Not cached! Generating: " + cacheKey);
				// rebuilds size set maping pixel sizes to flash TextField sizes
				// height is maximum character height (in pixels) for a given internal size
				BlockText.sizeMaps[cacheKey] = {};
				BlockText.sizeMaps[cacheKey]['sizeMap'] = new Vector.<TextSize>(maxTextSize);
				
				var glyphCanvas:BitmapData;
				var testField:TextField;
				var bounds:Rectangle;
				var pixelHeight:int;
				
				BlockText.sizeMaps[cacheKey]['sizeMap'][0] = new TextSize(); // zeros in the first position
				
				// key: pixel size, value: field size
				for(var i:int = 1; i < maxTextSize; i++) {
					
					// TODO cache these
					// for each requested size
					// test all glyphs to establish bounds				
					
					// create the text
					testField = generateTextField(_sizeFactorGlyphs, i, true);
					
					// render it into a bitmap and measure the margins 
					glyphCanvas = new BitmapData(testField.width, testField.height, false, 0xffffff);	
					glyphCanvas.draw(testField);
					
					// index the field height to the pixel height
					bounds = glyphCanvas.getColorBoundsRect(0xffffff, 0xffffff, false);
					pixelHeight = bounds.height;
					//trace(bounds);
					
					BlockText.sizeMaps[cacheKey]['sizeMap'][pixelHeight] = new TextSize(pixelHeight, i, bounds.y, glyphCanvas.width - bounds.width - bounds.x, glyphCanvas.height - bounds.y - bounds.height, bounds.x);
					
					//trace("Pixel Height: " + pixelHeight + " Field Size: " + i);
					
					// keep track of pixel size at max field size, will need
					// this to know when to resort to scaling
					if (i == 127)	maxTextPixelSize = pixelHeight;		
				}
				
				// fill holes
				for(i = 1; i < maxTextPixelSize; i++) {
					if (BlockText.sizeMaps[cacheKey]['sizeMap'][i] == null) {
						//trace("Hole at " + i);
						// TODO implement lerp for this, for now just use last
						BlockText.sizeMaps[cacheKey]['sizeMap'][i] = BlockText.sizeMaps[cacheKey]['sizeMap'][i - 1]; 
					}
				}
					
				
				// Cache it
				//TextBlock.sizeMaps[cacheKey] = newSizeMap;
				sizeMap = BlockText.sizeMaps[cacheKey]['sizeMap'];
				BlockText.sizeMaps[cacheKey]['maxTextPixelSize'] = maxTextPixelSize;
			}
			
			// make sure it sticks
		 	lockUpdates = true;
			textSize = _textSizePixels;
		 	lockUpdates = false;
			
			//trace(getTimer() - startTime + " ms to build offset map");
		}				
		
		
		

		// Utilities
		
		// counts number of user-defined line breaks (NOT word-wrap line breaks)
		// in the fields string. useful for text flow calculation
		private function numExplicitLines():int {
			return _text.match(/[\r\n]+/g).length + 1;
		}
		
		
		private function lerpTextOffsets(amount:Number, low:TextSize, high:TextSize):TextSize {
			var tempOffset:TextSize = new TextSize();
			tempOffset.textPixelSize = Math2.map(amount, 0, 1, low.textPixelSize, high.textPixelSize);
			tempOffset.textFieldSize = Math2.map(amount, 0, 1, low.textFieldSize, high.textFieldSize);
			tempOffset.topWhitespace = Math2.map(amount, 0, 1, low.topWhitespace, high.topWhitespace);
			tempOffset.rightWhitespace = Math2.map(amount, 0, 1, low.rightWhitespace, high.rightWhitespace);
			tempOffset.bottomWhitespace = Math2.map(amount, 0, 1, low.bottomWhitespace, high.bottomWhitespace);
			tempOffset.leftWhitespace = Math2.map(amount, 0, 1, low.leftWhitespace, high.leftWhitespace);
			return tempOffset;
		}
				

		// Geters and setters
		
		// which glyphs should we consider in defining the "pixel size" of the text field?
		public function get sizeFactorGlyphs():String { return _sizeFactorGlyphs; }
		public function set sizeFactorGlyphs(setOfLetters:String):void {
			// TODO filter duplicates
			_sizeFactorGlyphs = setOfLetters;
			
			// could schedule a bunch of functions to avoid duplicate execution?
			//updateSizeMap();
			//textSize = _textSizePixels; // update to show true glyphs
			updateSizeMap();
		}
		
		
		// DIRECT
		public function get textColor():uint	{	return _textColor;	}
		public function set textColor(c:uint):void  {
			_textColor = c;
			textField.textColor = _textColor;
			// no need to update
		}
		
		public function get textAlpha():Number	{	return _textAlpha;	}
		public function set textAlpha(value:Number):void  {
			_textAlpha = value;
			textField.alpha = _textAlpha;
			// no need to update
		}		
		
		public function get growthMode():String { return _growthMode; }
		public function set growthMode(mode:String):void {
			_growthMode = mode;
			
			changedBounds = true;
			update();
		}
		
		// Format updates
		public function get textSize():Number	{	return _textSizePixels;	}		
		public function set textSize(size:Number):void  {
			
			// ignore negatives
			_textSizePixels = size;
			if (_textSizePixels < 0) _textSizePixels = 0; 
				
			if (_textSizePixels > maxTextPixelSize) {
				trace("Drastic measures");
				
				
				// Scale from the largest true text field sample we have
				textFormat.size = sizeMap[maxTextPixelSize].textFieldSize;				
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

					textSizeOffset = lerpTextOffsets(_textSizePixels - leftIndex, sizeMap[leftIndex], sizeMap[rightIndex]);
				}
	
				textFormat.size = textSizeOffset.textFieldSize; 
			}
			

			// update leading
			lockUpdates = true;
			leading = _leading; // refreshes the offset
			lockUpdates = false;
			
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
		
		
		public function get leading():Number { return _leading; }
		public function set leading(value:Number):void {
			_leading = value;
			fieldLeading = (_leading + textSizeOffset.leadingOffset) / textField.scaleX;
			textFormat.leading = fieldLeading
			
			changedFormat = true;
			changedBounds = true;
			update();
		}		
		
		
		
		// text input
		public function get input():Boolean { return _input; }
		public function set input(value:Boolean):void {
			_input = value;
			if (_input) selectable = true; // has to be selectable if it's interactive				
			changedTextField = true;
			update();
		}
		
		public function get selectable():Boolean { return _selectable; }
		public function set selectable(value:Boolean):void {
			_selectable = value;
			textField.selectable = _selectable; // operates directly
		}
		
		public function get maxChars():int { return _maxChars; }
		public function set maxChars(value:int):void {
			_maxChars = value;
			textField.maxChars = _maxChars;
		}
		
		// read only, convenience
		public function get charsLeft():int { return textField.maxChars - textField.text.length; }
		
		

		
		// Events		
		private function onInputInternal(e:Event):void {
			text = textField.text; // keep internal text representation in sync with input
			//changedBounds = true;
			//update();
			executeAll(onInput);
		}
		
		private function onFocusInternal(e:FocusEvent):void {
			tempEvent = e;
			executeAll(onFocus);
		}
		
		private function onBlurInternal(e:FocusEvent):void {
			tempEvent = e;
			executeAll(onBlur);
		}
		
		// Let the whole block grant focus to an interactive text field 
		private function onMouseFocusInternal(e:MouseEvent):void {
			stage.focus = textField;
			executeAll(onFocus);
		}
		
		
		// If we're clicking inside our block, don't defocus!
		private function onMouseFocusChangeInternal(e:FocusEvent):void {
			
			// For CDW! Disallow deselection.
			e.preventDefault();			
			
			if(this.contains(e.relatedObject)) {
				e.preventDefault();	
			}
			
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
			textSize = textSize;
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
			changedFormat = true;
			changedBounds = true;
			update();			
		}
		
		
		public function get textAlignmentMode():String { return _textAlignmentMode; }
		public function set textAlignmentMode(align:String):void {
			_textAlignmentMode = align;
			textFormat.align = _textAlignmentMode;
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
		
		override public function set maxHeight(height:Number):void {
			changedBounds = true;
			super.maxHeight = height;
		}

		public function get textBold():Boolean {
			return _textBold;
		}

		public function set textBold(value:Boolean):void {
			changedFormat = true;
			_textBold = value;
			textFormat.bold = _textBold;
			update();
		}
		
	}
}