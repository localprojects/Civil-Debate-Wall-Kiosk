package faceCropTool {
	
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	
	public class FaceCropTool extends Sprite {
		
		private var lighttable:Sprite;
		private var toolbar:Sprite;
		

		private var imageLoader:FaceImageLoader;		
		
		// Gui stuff
		private var sourceDirectoryButton:PushButton;
		private var targetDirectoryButton:PushButton;		
		private var sourceDirectoryLabel:Label;
		private var targetDirectoryLabel:Label;
		
		
		public function FaceCropTool() {
			super();
			
			// empty state
			State.images = [];
			State.sourceDirectory = new File();
			State.targetDirectory = new File();
			State.cachePath = "/Users/Mika/Code/CivilDebateWall/lp-cdw/air_projects/face_crop_tool/data/face_data.txt";
			
			// 20 pixel padding for crop bars
			lighttable = new Sprite();
			lighttable.addChild(GraphicsUtil.shapeFromSize(580, 1000, ColorUtil.grayPercent(80)));
			addChild(lighttable);
			
			toolbar = new Sprite();
			toolbar.addChild(GraphicsUtil.shapeFromSize(300, 1000, ColorUtil.grayPercent(50)));
			toolbar.x = lighttable.width;
			addChild(toolbar);
			
			// Set up gui
			sourceDirectoryButton = new PushButton(toolbar, 5, 5, "Source Folder", onSourceButton);
			sourceDirectoryLabel = new Label(toolbar, sourceDirectoryButton.x + sourceDirectoryButton.width + 5, sourceDirectoryButton.y, "Please select");
			sourceDirectoryLabel.textField.textColor = 0xffffff;
			
			targetDirectoryButton = new PushButton(toolbar, 5, sourceDirectoryButton.y + sourceDirectoryButton.height + 5, "Target Folder", onTargetButton);
			targetDirectoryLabel = new Label(toolbar, targetDirectoryButton.x + targetDirectoryButton.width + 5, targetDirectoryButton.y, "Please select");
			targetDirectoryLabel.textField.textColor = 0xffffff;			
		}
		
		private function onSourceButton(e:Event):void {
			State.sourceDirectory.addEventListener(Event.SELECT, onSourceSelected);
			State.sourceDirectory.browseForDirectory("Source Folder");
		}
		
		

		
		private function onSourceSelected(e:Event):void {
			State.sourceDirectory.removeEventListener(Event.SELECT, onSourceSelected);
			sourceDirectoryLabel.text = "/" + State.sourceDirectory.name;
			trace("Selected source folder: " + State.sourceDirectory.url);
			
			imageLoader = new FaceImageLoader();
			imageLoader.addEventListener(Event.COMPLETE, onLoadComplete);
			imageLoader.loadFromDirectory(State.sourceDirectory);
		}
		
		private function onLoadComplete(e:Event):void {
			imageLoader.removeEventListener(Event.COMPLETE, onLoadComplete);			
			trace("load complete");
		}

		
		private function onTargetButton(e:Event):void {
			State.targetDirectory.addEventListener(Event.SELECT, onTargetSelected);
			State.targetDirectory.browseForDirectory("Target Folder");
		}
		
		
		private function onTargetSelected(e:Event):void {
			State.targetDirectory.removeEventListener(Event.SELECT, onTargetSelected);
			targetDirectoryLabel.text = "/" + State.targetDirectory.name;
			trace("Selected target folder: " + State.targetDirectory.url);
		}
		
		
		
	}
}