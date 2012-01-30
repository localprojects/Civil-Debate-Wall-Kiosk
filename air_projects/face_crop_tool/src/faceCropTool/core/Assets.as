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
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
	public final class Assets	{
		
		// Constants
		public static const KIOSK_WIDTH:int = 1080;
		public static const KIOSK_HEIGHT:int = 1920;
		public static const KIOSK_DEFAULT_FACE_TARGET:Rectangle = new Rectangle(294, 352, 494, 576);
		public static const WEB_WIDTH:int = 550;
		public static const WEB_HEIGHT:int = 608;
		public static const WEB_DEFAULT_FACE_TARGET:Rectangle = new Rectangle(188, 110, 175, 192);	
		
		// Bitmaps
		[Embed(source = '/assets/graphics/kioskOverlay.png')] private static const kioskOverlayClass:Class;
		public static function getKioskOverlay():Bitmap { return new kioskOverlayClass() as Bitmap; };
		public static const KIOSK_OVERLAY:Bitmap = getKioskOverlay();
		
		[Embed(source = '/assets/graphics/webOverlay.png')] private static const webOverlayClass:Class;
		public static function getWebOverlay():Bitmap { return new webOverlayClass() as Bitmap; };
		public static const WEB_OVERLAY:Bitmap = getWebOverlay();
			
	}
}