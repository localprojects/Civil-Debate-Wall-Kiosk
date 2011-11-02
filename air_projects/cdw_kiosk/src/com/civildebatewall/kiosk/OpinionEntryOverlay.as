package com.civildebatewall.kiosk {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import flashx.textLayout.formats.TextAlign;

	public class OpinionEntryOverlay extends BlockInertialScroll {
		
		private var question:BlockText;
		private var nameCharacterCount:BlockText;		
		private var nameField:BlockText;
		private var opinionField:BlockText;
		
		public function OpinionEntryOverlay()	{
			super({
				width: 1080,
				height: 1920,
				backgroundAlpha: 0,
				paddingLeft: 29
			});
			
			question = new BlockText({
				paddingTop: 65,
				paddingRight: 100,
				paddingBottom: 65,
				paddingLeft: 100,
				backgroundColor: 0xffffff,
				textSizePixels: 28,
				leading: 22,
				paddingLeft: 30,
				paddingRight: 30,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textColor: 0x000000,
				alignmentPoint: Alignment.CENTER,
				backgroundRadiusTopLeft: 12,
				backgroundRadiusTopRight: 12,
				width: 1022,
				height: 188
			});

			addChild(question);
			
			var formUnderlay:Shape = GraphicsUtil.shapeFromSize(1022, 929, ColorUtil.gray(211));
			formUnderlay.y = question.bottom;
			addChild(formUnderlay);
			
			var nameLabel:BlockText = new BlockText({
				text: "WHAT IS YOUR NAME? ",
				textFont: Assets.FONT_BOLD,
				textBold: true,
				backgroundAlpha: 0,
				textColor: ColorUtil.gray(79),
				textSizePixels: 16,
				letterSpacing: -1,
				width: 370,
				x: 72,
				y: 322
			});
			
			addChild(nameLabel);
			
			nameCharacterCount = new BlockText({
				text: nameLabel.maxChars + " Chars",
				textFont: Assets.FONT_BOLD,				
				backgroundAlpha: 0,
				textColor: ColorUtil.gray(79),
				textSizePixels: 16,
				letterSpacing: -1,
				textAlignmentMode: TextAlign.RIGHT,
				registrationPoint: Alignment.TOP_RIGHT,
				showRegistrationPoint: true
			});
			nameCharacterCount.x = 560;
			nameCharacterCount.y = 322;
			
			addChild(nameCharacterCount);
			
			
			
			nameField = new BlockText({
				text: "",
				textFont: Assets.FONT_BOLD,				
				textColor: ColorUtil.gray(79),
				textSizePixels: 18,
				backgroundColor: 0xffffff,
				borderColor: Assets.COLOR_RED_SELECTION,
				borderThickness: 5,
				borderAlpha: 0,
				showBorder: true,
				maxChars: 18,
				width: 530,
				height: 141,
				x: 30,
				y: 361,
				paddingLeft: 42,
				paddingRight: 42,
				alignmentY: 0.5,
				input: true
			});
			
			addChild(nameField);

			opinionField = new BlockText({
				text: "",
				textFont: Assets.FONT_BOLD,				
				textColor: ColorUtil.gray(79),
				textSizePixels: 18,
				backgroundColor: 0xffffff,
				borderColor: Assets.COLOR_RED_SELECTION,
				borderThickness: 5,
				borderAlpha: 0,
				showBorder: true,
				maxChars: 140,
				width: 962,
				height: 213,
				x: 30,
				y: 565,
				paddingLeft: 42,
				paddingRight: 42,
				paddingTop: 42,
				input: true			
			});
			
			addChild(opinionField);
			
			nameField.onInput.push(onNameFieldInput);
			nameField.onFocus.push(onFieldFocus);
			nameField.onBlur.push(onFieldBlur);
			opinionField.onFocus.push(onFieldFocus);
			opinionField.onBlur.push(onFieldBlur);			
			
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		private function onNameFieldInput(e:Event):void {
			// update the character countdown
			trace("Name field input!");
			trace("Max: " + nameField.maxChars);
			nameCharacterCount.text = nameField.charsLeft + StringUtil.plural(" Char", nameField.charsLeft);
		}
		
		private function onFieldFocus(e:FocusEvent):void {
			TweenMax.to(e.target.parent.parent, 0, {borderAlpha: 1});
		}
		
		private function onFieldBlur(e:FocusEvent):void {
			TweenMax.to(e.target.parent.parent, 0.5, {borderAlpha: 0});
		}		
		
		private function onDataUpdate(e:Event):void {
			question.text = CivilDebateWall.data.question.text;
		}
				
	}
}