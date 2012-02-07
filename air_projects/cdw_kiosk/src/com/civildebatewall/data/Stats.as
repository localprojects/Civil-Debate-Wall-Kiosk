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
	public class Stats {
		
		// Just a container for static type checking
		public var likesTotal:int;
		public var likesYes:int;
		public var likesNo:int;
		
		public var postsTotal:int;
		public var postsYes:int;
		public var postsNo:int;
		
		public var mostDebatedThreads:Array;
		public var mostLikedPosts:Array;
		public var frequentWords:Array;
		public var yesPercent:Number; // normalized yes / total		
		
		public function Stats()	{
		
		}
	}
}
