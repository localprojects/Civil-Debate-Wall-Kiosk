package {
	import com.bit101.components.TextArea;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.TweenPlugin;
	
	import com.kitschpatrol.futil.*;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.tweenPlugins.*;
	
	import flash.display.Sprite;
	import flash.text.Font;
	
	import flashx.textLayout.formats.TextAlign;
	
	import uk.co.soulwire.gui.SimpleGUI;
	
	
	[SWF(width="1024", height="768", frameRate="60")]	
	public class FutilDemo extends Sprite {

		private var gui:SimpleGUI;
		public var testBlock:TextBlock;
		public var targets:Object;
		public var tweenDuration:Number;
		public var targetTween:Boolean;
		
		public function FutilDemo() {
			TweenPlugin.activate([FutilBlockPlugin]);			
			
			
			//Font.registerFont(Assets.FontLight);
			
			// Test Object
			testBlock = new TextBlock({textFont: Assets.FONT_LIGHT, x: 300, y: 300, showRegistrationPoint: true, maxWidth: 10000, text: "mea Graece quidam oporteat iuvaret mea Graece quidam oporteat iuvaret mea Graece quidam oporteat iuvaret mea Graece quidam oporteat iuvaret mea Graece quidam oporteat iuvaret mea Graece quidam oporteat iuvaret"});
			
			
//			testBlock = new TextBlock({text: "Do you feel our public education provides our children with a thorough education these days?",
//				backgroundColor: 0x322f31,
//				textSizePixels: 274,
//				leading: 196,
//				textColor: 0xffffff,
//				minWidth: 500,
//				alignmentPoint: Alignment.CENTER,
//				height: 914,
//				growthMode: TextBlock.MAXIMIZE_HEIGHT,
//				paddingLeft: 990,
//				paddingRight: 990														 
//			});			
			
			addChild(testBlock);			
			
			// Tween Targets
			targets = {};
			tweenDuration = 1;
			targetTween = false;
			
			// GUI
			// http://blog.soulwire.co.uk/code/actionscript-3/simple-flash-prototype-gui-tool
			generateGui("testBlock");
		}
		
		
		private function generateGui(targetObject:String):void {
			gui = new SimpleGUI(this);
			gui.addColumn("BASIC");
			gui.addSlider(targetObject + ".x", -stage.stageWidth * 2, stage.stageWidth * 2, {label: "X"});
			gui.addSlider(targetObject + ".y", -stage.stageHeight * 2, stage.stageHeight * 2, {label: "Y"});			
			gui.addSlider(targetObject + ".minWidth", 0, stage.stageWidth, {label: "Min Width"});
			gui.addSlider(targetObject + ".minHeight", 0, stage.stageHeight, {label: "Min Height"});
			gui.addSlider(targetObject + ".maxWidth", 0, stage.stageWidth, {label: "Max Width"});
			gui.addSlider(targetObject + ".maxHeight", 0, stage.stageHeight, {label: "Max Height"});
			gui.addSlider(targetObject + ".paddingTop", 0, 200, {label: "Padding Top"});
			gui.addSlider(targetObject + ".paddingRight", 0, 200, {label: "Padding Right"});
			gui.addSlider(targetObject + ".paddingBottom", 0, 200, {label: "Padding Bottom"});
			gui.addSlider(targetObject + ".paddingLeft", 0, 200, {label: "Padding Left"});			
			gui.addSlider(targetObject + ".alignmentPointX", 0, 1, {label: "Alignment X"});
			gui.addSlider(targetObject + ".alignmentPointY", 0, 1, {label: "Alignment Y"});
			gui.addComboBox(targetObject + ".alignmentPoint", [
				{label:"Left", data: Alignment.LEFT},
				{label:"Center", data: Alignment.CENTER},
				{label:"Right", data: Alignment.RIGHT},						
				{label:"Top Left", data: Alignment.TOP_LEFT},
				{label:"Top", data: Alignment.TOP},
				{label:"Top Right", data: Alignment.TOP_RIGHT},
				{label:"Bottom Left", data: Alignment.BOTTOM_LEFT},
				{label:"Bottom", data: Alignment.BOTTOM},
				{label:"Bottom Right", data: Alignment.BOTTOM_RIGHT},
			], {label: "Alignment"});
			gui.addSlider(targetObject + ".registrationPointX", 0, 1, {label: "Registration X"});
			gui.addSlider(targetObject + ".registrationPointY", 0, 1, {label: "Registration Y"});
			gui.addToggle(targetObject + ".showRegistrationPoint", {label: "Show Registration Point"});
			gui.addColour(targetObject + ".backgroundColor", {label: "Background Color"});
			
			gui.addColumn("TEXT");
			gui.addTextArea(targetObject + ".text", {label: "Content"});
			gui.addSlider(targetObject + ".textSizePixels", 0, 500, {label: "Size"});
			gui.addSlider(targetObject + ".leading", -50, 50, {label: "Leading"});			
			gui.addColour(targetObject + ".textColor", {label: "Color"});
			gui.addSlider(targetObject + ".letterSpacing", 0, 20, {label: "Letter Spacing"});
			gui.addComboBox(targetObject + ".textAlignmentMode", [
				{label:"Left", data: TextAlign.LEFT},
				{label:"Center", data: TextAlign.CENTER},
				{label:"Right", data: TextAlign.RIGHT},
				{label:"Justify", data: TextAlign.JUSTIFY},				
			], {label: "Text Alignment"});
			
			
			gui.addComboBox(targetObject + ".textFont", [
				{label: Assets.FONT_BOLD, data: Assets.FONT_BOLD},
				{label: Assets.FONT_BOLD_ITALIC, data: Assets.FONT_BOLD_ITALIC},
				{label: Assets.FONT_HEAVY, data: Assets.FONT_HEAVY},
				{label: Assets.FONT_LIGHT, data: Assets.FONT_LIGHT},
				{label: Assets.FONT_LIGHT_ITALIC, data: Assets.FONT_LIGHT_ITALIC},
				{label: Assets.FONT_REGULAR, data: Assets.FONT_REGULAR},
				{label: Assets.FONT_REGULAR_ITALIC, data: Assets.FONT_REGULAR_ITALIC},
			], {label: "Font"});			
			
			gui.addButton("Random text", {callback: onRandomText});			
			gui.addColumn("Tween");
						
			gui.addToggle("targetTween", {label: "Use TweenMax", callback: onTargetTweenChange});
			if (targetTween) {
				gui.addStepper("tweenDuration", 0, 20, {label: "Duration"});
				gui.addButton("Tween to Target", {callback: tweenToTarget});
				gui.addComboBox(targetObject + ".ease", [
					{label: "None", data: Linear.easeNone},
					{label: "Cubic In", data: Cubic.easeIn},
					{label: "Cubic Out", data: Cubic.easeOut},
					{label: "Cubic InOut", data: Cubic.easeInOut},
					{label: "Quint In", data: Quint.easeIn},
					{label: "Quint Out", data: Quint.easeOut},
					{label: "Quint InOut", data: Quint.easeInOut},
					{label: "Quart In", data: Quart.easeIn},
					{label: "Quart Out", data: Quart.easeOut},
					{label: "Quart InOut", data: Quart.easeInOut},
					{label: "Quad In", data: Quad.easeIn},
					{label: "Quad Out", data: Quad.easeOut},
					{label: "Quad InOut", data: Quad.easeInOut},
					{label: "Back In", data: Back.easeIn},
					{label: "Back Out", data: Back.easeOut},
					{label: "Back InOut", data: Back.easeInOut},
					{label: "Bounce In", data: Bounce.easeIn},
					{label: "Bounce Out", data: Bounce.easeOut},
					{label: "Bounce InOut", data: Bounce.easeInOut},
					{label: "Circ In", data: Circ.easeIn},
					{label: "Circ Out", data: Circ.easeOut},
					{label: "Circ InOut", data: Circ.easeInOut},
					{label: "Elastic In", data: Elastic.easeIn},
					{label: "Elastic Out", data: Elastic.easeOut},
					{label: "Elastic InOut", data: Elastic.easeInOut},
					{label: "Expo In", data: Expo.easeIn},
					{label: "Expo Out", data: Expo.easeOut},
					{label: "Expo InOut", data: Expo.easeInOut},
					{label: "Sine In", data: Sine.easeIn},
					{label: "Sine Out", data: Sine.easeOut},
					{label: "Sine InOut", data: Sine.easeInOut},
				], {label: "Easing"});		
				

			}
			gui.show();			
		}
		
		private function onRandomText():void {
			
			testBlock.text = "Bla bla";
		}
		
		
		private function onTargetTweenChange():void {
			gui.hide();
			
			if (targetTween) {
				targets = {};
				generateGui("targets");				
			}
			else {
				generateGui("testBlock");
			}
			
		
			
		}
		
		
		private function tweenToTarget():void {
			Utilities.traceObject(targets);
			TweenMax.to(testBlock, tweenDuration, targets);
		}


	}
}