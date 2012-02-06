/*------------------------------------------------------------------------------
Copyright (c) 2012 Local Projects. All rights reserved.

This file is part of The Civil Debate Wall.

The Civil Debate Wall is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The Civil Debate Wall is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with The Civil Debate Wall.  If not, see <http://www.gnu.org/licenses/>.
------------------------------------------------------------------------------*/

package faceCropTool.core {
	import faceCropTool.faceImage.FaceImage;
	
	import flash.display.Bitmap;
	import flash.filesystem.File;
	import flash.geom.Rectangle;

	public class State	{
		
		public static const SHOW_ORIGINAL:String = "showOriginal";		
		public static const SHOW_CROPPED:String = "showCropped";		
		
		public static var showZoomOverlay:Boolean;
		public static var showDesignOverlay:Boolean;
		public static var designOverlay:Bitmap;
		public static var zoomedFace:FaceImage;
		public static var showFaceOverlay:Boolean;
		public static var viewMode:String;
		public static var images:Array;
		public static var sourceDirectory:File;
		public static var targetDirectory:File;	
		public static var cachePath:String;
		public static var faceCropRect:Rectangle;
		public static var fileSuffix:String;
		
		public static var targetWidth:int;
		public static var targetHeight:int;		
		
	}
}