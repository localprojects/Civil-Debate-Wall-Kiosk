package {
	import faceCropTool.FaceCropTool;
	import faceCropTool.FaceDetector;
	import faceCropTool.State;
	import faceCropTool.Utilities;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.*;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	[SWF(width="880", height="1000", frameRate="60")]
	public class Main extends Sprite {
		
		public function Main() {
			var faceCropTool:FaceCropTool = new FaceCropTool();
			addChild(faceCropTool);
		}
	
	}
}