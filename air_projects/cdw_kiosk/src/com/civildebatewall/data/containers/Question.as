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

package com.civildebatewall.data.containers {
	
	import com.civildebatewall.CivilDebateWall;
	
	public class Question {
		
		private var _text:String;
		private var _id:String;
		private var _category:Category;
		
		public function Question(jsonObject:Object)	{
			_text = jsonObject["text"];
			_id = jsonObject["id"];
			_category = CivilDebateWall.data.getCategoryById(jsonObject["category"]["id"]);
		}
		
		public function get text():String {	return _text;	}
		public function get id():String {	return _id;	}
		public function get category():Category { return _category; }
		
	}
}
