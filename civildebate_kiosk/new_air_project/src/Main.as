package {
	
	import com.bit101.components.ColorChooser;
	import com.bit101.components.FPSMeter;
	import com.bit101.components.HSlider;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.Event;
	import flash.net.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	
	import net.localprojects.blocks.*;
	import net.localprojects.camera.*;
	import net.localprojects.elements.*;
	import net.localprojects.keyboard.*;
	import net.localprojects.text.Text;
	import net.localprojects.ui.*;
	
	import sekati.layout.Arrange;
	
	//import net.localprojects.CDW;
	
	[SWF(width="1080", height="1920", frameRate="60")]
	public class Main extends Sprite	{
		
		public function Main() {
			trace("doing text dev");
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			stage.nativeWindow.width = 1080;
			stage.nativeWindow.height = 1920;						
			
			
			var text:Text = new Text("Hello world");
			addChild(text);
			text.x = 100;
			text.y = 100;
			
			
			// Tween Sliders
			var sizeSlider:HSlider = new HSlider(this, 0, 0, function():void{ text.textSize = sizeSlider.value });
			sizeSlider.minimum = 0;
			sizeSlider.maximum = 200;
			var colorChooser:ColorChooser = new ColorChooser(this, 0, 0, 0, function():void { text.textColor = colorChooser.value });
			var spacingSlider:HSlider = new HSlider(this, 0, 0, function():void{ text.textLetterSpacing = spacingSlider.value });
			spacingSlider.minimum = -50;
			spacingSlider.maximum = 50;
			
			
			
			
			
			// Position controls automatically
			var controls:Array = [sizeSlider, colorChooser, spacingSlider];
			var yAccumulator:Number = 5;
			
			for (var i:int = 0; i < controls.length; i++) {
				controls[i].x = 5;
				controls[i].y = yAccumulator;
				yAccumulator += controls[i].y + controls[i].height + 5; 
			}
			
			
				
			
			//var civilDebateWall:CDW = new CDW();
			//addChild(civilDebateWall);
		}
	}
}
