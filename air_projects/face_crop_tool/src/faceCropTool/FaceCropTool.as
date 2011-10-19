package faceCropTool {
	
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
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
		private var showOriginalRadioButton:RadioButton;
		private var showCroppedRadioButton:RadioButton;
		
		
		public function FaceCropTool() {
			super();
			
			// empty state
			State.images = [];
			State.sourceDirectory = new File();
			State.targetDirectory = new File();
			State.cachePath = "/Users/Mika/Code/CivilDebateWall/lp-cdw/air_projects/face_crop_tool/data/face_data.txt";
			State.viewMode = State.SHOW_ORIGINAL;
			State.faceCropRect = new Rectangle(294, 352, 494, 576);
			
			// 20 pixel padding for crop bars
			lighttable = new Sprite();
			lighttable.graphics.beginFill(ColorUtil.grayPercent(80));
			lighttable.graphics.drawRect(0, 0, 580, 1000);
			lighttable.graphics.endFill();
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
			
			showOriginalRadioButton = new RadioButton(toolbar, 5, targetDirectoryButton.y + targetDirectoryButton.height + 5, "Show Original", true, onShowOriginal);
			showCroppedRadioButton = new RadioButton(toolbar, 5, showOriginalRadioButton.y + showOriginalRadioButton.height + 5, "Show Face Crop", false, onShowCrop);
			
			
			// TODo button to show overlays
			
		}
		
		private function onShowOriginal(e:Event):void {
			State.viewMode = State.SHOW_ORIGINAL;			
			drawOriginalGrid();
		}
		
		private function onShowCrop(e:Event):void {
			State.viewMode = State.SHOW_ORIGINAL;
			drawFaceCropGrid();
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

		
		
		private var gridRows:int;
		private var gridCols:int;
		private var gridCellWidth:Number;
		private var gridCellHeight:Number;	
		private var gridPhotoWidth:Number;
		private var gridPhotoHeight:Number;	
		private var gridPadding:Number = 10;
		
		private function onLoadComplete(e:Event):void {
			imageLoader.removeEventListener(Event.COMPLETE, onLoadComplete);			
			trace("load complete");
			
			// layout grid
			
			
			// lay out grid
			// Proportion of the screen
			// w,h width and height of your rectangles
			// W,H width and height of the screen
			// N number of your rectangles that you would like to fit in
			
			// ratio
			// This ratio is important since we can define the following relationship
			// nbRows and nbColumns are what you are looking for
			// nbColumns = nbRows * r (there will be problems of integers)
			// we are looking for the minimum values of nbRows and nbColumns such that
			// N <= nbRows * nbColumns = (nbRows ^ 2) * r

			gridRows = Math.ceil( Math.sqrt( State.images.length / 1 ) ); // r is positive...
			gridCols = Math.ceil( State.images.length / gridRows);
			
			gridCellWidth = (580 - (gridPadding * (gridCols + 1))) / gridCols;
			gridCellHeight = (1000 - (gridPadding * (gridRows + 1))) / gridRows;
			
			
			// Fit the image inside the cell
			var resizedImageBounds:Rectangle = GeomUtil.scaleToFit(new Rectangle(0, 0, 1080, 1920), new Rectangle(0, 0, gridCellWidth, gridCellHeight));
			gridPhotoWidth = resizedImageBounds.width; 
			gridPhotoHeight = resizedImageBounds.height;

			
			updateFaceCrop();
			
			if (State.viewMode == State.SHOW_CROPPED) {
				drawFaceCropGrid();
			}
			else if (State.viewMode == State.SHOW_ORIGINAL) {
				drawOriginalGrid();
			}
			
		}
		
		private function updateFaceCrop():void {
			trace("Updating face crop");
			for each (var image:FaceImage in State.images) {
				image.faceCropBitmap = Utilities.cropToFace(image.originalBitmap, image.faceRect, State.faceCropRect);
			}
		}
		
		
		
		private function drawFaceCropGrid():void {
			// Update layout
			GraphicsUtil.removeChildren(lighttable);
			for (var i:int = 0; i < State.images.length; i++) {
				var image:FaceImage = State.images[i];
				image.faceCropBitmap.width = gridPhotoWidth;
				image.faceCropBitmap.height = gridPhotoHeight;
				image.faceCropBitmap.x = (i % gridCols) * gridCellWidth + (gridPadding * ((i % gridCols) + 1));
				image.faceCropBitmap.y = int(i / gridCols) * gridCellHeight + (gridPadding * (int(i / gridCols) + 1));
				lighttable.addChild(image.faceCropBitmap);
			}		
		}
		
		
		private function drawOriginalGrid():void {
			GraphicsUtil.removeChildren(lighttable);
			for (var i:int = 0; i < State.images.length; i++) {
				var image:FaceImage = State.images[i];
				image.cropBitmap.width = gridPhotoWidth;
				image.cropBitmap.height = gridPhotoHeight;
				image.cropBitmap.x = (i % gridCols) * gridCellWidth + (gridPadding * ((i % gridCols) + 1));
				image.cropBitmap.y = int(i / gridCols) * gridCellHeight + (gridPadding * (int(i / gridCols) + 1));
				lighttable.addChild(image.cropBitmap);
			}
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