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