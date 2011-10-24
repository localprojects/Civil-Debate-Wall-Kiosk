package faceCropTool.core {
	
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.bit101.components.Window;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import faceCropTool.faceImage.FaceImage;
	import faceCropTool.faceImage.FaceImageEvent;
	import faceCropTool.faceImage.FaceImageLoader;
	import faceCropTool.utilities.CropRect;
	import faceCropTool.utilities.Utilities;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	
	
	public class FaceCropTool extends Sprite {
		
		// Containers		
		private var lighttable:Sprite;
		private var toolbar:Sprite;
		private var zoomOverlay:Sprite;
		
		// Tools
		private var imageLoader:FaceImageLoader;		
		
		// Grid
		private var gridRows:int;
		private var gridCols:int;
		private var gridCellWidth:Number;
		private var gridCellHeight:Number;	
		private var gridPhotoWidth:Number;
		private var gridPhotoHeight:Number;	
		private var gridPadding:Number = 10;		
		
		// Gui stuff
		// View Controls
		private var showGridRadioButton:RadioButton;
		private var showZoomRadioButton:RadioButton;	
		private var designOverlayCheckbox:CheckBox;
		private var faceOverlayCheckbox:CheckBox;		
		private var showOriginalRadioButton:RadioButton;
		private var showCroppedRadioButton:RadioButton;		

		
		// Import / Export Controls	
		private var sourceButton:PushButton;
		private var destinationButton:PushButton;		
		private var cropDrop:ComboBox;
		private var sourceLabel:Label;
		private var destinationLabel:Label;
		private var suffixInputText:InputText;
		private var exportButton:PushButton;
		
		// Dimension Controls
		private var rectX:NumericStepper;
		private var rectY:NumericStepper;
		private var rectWidth:NumericStepper;
		private var rectHeight:NumericStepper;		
		private var outputWidth:NumericStepper;
		private var outputHeight:NumericStepper;				

		
		public function FaceCropTool() {
			super();
			
			// Degine "empty" state
			State.images = [];
			State.sourceDirectory = new File();
			State.targetDirectory = new File();
			State.cachePath = "/Users/Mika/Code/CivilDebateWall/lp-cdw/air_projects/face_crop_tool/data/face_data.txt";
			State.viewMode = State.SHOW_ORIGINAL;
			State.showFaceOverlay = false;
			State.showZoomOverlay = false;
			State.fileSuffix = "modified";
			
			State.designOverlay = Assets.getKioskOverlay();			
			State.faceCropRect = Assets.KIOSK_DEFAULT_FACE_TARGET;
			State.targetWidth = Assets.KIOSK_WIDTH;
			State.targetHeight = Assets.KIOSK_HEIGHT;
			
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
			

			
			toolbar = new Sprite();
			toolbar.addChild(GraphicsUtil.shapeFromSize(159, 1000, ColorUtil.grayPercent(80)));
			toolbar.x = lighttable.width;
			addChild(toolbar);

			
			// View Controls
			var viewControlWindow:Window = new Window(toolbar, 5, 5, "View");
			viewControlWindow.draggable = false;
			viewControlWindow.width = 144;
			viewControlWindow.height = 124;
			
			showGridRadioButton = new RadioButton(viewControlWindow, 5, 5, "Multi Face Grid", true, onShowGridRadioButton);
			showGridRadioButton.groupName = "viewModeGroup";
			showZoomRadioButton = new RadioButton(viewControlWindow, 5, showGridRadioButton.y + showGridRadioButton.height + 5, "Single Face Zoom", false, onShowZoomRadioButton);
			showZoomRadioButton.groupName = "viewModeGroup";			
			
			designOverlayCheckbox = new CheckBox(viewControlWindow, 5, showZoomRadioButton.y + showZoomRadioButton.height + 10, "Show Design Overlay", onDesignOverlayCheckbox);
			faceOverlayCheckbox = new CheckBox(viewControlWindow, 5, designOverlayCheckbox.y + designOverlayCheckbox.height + 5, "Show Face Overlay", onFaceOverlayCheckbox);			
			
			showOriginalRadioButton = new RadioButton(viewControlWindow, 5, faceOverlayCheckbox.y + faceOverlayCheckbox.height + 10, "Show Original", true, onShowOriginal);
			showOriginalRadioButton.groupName = "portraitModeGroup";
			showCroppedRadioButton = new RadioButton(viewControlWindow, 5, showOriginalRadioButton.y + showOriginalRadioButton.height + 5, "Show Face Crop", false, onShowCrop);
			showCroppedRadioButton.groupName = "portraitModeGroup";			
						
			
			// Crop and Size Controls
			var cropControlWindow:Window = new Window(toolbar, 5, viewControlWindow.y + viewControlWindow.height + 10, "Dimensions");
			cropControlWindow.draggable = false;
			cropControlWindow.width = 144;
			cropControlWindow.height = 216;
			
			var cropDropLabel:Label = new Label(cropControlWindow, 5, 5, "Presets:");			
			
			cropDrop = new ComboBox(cropControlWindow, 5, cropDropLabel.y + cropDropLabel.height, "Default Kiosk");
			cropDrop.dropTarget
			cropDrop.addItem("Default Kiosk");
			cropDrop.addItem("Default Web");
			cropDrop.numVisibleItems = cropDrop.items.length;
			cropDrop.addEventListener(Event.SELECT, onCropDrop);
			
			var faceRectLabel:Label = new Label(cropControlWindow, 5, cropDrop.y + cropDrop.height + 5, "Face Target Rectangle:");
			
			var rectControlsY:Number = faceRectLabel.y + faceRectLabel.height;
			rectX = new NumericStepper(cropControlWindow, 5, rectControlsY, onRectNumberChange);
			rectX.value = State.faceCropRect.x;
			rectX.width = 65;
			rectX.maximum = 9999;
			rectY = new NumericStepper(cropControlWindow, 74, rectControlsY, onRectNumberChange);
			rectY.value = State.faceCropRect.y;
			rectY.width = 65;
			rectY.maximum = 9999;			
			rectWidth = new NumericStepper(cropControlWindow, 5, rectControlsY + 20, onRectNumberChange);
			rectWidth.value = State.faceCropRect.width;
			rectWidth.width = 65;
			rectWidth.maximum = 9999;			
			rectHeight = new NumericStepper(cropControlWindow, 74, rectControlsY + 20, onRectNumberChange);
			rectHeight.value = State.faceCropRect.height;
			rectHeight.width = 65;
			rectHeight.maximum = 9999;			
			
			var setFaceRectButton:PushButton = new PushButton(cropControlWindow, 5, rectHeight.y + rectHeight.height + 5, "Set Face Rect", onUpdateCropButton); 
			
			var targetDimensionLabel:Label = new Label(cropControlWindow, 5, setFaceRectButton.y + setFaceRectButton.height + 5, "Output dimensions:");
			outputWidth = new NumericStepper(cropControlWindow, 5, targetDimensionLabel.y + targetDimensionLabel.height, onOutputWidth);
			outputWidth.value = State.targetWidth;
			outputWidth.width = 65;
			outputWidth.maximum = 9999;			
			outputHeight = new NumericStepper(cropControlWindow, 74, targetDimensionLabel.y + targetDimensionLabel.height, onOutputHeight);
			outputHeight.value = State.targetHeight;
			outputHeight.width = 65;
			outputHeight.maximum = 9999;			
			
			var setOutputDimensionsButton:PushButton = new PushButton(cropControlWindow, 5, outputHeight.y + outputHeight.height + 5, "Set Output Dimensions", onUpdateOutputDimensions); 			

			
			// Import / Export Controls
			var importExportControlWindow:Window = new Window(toolbar, 5, cropControlWindow.y + cropControlWindow.height + 10, "Import / Export");
			importExportControlWindow.draggable = false;
			importExportControlWindow.width = 144;
			importExportControlWindow.height = 144;			

			sourceButton = new PushButton(importExportControlWindow, 5, 5, "+", onSourceButton);
			sourceButton.width = 20;
			sourceLabel = new Label(importExportControlWindow, sourceButton.x + sourceButton.width + 5, sourceButton.y, "Source: Please select ");
						
			destinationButton = new PushButton(importExportControlWindow, 5, sourceButton.y + sourceButton.height + 5, "+", onDestinationButton);
			destinationButton.width = 20;
			destinationLabel = new Label(importExportControlWindow, destinationButton.x + destinationButton.width + 5, destinationButton.y, "Dest: Please select");
			
			var suffixLabel:Label = new Label(importExportControlWindow, 5, destinationButton.y + destinationButton.height + 5, "Exported file suffix:");
			suffixInputText = new InputText(importExportControlWindow, 5, suffixLabel.y + suffixLabel.height, State.fileSuffix, onSuffixInputText);
			
			exportButton = new PushButton(importExportControlWindow, 5, suffixInputText.y + suffixInputText.height + 10, "Export All", onExportButton);			

			// Listen to the lighttable
			lighttable.addEventListener(FaceImage.FACE_SELECTED, onFaceSelected);
			zoomOverlay.addEventListener(Event.CHANGE, onCropRectChanged);
		}
		
		
		// View Callbacks
		private function onDesignOverlayCheckbox(e:Event):void {
			State.showDesignOverlay = designOverlayCheckbox.selected;			
			drawFaceGrid();			
		}
		
		private function onFaceOverlayCheckbox(e:Event):void {
			State.showFaceOverlay = faceOverlayCheckbox.selected;
			drawFaceGrid();			
		}	
		
		private function onShowGridRadioButton(e:Event):void {
			State.showZoomOverlay = false;
			drawFaceGrid();
		}
		
		private function onShowZoomRadioButton(e:Event):void {
			State.showZoomOverlay = true;
			drawFaceGrid();			
		}	
			
		private function onFaceSelected(e:FaceImageEvent):void {
			trace("Face selected");
			showGridRadioButton.selected = false;
			showZoomRadioButton.selected = true;
			
			State.zoomedFace = e.target as FaceImage;
			State.showZoomOverlay = true;
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
			
		
		// Dimension Callbacks	
		private function onCropDrop(e:Event):void {
			
			if (cropDrop.selectedIndex == 0) {
				State.designOverlay = Assets.getKioskOverlay();			
				State.faceCropRect = Assets.KIOSK_DEFAULT_FACE_TARGET;
				State.targetWidth = Assets.KIOSK_WIDTH;
				State.targetHeight = Assets.KIOSK_HEIGHT;
			}
			else {
				trace("Web overlay");
				State.designOverlay = Assets.getWebOverlay();			
				State.faceCropRect = Assets.WEB_DEFAULT_FACE_TARGET;
				State.targetWidth = Assets.WEB_WIDTH;
				State.targetHeight = Assets.WEB_HEIGHT;				
			}
			
			// Update the gui
			rectX.value = State.faceCropRect.x;
			rectY.value = State.faceCropRect.y;
			rectWidth.value = State.faceCropRect.width;
			rectHeight.value = State.faceCropRect.height;						
			
			outputWidth.value = State.targetWidth;
			outputHeight.value = State.targetHeight;
			
			// Reprocess accordingly	
			updateOutputDimensions();
		}
		
		private function onOutputWidth(e:Event):void {
			State.targetWidth = outputWidth.value;
		}
		
		private function onOutputHeight(e:Event):void {
			State.targetHeight = outputHeight.value;
		}		
		
		
		private function onRectNumberChange(e:Event):void {
			// Updates the draggable crop rectangle to show the latest control panel values
			State.faceCropRect = new Rectangle(rectX.value, rectY.value, rectWidth.value, rectHeight.value);
		}
		
		
		private function onCropRectChanged(e:Event):void {
			// Updates control panel to show the latest draggable crop rectangle values			
			rectX.value = State.faceCropRect.x;
			rectY.value = State.faceCropRect.y;
			rectWidth.value = State.faceCropRect.width;
			rectHeight.value = State.faceCropRect.height;			
		}
		
		private function onUpdateOutputDimensions(e:Event):void {
			trace("Output changed!");
			updateOutputDimensions();
		}
		
		private function onUpdateCropButton(e:Event):void {
			updateFaceCrop();
			drawFaceGrid();
		}		
		
		
		// Import Export Callbacks
		private function onSourceButton(e:Event):void {
			State.sourceDirectory.addEventListener(Event.SELECT, onSourceSelected);
			State.sourceDirectory.browseForDirectory("Source Folder");
		}

		private function onSourceSelected(e:Event):void {
			State.images = [];
			State.sourceDirectory.removeEventListener(Event.SELECT, onSourceSelected);
			sourceLabel.text = "/" + State.sourceDirectory.name;
			trace("Selected source folder: " + State.sourceDirectory.url);
			
			imageLoader = new FaceImageLoader();
			imageLoader.addEventListener(Event.COMPLETE, onLoadComplete);
			imageLoader.loadFromDirectory(State.sourceDirectory);
		}
				
		
		private function onDestinationButton(e:Event):void {
			State.targetDirectory.addEventListener(Event.SELECT, onDestinationSelected);
			State.targetDirectory.browseForDirectory("Target Folder");
		}
		
		private function onDestinationSelected(e:Event):void {
			State.targetDirectory.removeEventListener(Event.SELECT, onDestinationSelected);
			destinationLabel.text = "/" + State.targetDirectory.name;
			trace("Selected target folder: " + State.targetDirectory.url);
		}
		
		private function onSuffixInputText(e:Event):void {
			State.fileSuffix =	suffixInputText.text;
		}		
		
		private function onExportButton(e:Event):void {
			if (State.targetDirectory != null) {
				for each (var image:FaceImage in State.images) {
					// Append the suffix
					var base:String = StringUtil.stripFileExtension(image.fileName);
					var extension:String = StringUtil.popFileExtension(image.fileName);
					var newName:String = base + State.fileSuffix + extension;
					
					trace("Saving " + State.targetDirectory.url + newName);
					FileUtil.saveJpeg(image.faceCropBitmap, State.targetDirectory.url, newName, 100);
				}
			}
		}		
				
		
		// Image loading callback
		private function onLoadComplete(e:Event):void {
			imageLoader.removeEventListener(Event.COMPLETE, onLoadComplete);			
			trace("load complete");
						
			// Default zoomed
			State.zoomedFace = State.images[0];
			
			
			// lay out grid
			// w,h width and height of your rectangles
			// W,H width and height of the screen
			// N number of your rectangles that you would like to fit in
			
			// ratio
			// nbRows and nbColumns are what you are looking for
			// nbColumns = nbRows * r (there will be problems of integers)
			// we are looking for the minimum values of nbRows and nbColumns such that
			// N <= nbRows * nbColumns = (nbRows ^ 2) * r
			gridRows = Math.ceil( Math.sqrt( State.images.length / 1 ) ); // r is positive...
			gridCols = Math.ceil( State.images.length / gridRows);
			
			gridCellWidth = (580 - (gridPadding * (gridCols + 1))) / gridCols;
			gridCellHeight = (1000 - (gridPadding * (gridRows + 1))) / gridRows;
			
			// Fit the image inside the cell
			var resizedImageBounds:Rectangle = GeomUtil.scaleToFit(new Rectangle(0, 0, State.targetWidth, State.targetHeight), new Rectangle(0, 0, gridCellWidth, gridCellHeight));
			gridPhotoWidth = resizedImageBounds.width; 
			gridPhotoHeight = resizedImageBounds.height;

			updateFaceCrop(); // first time			
			drawFaceGrid();
		}
		
		
		// Drawing and Updating
		private function updateOutputDimensions():void {
			State.images = [];	
			imageLoader = new FaceImageLoader();
			imageLoader.addEventListener(Event.COMPLETE, onLoadComplete);
			imageLoader.loadFromDirectory(State.sourceDirectory);			
		}
		
		
		private function updateFaceCrop():void {
			// scale up the rect
			for each (var image:FaceImage in State.images) {
				
				image.faceCropBitmap = Utilities.cropToFace(image.originalBitmap, image.faceRect, State.faceCropRect, State.targetWidth, State.targetHeight);
				
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
					
					zoomImage[bitmapField].width = State.targetWidth / 2;
					zoomImage[bitmapField].height = State.targetHeight / 2;
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
					if (State.showDesignOverlay) {
						var zoomOverlayBitmap:Bitmap = new Bitmap(State.designOverlay.bitmapData.clone(), PixelSnapping.AUTO, true);
						zoomOverlayBitmap.width = zoomImage[bitmapField].width; 
						zoomOverlayBitmap.height = zoomImage[bitmapField].height;
						zoomImage.addChild(zoomOverlayBitmap);
					}					

					var cropRect:CropRect = new CropRect();
					zoomImage.addChild(cropRect);
					zoomImage.x = gridPadding * 2;
					zoomImage.y = gridPadding * 2;					
					zoomOverlay.addChild(zoomImage);

					// And the interaction rectangle?
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
					
					
					// Design Overlay
					if (State.showDesignOverlay) {
						var overlayBitmap:Bitmap = new Bitmap(State.designOverlay.bitmapData.clone(), PixelSnapping.AUTO, true);
						overlayBitmap.width = gridPhotoWidth; 
						overlayBitmap.height = gridPhotoHeight;
						image.addChild(overlayBitmap);
					}
										
					// Face Overlay
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
		
		
	}
}