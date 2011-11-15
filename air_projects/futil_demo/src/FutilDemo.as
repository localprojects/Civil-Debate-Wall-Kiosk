package {
	import com.bit101.components.TextArea;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.TweenPlugin;
	import com.kitschpatrol.futil.*;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.tweenPlugins.*;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextField;
	
	import flashx.textLayout.formats.BackgroundColor;
	import flashx.textLayout.formats.TextAlign;
	
	import uk.co.soulwire.gui.SimpleGUI;
	
	
	
	[SWF(width="1524", height="768", frameRate="60")]	
	public class FutilDemo extends Sprite {

		private var gui:SimpleGUI;
		public var testBlock:BlockText;
		public var targets:Object;
		public var tweenDuration:Number;
		public var targetTween:Boolean;
		
		public function FutilDemo() {
			TweenPlugin.activate([FutilBlockPlugin, NamedYPlugin]);			
			
			
			
			
			//Font.registerFont(Assets.FontLight);
			
			// Test Object
//			testBlock = new CompoundBlock({				
//				x: 400,
//				y: 600,
//				registrationPoint: Alignment.BOTTOM_LEFT,
//				showRegistrationPoint: true
//				});
			
			
			testBlock = new BlockText({
				text: "Do you feel our public education provides our children with a thorough education?",
//				backgroundColor: 0x322f31,
				textSize: 20,
//				leading: 196,
				textColor: 0xffffff,
				minWidth: 0,
				maxWidth: 2025,
				alignmentPoint: Alignment.CENTER,
				height: 20,
				growthMode: BlockText.MAXIMIZE_WIDTH,
				maxSizeBehavior: BlockText.MAX_SIZE_RESIZES,
				visible: true
			});		
			
			testBlock.x = 200;
			testBlock.y = 250;
			
			
			//testBlock.onInput.push(onInput);
			
			addChild(testBlock);			
			
			// Tween Targets
			targets = {};
			tweenDuration = 1;
			targetTween = false;
			
			// GUI
			// http://blog.soulwire.co.uk/code/actionscript-3/simple-flash-prototype-gui-tool
			generateGui("testBlock");
		}
		
//		private function onInput(e:Event):void {
//			// test profanity check!
//			if (StringUtil.isProfane(testBlock.text)) {
//				testBlock.backgroundColor = 0xff0000;
//			}
//			else {
//				testBlock.backgroundColor = 0x00ff00;
//			}
//		}
		
		
		private function generateGui(targetObject:String):void {
			gui = new SimpleGUI(this);
			gui.addColumn("BASIC");
			gui.addSlider(targetObject + ".x", -stage.stageWidth * 2, stage.stageWidth * 2, {label: "X"});
			gui.addSlider(targetObject + ".y", -stage.stageHeight * 2, stage.stageHeight * 2, {label: "Y"});			
			gui.addSlider(targetObject + ".minWidth", 0, stage.stageWidth, {label: "Min Width"});
			gui.addSlider(targetObject + ".minHeight", 0, stage.stageHeight, {label: "Min Height"});
			gui.addSlider(targetObject + ".maxWidth", 0, 4000, {label: "Max Width"});
			gui.addSlider(targetObject + ".maxHeight", 0, stage.stageHeight, {label: "Max Height"});
			gui.addSlider(targetObject + ".paddingTop", 0, 200, {label: "Padding Top"});
			gui.addSlider(targetObject + ".paddingRight", 0, 200, {label: "Padding Right"});
			gui.addSlider(targetObject + ".paddingBottom", 0, 200, {label: "Padding Bottom"});
			gui.addSlider(targetObject + ".paddingLeft", 0, 200, {label: "Padding Left"});	
			gui.addSlider(targetObject + ".backgroundRadiusTopLeft", 0, 50, {label: "rtl"});
			gui.addSlider(targetObject + ".backgroundRadiusTopRight", 0, 50, {label: "rtr"});
			gui.addSlider(targetObject + ".backgroundRadiusBottomRight", 0, 50, {label: "rbr"});
			gui.addSlider(targetObject + ".backgroundRadiusBottomLeft", 0, 50, {label: "rbl"});
			gui.addSlider(targetObject + ".alignmentX", 0, 1, {label: "Alignment X"});
			gui.addSlider(targetObject + ".alignmentY", 0, 1, {label: "Alignment Y"});
			gui.addSlider(targetObject + ".scrollX", 0, 500, {label: "Scroll X"});
			gui.addSlider(targetObject + ".scrollY", 0, 500, {label: "Scroll Y"});			
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
			gui.addSlider(targetObject + ".registrationX", 0, 1, {label: "Registration X"});
			gui.addSlider(targetObject + ".registrationY", 0, 1, {label: "Registration Y"});
			gui.addToggle(targetObject + ".showRegistrationPoint", {label: "Show Registration Point"});
			
			gui.addColour(targetObject + ".backgroundColor", {label: "Background Color"});

			
			gui.addColumn("TEXT");
			gui.addToggle(targetObject + ".selectable", {label: "Selectable"});
			gui.addToggle(targetObject + ".input", {label: "Input"});			
			gui.addTextArea(targetObject + ".text", {label: "Content"});
			gui.addSlider(targetObject + ".textSize", 0, 500, {label: "Size"});
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
			
			TweenMax.to(testBlock, 5, {y: Alignment.OFF_STAGE_BOTTOM});
			
			
			//testBlock.text = "Bla bla";
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
			ObjectUtil.traceObject(targets);
			TweenMax.to(testBlock, tweenDuration, targets);
		}


	}
}