/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.keyboard {
	
	import com.adobe.utils.StringUtil;
	import com.civildebatewall.kiosk.legacy.OldBlockBase;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.Math2;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Keyboard extends OldBlockBase {
		
		private var keys:Array;
		private var shift:Boolean;
		public var target:InteractiveObject;
		
		public function Keyboard() {
			super();
			init();
		}
		
		private function init():void {
			// background
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, 798, 320); // add padding
			this.graphics.endFill();
			
			keys = [];			
			
			shift = false;
			
			// extra white space describes how many multiples of the keywidth it should be
			var layout:Array = [
				["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", " DELETE "],
				["a", "s", "d", "f", "g", "h", "j", "k", "l", [":", ";"], ["'", "\""]],
				["z", "x", "c", "v", "b", "n", "m", ",", ".", ["?", "!"]],
				[" SHIFT1 ", "  SPACE   ", " SHIFT2 "]
			];
			
			var capWidth:Number = 67; 
			var capHeight:Number = 67;			
			var keyPaddingVertical:Number = 12;
			var keyPaddingHorizontal:Number = 7
			
			var rowOffsets:Array = [
				0,
				40,
				80,
				120
			]			
			
			// make the keys
			for (var row:int = 0; row < layout.length; row++) {
				// var xPos:Number = (width - (getRowGridCount(layout[row]) * keyWidth)) / 2;
				var xPos:Number = rowOffsets[row];
				
				for (var col:int = 0; col < layout[row].length; col++) {
					var letter:String
					var shiftLetter:String;
					
					// Allow passing in an array of two strings to override default shift letter
					if (layout[row][col] is Array) {
						letter = layout[row][col][0];
						shiftLetter = layout[row][col][1];
					}
					else {
						letter = layout[row][col];
						shiftLetter = null;
					}
					
					var widthFactor:int = getWidthFactor(letter);
					var key:Key = new Key((capWidth * widthFactor) + ((widthFactor - 1) * (keyPaddingHorizontal * 2)), capHeight, keyPaddingVertical, keyPaddingHorizontal, letter, shiftLetter);
					
					key.x = xPos;
					key.y = row * key.height;
					
					// accuumulate width
					xPos += key.width;
					
					// events inside the key
					key.addEventListener(MouseEvent.MOUSE_DOWN, key.onMouseDown);
					key.addEventListener(MouseEvent.MOUSE_UP, key.onMouseUp);
					key.addEventListener(MouseEvent.MOUSE_OVER, key.onMouseOver);
					key.addEventListener(MouseEvent.MOUSE_OUT, key.onMouseOut);					

					// events global to the keyboard
					key.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);					
					key.addEventListener(MouseEvent.MOUSE_UP, onKeyPressed);					
					
					keys[StringUtil.trim(letter)] = key;

					addChild(key);
				}
			}

			// customize certain keys
			keys["DELETE"].repeats = true;			
			
			// Two keys... become one
			keys["SHIFT1"].addEventListener(MouseEvent.MOUSE_OVER, keys["SHIFT2"].onMouseOver);
			keys["SHIFT1"].addEventListener(MouseEvent.MOUSE_OUT, keys["SHIFT2"].onMouseOut);
			keys["SHIFT1"].addEventListener(MouseEvent.MOUSE_DOWN, keys["SHIFT2"].onMouseDown);
			keys["SHIFT1"].addEventListener(MouseEvent.MOUSE_UP, keys["SHIFT2"].onMouseUp);			
			
			keys["SHIFT2"].addEventListener(MouseEvent.MOUSE_OVER, keys["SHIFT1"].onMouseOver);
			keys["SHIFT2"].addEventListener(MouseEvent.MOUSE_OUT, keys["SHIFT1"].onMouseOut);
			keys["SHIFT2"].addEventListener(MouseEvent.MOUSE_DOWN, keys["SHIFT1"].onMouseDown);
			keys["SHIFT2"].addEventListener(MouseEvent.MOUSE_UP, keys["SHIFT1"].onMouseUp);
		}

		public function showSpacebar(b:Boolean):void {
			if (b) {
				keys["SPACE"].visible = true;
				TweenMax.to(keys["SPACE"], 0.25, {alpha: 1});				
			}
			else {
				TweenMax.to(keys["SPACE"], 0.25, {alpha: 0, onComplete: function():void { keys["SPACE"].visible = false; }});
			}
		}
		
		private function upperCase():void {
			for each (var key:Key in keys) {
				if (key.letter.length == 1) {
					key.setLetter(key.shiftLetter);
				}
			}
		}
		
		private function lowerCase():void {
			for each (var key:Key in keys) {
				if (key.letter.length == 1) {
					key.setLetter(key.letter);
				}
			}			
		}
		
		private function onMouseDown(e:MouseEvent):void {
			// make sure the text ends up where we want it
			//stage.focus = target;
		}
		
		private function onKeyPressed(e:MouseEvent):void {
			//Assets.clickSound.play();
			
			if (e.target.letter == "SHIFT") {
				shift = e.target.active;

				if (shift) {
					// switch key caps to uppercase
					upperCase();				
				}
				else {
					// back to lowercase
					lowerCase();					
				}
			}
			else if (e.target.letter == "DELETE") {
				// backspace
				if (this.stage.focus is TextField) {
					var tf:TextField = this.stage.focus as TextField;
					
					if (tf.length > 0) {
						
						var firstHalf:String;
						var secondHalf:String;		
						var insertionPoint:int;
						
						if (tf.selectionBeginIndex == tf.selectionEndIndex) {
							// insertion edit, kind of drawn out for debugging
							firstHalf = tf.text.substring(0, tf.selectionBeginIndex - 1);
							secondHalf = tf.text.substr(tf.selectionEndIndex);
							tf.text = firstHalf + secondHalf;
							
						}
						else {
							// block edit
							firstHalf = tf.text.substring(0, tf.selectionBeginIndex);							
							secondHalf = tf.text.substr(tf.selectionEndIndex);
						}
						
						tf.text = firstHalf + secondHalf;						
						insertionPoint = Math2.clamp(firstHalf.length, 0, tf.text.length);						
						tf.setSelection(insertionPoint, insertionPoint);						
						
					}
					else {
						// Nothing to delete
					}
				}
			}
			else {				
				// sending a keyboard event is just ignored by the text input fields
				// via http://www.kirupa.com/forum/showthread.php?312829-Onscreen-Keyboard-how-to-send-event
				if (this.stage.focus is TextField) {
					var tf1:TextField = this.stage.focus as TextField;
					
					// watch character limit since appending to the string
					// directly bypasses the flash-native max character checks
					if (tf1.text.length < tf1.maxChars) {					
						tf1.text = tf1.text.substring(0, tf1.selectionBeginIndex) + e.target.activeLetter + tf1.text.substring(tf1.selectionEndIndex);
						tf1.setSelection(tf1.selectionBeginIndex + 1, tf1.selectionBeginIndex + 1);
					}
				}

				// unstick the shift button if we're shifted
				if (shift) {
					keys["SHIFT1"].onMouseUp(new MouseEvent(MouseEvent.MOUSE_UP));
					keys["SHIFT2"].onMouseUp(new MouseEvent(MouseEvent.MOUSE_UP));
					keys["SHIFT1"].active = false;
					keys["SHIFT2"].active = false;					
					lowerCase();
				}
			}
			
			// Fire the update
			if (this.stage.focus is TextField) {
				var tf2:TextField = this.stage.focus as TextField;
				tf2.dispatchEvent(new Event(Event.CHANGE, true));
			}
		}
		
		// returns the number of "cells" a row of keys takes up
		// by factoring in larger than average keys
		// multiply by keyWidth to get the full length of the row
		private function getRowGridCount(a:Array):Number {
			var count:int = 0;
			
			for (var i:int = 0; i < a.length; i++) {
				count += getWidthFactor(a[i]);
			}
			
			return count;
		}
		
		private function getWidthFactor(s:String):int {
			var spaceCount:int = 0;
			
			// leading white space
			var left:int = 0;
			while (s.charAt(left) == " ") {
				spaceCount++;
				left++;
			}
			
			// trailing white space
			var right:int = s.length - 1;
			while (s.charAt(right) == " ") {
				spaceCount++;
				right--;
			}
			
			if (spaceCount == 0) spaceCount = 1;
			
			return spaceCount;
		}
		
		public function setColor(c:uint, instant:Boolean = false):void {
			// TODO implement non-instant color transition
			for each (var key:Key in keys) {
				key.setColor(c);
			}
		}
		
		// recursively finds length of the longest array, regardless of how deeply it's nested
		private function maxLength(a:Array, currentMax:int = 0):int {
			currentMax = Math.max(currentMax, a.length);
			
			for (var i:int = 0; i < a.length; i++) {
				if (a[i] is Array) {
					currentMax = Math.max(currentMax, maxLength(a[i], currentMax));
				}
			}
			
			return currentMax;
		}
		
	}
}
