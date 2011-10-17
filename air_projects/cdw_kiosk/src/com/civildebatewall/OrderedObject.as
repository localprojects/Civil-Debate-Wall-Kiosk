/* ---------------------------------------------------------------------------
Author: Manish Jethani (manish.jethani@gmail.com)
Version: 0.1
Date: December 19, 2008

http://manishjethani.com/guaranteeing-enumeration-order

Copyright (c) 2008 Manish Jethani

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
--------------------------------------------------------------------------- */

package com.civildebatewall
{
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	dynamic public class OrderedObject extends Proxy
	{
		private var content:Object = {};
		private var contentByIndex:Array = [];
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			var wasDeleted:Boolean = delete content[name];
			
			if (wasDeleted) {
				var n:int = contentByIndex.length;
				
				for (var i:int = 0; i < n; i++) {
					if (contentByIndex[i] == name) {
						contentByIndex.splice(i, 1);
						break;
					}
				}
			}
			
			return wasDeleted;
		}
		
		public function reverse():void {
			contentByIndex.reverse();
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return content[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return content.hasOwnProperty(name);
		}
		
		override flash_proxy function nextName(index:int):String
		{
			return contentByIndex[index - 1];
		}
		
		override flash_proxy function nextNameIndex(index:int):int
		{
			if (index < contentByIndex.length)
				return index + 1;
			else
				return 0;
		}
		
		override flash_proxy function nextValue(index:int):*
		{
			return content[contentByIndex[index - 1]];
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			content[name] = value;
			
			for each (var p:* in contentByIndex) {
				if (p == name)
					// If the property already exists, don't change the order.
					return;
			}
			
			contentByIndex.push(name);
		}
	}
	
}
