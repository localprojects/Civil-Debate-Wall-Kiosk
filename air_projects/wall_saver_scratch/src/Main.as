package {	
	
	import com.bit101.components.FPSMeter;
	import com.civildebatewall.resources.Assets;
	import com.civildebatewall.wallsaver.core.WallSaver;
	import com.civildebatewall.wallsaver.core.WallSaverControls;
	import com.civildebatewall.wallsaver.sequences.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Bitmap;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	[SWF(width="5720", height="1920", frameRate="60")]
	public class Main extends Sprite {
		
		// These will come in from FlashSpan
		public static const screenWidth:int = 1080;
		public static const screenHeight:int = 1920;
		public static const screenCount:int = 5;
		public static const bezelPixelWidth:int = 40; // 1" bezel? not the gutter...
		public static const totalWidth:int = (screenWidth * screenCount) + (bezelPixelWidth * 2 * (screenCount - 1));
		public static const totalHeight:int = screenHeight;
		public static const physicalScreenWidth = screenWidth + (bezelPixelWidth * 2);
		public static var screens:Vector.<Rectangle> = new Vector.<Rectangle>(screenCount);
		public static var bezels:Vector.<Rectangle> = new Vector.<Rectangle>;
		
		
		// Debug
		private const stageScaleFactor:Number = 4;		
		public static var controls:WallSaverControls;
		private var wallSaver:WallSaver;
		
		// Sample Content
		private var interactiveScreen1:Bitmap = Assets.getSampleKiosk1();
		private var interactiveScreen2:Bitmap = Assets.getSampleKiosk2();	
		private var interactiveScreen3:Bitmap = Assets.getSampleKiosk1();
		private var interactiveScreen4:Bitmap = Assets.getSampleKiosk2();
		private var interactiveScreen5:Bitmap = Assets.getSampleKiosk1();
		
		// FPS
		public static var fpsMeter:FPSMeter;
		
		// Global ref
		public static var self:Sprite;
		
		public function Main() {
			// Start the MonsterDebugger
			// MonsterDebugger.initialize(this);
			// MonsterDebugger.trace(this, "Hello World!");
			
			// Resize the window for development
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.LEFT;
			stage.nativeWindow.width = totalWidth / stageScaleFactor;

			stage.nativeWindow.height = (totalHeight / stageScaleFactor) + 20; // Compensate for window height?
			stage.nativeWindow.x = Screen.mainScreen.visibleBounds.left;
			stage.nativeWindow.y = Screen.mainScreen.visibleBounds.top;
			
			// Watch FPS
			fpsMeter =  new FPSMeter();
			fpsMeter.start();			
			
			// Create global reference
			self = this;
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		private function onAddedToStage(e:Event):void {
			// screen offsets, this comes in from FlashSpan
			for (var i:int = 0; i < screenCount; i++) {
				screens[i] = new Rectangle((i * screenWidth) + (i * 2 * bezelPixelWidth), 0, screenWidth, screenHeight);			
			}
			
			// bezels, this comes in from FlashSpan
			for (var j:int = 0; j < screens.length; j++) {
				var screen:Rectangle = screens[j];
				
				if (j > 0) {
					bezels.push(new Rectangle(screen.x - bezelPixelWidth, 0, bezelPixelWidth, screenHeight)); // Left bezel
				}
				
				if (j < (screens.length - 1)) {
					bezels.push(new Rectangle(screen.x + screen.width, 0, bezelPixelWidth, screenHeight)); // Right bezel
				}
			}
			
			// Add static screens
			for (var k:int = 0; k < screenCount; k++) {			
				this['interactiveScreen' + (k + 1)].x = screens[k].x;
				this['interactiveScreen' + (k + 1)].y = screens[k].y;			
				addChild(this['interactiveScreen' + (k + 1)]);
			}
			
			// Add the Wallsaver
			wallSaver = new WallSaver();

			
			// Create the control window
			controls = new WallSaverControls(wallSaver); 
			controls.activate();
			
			addChild(wallSaver);			
			
			// Draw the bezels (Debug)
			for each (var bezel:Rectangle in bezels) {
				addChild(GraphicsUtil.shapeFromRect(bezel));
			}
			
		}
		

		// ========================================================================
		
		
		// TODO put this into FlashSpan, returns screen index, or -1 if it's in the gutter or off the screen
		public static function pointIsOnScreen(p:Point):int {
			for (var i:int = 0; i < screens.length; i++) {
				if (screens[i].containsPoint(p)) return i;
			}
			return -1;
		}
		
		// TODO put this in flashspan, too
		public static function pointIsNearScreen(p:Point):int {
			var onScreen:int = pointIsOnScreen(p);
			
			if (onScreen > -1) {
				return onScreen;
			}
			else {
				var minDistance:Number = Number.MAX_VALUE;
				var minDistanceIndex:int = -1;
				
				for (var i:int = 0; i < screens.length; i++) {
					var screenCenter:Point = new Point(screens[i].x + (screens[i].width / 2), screens[i].y + (screens[i].height / 2));
					var distance:Number = Point.distance(p, screenCenter);
					
					if (distance < minDistance) {
						minDistance = distance;
						minDistanceIndex = i;
					}
				}
				
				return minDistanceIndex;
			}
			
			// should never get here
			return -1;
		}		
		
		
	}
}