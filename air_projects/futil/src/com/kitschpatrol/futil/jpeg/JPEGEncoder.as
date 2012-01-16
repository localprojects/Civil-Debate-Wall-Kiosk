//-------------------------------------------------------------------------------
// Copyright (c) 2012 Eric Mika
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
// 	
// 	The above copyright notice and this permission notice shall be included in 
// 	all copies or substantial portions of the Software.
// 		
// 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// 	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// 	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// 	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT 
// 	OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
// 	THE	USE OR OTHER DEALINGS IN THE SOFTWARE.
//-------------------------------------------------------------------------------

package com.kitschpatrol.futil.jpeg {
	
	
	// UNUSED
	import cmodule.aircall.CLibInit;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	public final class JPEGEncoder	{
		
		public function JPEGEncoder()	{

		}
		
		public function parse(bitmapData:BitmapData, quality:int = 80):ByteArray {
			
			var targetBytes:ByteArray = new ByteArray();
			var sourceBytes:ByteArray = bitmapData.getPixels(bitmapData.rect);			
			
			sourceBytes.position = 0; 			
			
			// faster jpeg encoding
			// via http://segfaultlabs.com/devlogs/alchemy-asynchronous-jpeg-encoding-2		
			/// init alchemy object
			var jpeginit:CLibInit = new CLibInit(); // get library
			var jpeglib:Object = jpeginit.init(); // initialize library exported class to an object			
			
			jpeglib.encode(sourceBytes, targetBytes, bitmapData.width, bitmapData.height, quality);			
			return targetBytes;
		}
	}
}
