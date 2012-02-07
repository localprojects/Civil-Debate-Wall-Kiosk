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

package com.civildebatewall.data {
	
	public class Word extends Object {
	
		public var yesCases:uint;
		public var noCases:uint;
		public var total:uint;
		public var posts:Array;
		public var theWord:String;	
		public var difference:Number;
		public var normalDifference:Number;		
		
		public function Word(theWord:String) {
			yesCases = 0;
			noCases = 0;
			total = 0;
			posts = [];
			
			this.theWord = theWord;
		}

		public function toString():String {
			return theWord + "\tTotal: " + total + "\n";
		}
		
	}
}
