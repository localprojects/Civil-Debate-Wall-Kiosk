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

package {
	import faceCropTool.core.FaceCropTool;
	import faceCropTool.utilities.FaceDetector;
	import faceCropTool.core.State;
	import faceCropTool.utilities.Utilities;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.*;
	
	import ObjectDetection.ObjectDetectorEvent;
	
	[SWF(width="739", height="1000", frameRate="60")]
	public class Main extends Sprite {
		
		public function Main() {
			var faceCropTool:FaceCropTool = new FaceCropTool();
			addChild(faceCropTool);
		}
	
	}
}