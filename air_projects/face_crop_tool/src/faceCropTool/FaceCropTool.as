package faceCropTool {
	
	import com.bit101.components.CheckBox;
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.bit101.components.Style;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flashx.textLayout.elements.BreakElement;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	
	public class FaceCropTool extends Sprite {
		
		private var lighttable:Sprite;
		private var toolbar:Sprite;
		private var zoomOverlay:Sprite;
		private var kioskOverlay:Bitmap;
		

		private var imageLoader:FaceImageLoader;		
		
		// Gui stuff
		private var sourceDirectoryButton:PushButton;
		private var targetDirectoryButton:PushButton;		
		private var sourceDirectoryLabel:Label;
		private var targetDirectoryLabel:Label;
		private var showOriginalRadioButton:RadioButton;
		private var showCroppedRadioButton:RadioButton;
		private var rectX:NumericStepper;
		private var rectY:NumericStepper;
		private var rectWidth:NumericStepper;
		private var rectHeight:NumericStepper;		
		private var backToGridButton:PushButton;
		private var toggleFaceOverlayButton:PushButton;
		private var toggleKioskOverlayButton:PushButton;
		private var exportButton:PushButton;
		
		public function FaceCropTool() {
			super();
			
			// empty state
			State.images = [];
			State.sourceDirectory = new File();
			State.targetDirectory = new File();
			
			State.cachePath = "/Users/Mika/Code/CivilDebateWall/lp-cdw/air_projects/face_crop_tool/data/face_data.txt";
			State.viewMode = State.SHOW_ORIGINAL;
			State.faceCropRect = new Rectangle(294, 352, 494, 576);
			State.showFaceOverlay = false;
			State.showZoomOverlay = false;
			State.fileSuffix = "cropped";
			
			// 20 pixel padding for crop bars
			lighttable = new Sprite();
			lighttable.graphics.beginFill(ColorUtil.grayPercent(80));
			lighttable.graphics.drawRect(0, 0, 580, 1000);
			lighttable.graphics.endFill();
			addChild(lighttable);
			
			zoomOverlay = new Sprite();
			zoomOverlay.graphics.beginFill(ColorUtil.grayPercent(80));
			zoomOverlay.graphics.drawRect(0, 0, 580, 1000);
			zoomOverlay.graphics.endFill();
			// Wait to add to stage
			
			kioskOverlay = Assets.getKioskOverlay();
			kioskOverlay.width = 540;
			kioskOverlay.height = 960;
			// wait to add to stage
			
			toolbar = new Sprite();
			toolbar.addChild(GraphicsUtil.shapeFromSize(300, 1000, Style.TEXT_BACKGROUND));
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
			
			toggleFaceOverlayButton = new PushButton(toolbar, showOriginalRadioButton.x + showCroppedRadioButton.width + 30, targetDirectoryButton.y + targetDirectoryButton.height + 5, "Show Face Overlay", onToggleFaceOverlay);
			toggleFaceOverlayButton.toggle = true;
			
			toggleKioskOverlayButton = new PushButton(toolbar, showOriginalRadioButton.x + showCroppedRadioButton.width + 30, targetDirectoryButton.y + targetDirectoryButton.height + 5 - 40, "Show Face Overlay", onToggleKioskOverlay);
			toggleKioskOverlayButton.toggle = true;
			
			// Face Crop Rectangle Controls
			var rectControlsY:Number = showCroppedRadioButton.y + showCroppedRadioButton.height + 5;
			rectX = new NumericStepper(toolbar, 5, rectControlsY, onRectNumberChange);
			rectX.value = State.faceCropRect.x;
			rectY = new NumericStepper(toolbar, 100, rectControlsY, onRectNumberChange);
			rectY.value = State.faceCropRect.y;
			rectWidth = new NumericStepper(toolbar, 5, rectControlsY + 20, onRectNumberChange);
			rectWidth.value = State.faceCropRect.width;
			rectHeight = new NumericStepper(toolbar, 100, rectControlsY + 20, onRectNumberChange);
			rectHeight.value = State.faceCropRect.height;
			
			new PushButton(toolbar, 5, rectHeight.y + rectHeight.height + 5, "Set Face Rect", onUpdateCropButton); 
			
			backToGridButton = new PushButton(toolbar, 5, 800, "Back to Grid", onBackToGridButton);
			backToGridButton.visible = false;
			
			exportButton = new PushButton(toolbar, 150, 800, "Export Batch", onExportButton);
			
			
			// Listen to the lighttable
			lighttable.addEventListener(FaceImage.FACE_SELECTED, onFaceSelected);
			// TODO button to show overlays
			
			
			zoomOverlay.addEventListener(Event.CHANGE, onCropRectChanged);
		}
		
		private function onRectNumberChange(e:Event):void {
			State.faceCropRect = new Rectangle(rectX.value, rectY.value, rectWidth.value, rectHeight.value);
		}
		
		private function onCropRectChanged(e:Event):void {
			trace("Rect change!");
			rectX.value = State.faceCropRect.x;
			rectY.value = State.faceCropRect.y;
			rectWidth.value = State.faceCropRect.width;
			rectHeight.value = State.faceCropRect.height;			
		}
		
		
		private function onExportButton(e:Event):void {
			if (State.targetDirectory != null) {
				
				for each (var image:FaceImage in State.images) {
					
					
					// TODO add suffix
					var newName:String = image.fileName;
					
					trace("Saving " + State.targetDirectory.url + newName);
					FileUtil.saveJpeg(image.faceCropBitmap, State.targetDirectory.url, newName, 100);

					// Save cropped
					
					
					
				}
				
				
				
				
			}
			
			
		}
		
		private function onToggleFaceOverlay(e:Event):void {
			
			State.showFaceOverlay = toggleFaceOverlayButton.selected;
			drawFaceGrid();
		}
		
		private function onToggleKioskOverlay(e:Event):void {
			State.showKioskOverlay = toggleKioskOverlayButton.selected;			
			drawFaceGrid();
		}		
		
		
		
		
		private function onFaceSelected(e:FaceImageEvent):void {
			State.zoomedFace = e.target as FaceImage;
			State.showZoomOverlay = true;
			backToGridButton.visible = true;
			drawFaceGrid();
		}
		
		
		private function onUpdateCropButton(e:Event):void {
			updateFaceCrop();
			drawFaceGrid();
		}
		
		private function onShowOriginal(e:Event):void {
			State.viewMode = State.SHOW_ORIGINAL;			
			drawFaceGrid();
		}
		
		private function onShowCrop(e:Event):void {
			State.viewMode = State.SHOW_CROPPED;
			drawFaceGrid();
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

		private function onBackToGridButton(e:Event):void {
			backToGridButton.visible = false;
			State.showZoomOverlay = false;
			drawFaceGrid();
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

			updateFaceCrop(); // first time			
			
			drawFaceGrid();
			
		}
		
		private function updateFaceCrop():void {
			trace("Updating face crop");
			
			// scale up the rect
			
			
			for each (var image:FaceImage in State.images) {
				
				
				
				image.faceCropBitmap = Utilities.cropToFace(image.originalBitmap, image.faceRect, State.faceCropRect);
				
				// Over the face croppped image
				image.cropBitmapOverlay = new Bitmap(image.originalBitmap.bitmapData.clone(), PixelSnapping.AUTO, true);
				image.cropBitmapOverlay.bitmapData.draw(GraphicsUtil.shapeFromRect(image.faceRect, 0xff0000), null, null, null, null, true);
				image.cropBitmapOverlay.bitmapData = BitmapUtil.scaleToFill(image.cropBitmapOverlay.bitmapData, image.cropBitmap.bitmapData.width, image.cropBitmap.bitmapData.height);
				
				// Face Crop with overlay
				image.faceCropBitmapOverlay = new Bitmap(image.faceCropBitmap.bitmapData.clone(), PixelSnapping.AUTO, true);
				image.faceCropBitmapOverlay.bitmapData.draw(GraphicsUtil.shapeFromRect(State.faceCropRect, 0xff0000));
			}
		}
		
		
		private function drawFaceGrid():void {
			var bitmapField:String;
			if (State.viewMode == State.SHOW_CROPPED) {
				bitmapField = "faceCropBitmap";
			}
			else if (State.viewMode == State.SHOW_ORIGINAL) {
				bitmapField = "cropBitmap";
			}			
			

			
			
			// Zoom
			if (State.showZoomOverlay) {

				if (!this.contains(zoomOverlay)) {
					addChild(zoomOverlay);
				}						
					
					var zoomImage:FaceImage = State.zoomedFace;
					GraphicsUtil.removeChildren(zoomImage);
					
					zoomImage[bitmapField].width = 540;
					zoomImage[bitmapField].height = 960;
					zoomImage.addChild(zoomImage[bitmapField]);

					
					// draw the face overlays
					if (State.showFaceOverlay) {
						// Over the original cropped image
						var zoomBitmapOverlay:Bitmap = zoomImage[bitmapField + "Overlay"];
						
						zoomBitmapOverlay.width = zoomImage[bitmapField].width;
						zoomBitmapOverlay.height = zoomImage[bitmapField].height;						
						zoomBitmapOverlay.alpha = 0.5;
						zoomImage.addChild(zoomBitmapOverlay);					
					}					
					
					
					// Overlay
					if (State.showKioskOverlay) {
						kioskOverlay.width = zoomImage[bitmapField].width; 
						kioskOverlay.height = zoomImage[bitmapField].height;
						zoomImage.addChild(kioskOverlay);
					}
					
					
					
					var cropRect:CropRect = new CropRect();
					zoomImage.addChild(cropRect);					

					
					
					zoomImage.x = gridPadding * 2;
					zoomImage.y = gridPadding * 2;					
					zoomOverlay.addChild(zoomImage);

					// And the interaction rectangle
				
			}
			else {
				// Update light tablelayout
				if (this.contains(zoomOverlay)) removeChild(zoomOverlay);				
				
				GraphicsUtil.removeChildren(lighttable);
				for (var i:int = 0; i < State.images.length; i++) {
					var image:FaceImage = State.images[i];
					GraphicsUtil.removeChildren(image);				
					
					var bitmap:Bitmap = image[bitmapField];
					bitmap.width = gridPhotoWidth;
					bitmap.height = gridPhotoHeight;
					image.x = ((i % gridCols) * gridCellWidth + (gridPadding * ((i % gridCols) + 1))); + ((gridCellWidth - gridPhotoWidth) / 2);
					image.y = (int(i / gridCols) * gridCellHeight + (gridPadding * (int(i / gridCols) + 1))) + ((gridCellHeight - gridPhotoHeight) / 2);
					image.addChild(bitmap);
					
					
					// Overlay
					if (State.showKioskOverlay) {
						var overlayBitmap:Bitmap = new Bitmap(kioskOverlay.bitmapData.clone(), PixelSnapping.AUTO, true);
						overlayBitmap.width = gridPhotoWidth; 
						overlayBitmap.height = gridPhotoHeight;
						image.addChild(overlayBitmap);
					}
										
					
					
					
					// draw the face overlays
					if (State.showFaceOverlay) {
						// Over the original cropped image
						var bitmapOverlay:Bitmap = image[bitmapField + "Overlay"];
						
						bitmapOverlay.width = gridPhotoWidth;
						bitmapOverlay.height = gridPhotoHeight;						
						bitmapOverlay.alpha = 0.5;
						image.addChild(bitmapOverlay);					
					}
					

					
					lighttable.addChild(image);
				}				
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