/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall {

	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;	
	
	public final class Assets	{
		
		// Embed code is generated dynamically by embedgen.py

		// Vector TODO issues with long reloading process everyt time get method is called?
		[Embed(source = "/assets/graphics/noBubble.swf")] private static const noBubbleClass:Class;
		public static function getNoBubble():Sprite { return new noBubbleClass() as Sprite; };
		public static const noBubble:Sprite = getNoBubble();
		
		[Embed(source = "/assets/graphics/yesBubble.swf")] private static const yesBubbleClass:Class;
		public static function getYesBubble():Sprite { return new yesBubbleClass() as Sprite; };
		public static const yesBubble:Sprite = getYesBubble();
				
		[Embed(source = "/assets/graphics/yesPhone.swf")] private static const yesPhoneClass:Class;
		public static function getYesPhone():Sprite { return new yesPhoneClass() as Sprite; };
		public static const yesPhone:Sprite = getYesPhone();
		
		[Embed(source = "/assets/graphics/noPhone.swf")] private static const noPhoneClass:Class;
		public static function getNoPhone():Sprite { return new noPhoneClass() as Sprite; };
		public static const noPhone:Sprite = getNoPhone();

		[Embed(source = "/assets/graphics/noSuccessBubble.swf")] private static const noSuccessBubbleClass:Class;
		public static function getNoSuccessBubble():Sprite { return new noSuccessBubbleClass() as Sprite; };
		public static const noSuccessBubble:Sprite = getNoSuccessBubble();
		
		[Embed(source = "/assets/graphics/yesSuccessBubble.swf")] private static const yesSuccessBubbleClass:Class;
		public static function getYesSuccessBubble():Sprite { return new yesSuccessBubbleClass() as Sprite; };
		public static const yesSuccessBubble:Sprite = getYesSuccessBubble();
		
		[Embed(source = "/assets/graphics/noStopBubble.swf")] private static const noStopBubbleClass:Class;
		public static function getNoStopBubble():Sprite { return new noStopBubbleClass() as Sprite; };
		public static const noStopBubble:Sprite = getNoStopBubble();
		
		[Embed(source = "/assets/graphics/yesStopBubble.swf")] private static const yesStopBubbleClass:Class;
		public static function getYesStopBubble():Sprite { return new yesStopBubbleClass() as Sprite; };
		public static const yesStopBubble:Sprite = getYesStopBubble();
		
		[Embed(source = "/assets/graphics/yesFollowingBubble.swf")] private static const yesFollowingBubbleClass:Class;
		public static function getYesFollowingBubble():Sprite { return new yesFollowingBubbleClass() as Sprite; };
		public static const yesFollowingBubble:Sprite = getYesFollowingBubble();
		
		[Embed(source = "/assets/graphics/noFollowingBubble.swf")] private static const noFollowingBubbleClass:Class;
		public static function getNoFollowingBubble():Sprite { return new noFollowingBubbleClass() as Sprite; };
		public static const noFollowingBubble:Sprite = getNoFollowingBubble();
		
		[Embed(source = "/assets/graphics/heart.swf")] private static const heartClass:Class;
		public static function getHeart():Sprite { return new heartClass() as Sprite; };
		public static const heart:Sprite = getHeart();
		
		[Embed(source = "/assets/graphics/flag.swf")] private static const flagClass:Class;
		public static function getFlag():Sprite { return new flagClass() as Sprite; };
		public static const flag:Sprite = getFlag();

		
		// Bitmaps
		[Embed(source = "/assets/graphics/clearIcon.png")] private static const clearIconClass:Class;
		public static function getClearIcon():Bitmap { return new clearIconClass() as Bitmap; };
		public static const clearIcon:Bitmap = getClearIcon();
		
		[Embed(source = "/assets/graphics/barGraphNoLabel.png")] private static const barGraphNoLabelClass:Class;
		public static function getBarGraphNoLabel():Bitmap { return new barGraphNoLabelClass() as Bitmap; };
		public static const barGraphNoLabel:Bitmap = getBarGraphNoLabel();
		
		[Embed(source = "/assets/graphics/barGraphYesLabel.png")] private static const barGraphYesLabelClass:Class;
		public static function getBarGraphYesLabel():Bitmap { return new barGraphYesLabelClass() as Bitmap; };
		public static const barGraphYesLabel:Bitmap = getBarGraphYesLabel();		
		
		[Embed(source = "/assets/graphics/goToDebateText.png")] private static const goToDebateTextClass:Class;
		public static function getGoToDebateText():Bitmap { return new goToDebateTextClass() as Bitmap; };
		public static const goToDebateText:Bitmap = getGoToDebateText();
		
		[Embed(source = "/assets/graphics/bigSubmit.png")] private static const bigSubmitClass:Class;
		public static function getBigSubmit():Bitmap { return new bigSubmitClass() as Bitmap; };
		public static const bigSubmit:Bitmap = getBigSubmit();
		
		[Embed(source = "/assets/graphics/thumbnailStanceTextYes.png")] private static const thumbnailStanceTextYesClass:Class;
		public static function getThumbnailStanceTextYes():Bitmap { return new thumbnailStanceTextYesClass() as Bitmap; };
		public static const thumbnailStanceTextYes:Bitmap = getThumbnailStanceTextYes();
		
		[Embed(source = "/assets/graphics/thumbnailStanceTextNo.png")] private static const thumbnailStanceTextNoClass:Class;
		public static function getThumbnailStanceTextNo():Bitmap { return new thumbnailStanceTextNoClass() as Bitmap; };
		public static const thumbnailStanceTextNo:Bitmap = getThumbnailStanceTextNo();
		
		[Embed(source = "/assets/graphics/lowerMenuCarat.png")] private static const lowerMenuCaratClass:Class;
		public static function getLowerMenuCarat():Bitmap { return new lowerMenuCaratClass() as Bitmap; };
		public static const lowerMenuCarat:Bitmap = getLowerMenuCarat();
		
		[Embed(source = "/assets/graphics/leftCaratWhite.png")] private static const leftCaratWhiteClass:Class;
		public static function getLeftCaratWhite():Bitmap { return new leftCaratWhiteClass() as Bitmap; };
		public static const leftCaratWhite:Bitmap = getLeftCaratWhite();
		
		[Embed(source = "/assets/graphics/rightCaratWhite.png")] private static const rightCaratWhiteClass:Class;
		public static function getRightCaratWhite():Bitmap { return new rightCaratWhiteClass() as Bitmap; };
		public static const rightCaratWhite:Bitmap = getRightCaratWhite();
		
		[Embed(source = "/assets/graphics/bigYes.png")] private static const bigYesClass:Class;
		public static function getBigYes():Bitmap { return new bigYesClass() as Bitmap; };
		public static const bigYes:Bitmap = getBigYes();
		
		[Embed(source = "/assets/graphics/bigNo.png")] private static const bigNoClass:Class;
		public static function getBigNo():Bitmap { return new bigNoClass() as Bitmap; };
		public static const bigNo:Bitmap = getBigNo();

		[Embed(source = "/assets/graphics/smsSubscribeHeader.png")] private static const smsSubscribeHeaderClass:Class;
		public static function getSmsSubscribeHeader():Bitmap { return new smsSubscribeHeaderClass() as Bitmap; };
		public static const smsSubscribeHeader:Bitmap = getSmsSubscribeHeader();
		
		[Embed(source = "/assets/graphics/smsPhoneLabel.png")] private static const smsPhoneLabelClass:Class;
		public static function getSmsPhoneLabel():Bitmap { return new smsPhoneLabelClass() as Bitmap; };
		public static const smsPhoneLabel:Bitmap = getSmsPhoneLabel();
		
		[Embed(source = "/assets/graphics/progressGradient.png")] private static const progressGradientClass:Class;
		public static function getProgressGradient():Bitmap { return new progressGradientClass() as Bitmap; };
		public static const progressGradient:Bitmap = getProgressGradient();
		
		[Embed(source = "/assets/graphics/smsSuccessText.png")] private static const smsSuccessTextClass:Class;
		public static function getSmsSuccessText():Bitmap { return new smsSuccessTextClass() as Bitmap; };
		public static const smsSuccessText:Bitmap = getSmsSuccessText();
		
		[Embed(source = "/assets/graphics/smsSuccessNote.png")] private static const smsSuccessNoteClass:Class;
		public static function getSmsSuccessNote():Bitmap { return new smsSuccessNoteClass() as Bitmap; };
		public static const smsSuccessNote:Bitmap = getSmsSuccessNote();
		
		[Embed(source = "/assets/graphics/termsAndConditions.png")] private static const termsAndConditionsClass:Class;
		public static function getTermsAndConditions():Bitmap { return new termsAndConditionsClass() as Bitmap; };
		public static const termsAndConditions:Bitmap = getTermsAndConditions();		
		
		[Embed(source = "/assets/graphics/photoPrompt.png")] private static const photoPromptClass:Class;
		public static function getPhotoPrompt():Bitmap { return new photoPromptClass() as Bitmap; };
		public static const photoPrompt:Bitmap = getPhotoPrompt();
		
		[Embed(source = "/assets/graphics/cameraArrowSmall.png")] private static const cameraArrowSmallClass:Class;
		public static function getCameraArrowSmall():Bitmap { return new cameraArrowSmallClass() as Bitmap; };
		public static const cameraArrowSmall:Bitmap = getCameraArrowSmall();
		
		[Embed(source = "/assets/graphics/everythingOkText.png")] private static const everythingOkTextClass:Class;
		public static function getEverythingOkText():Bitmap { return new everythingOkTextClass() as Bitmap; };
		public static const everythingOkText:Bitmap = getEverythingOkText();

		[Embed(source = "/assets/graphics/orText.png")] private static const orTextClass:Class;
		public static function getOrText():Bitmap { return new orTextClass() as Bitmap; };
		public static const orText:Bitmap = getOrText();
		
		[Embed(source = "/assets/graphics/yesButtonLabelText.png")] private static const yesButtonLabelTextClass:Class;
		public static function getYesButtonLabelText():Bitmap { return new yesButtonLabelTextClass() as Bitmap; };
		public static const yesButtonLabelText:Bitmap = getYesButtonLabelText();
		
		[Embed(source = "/assets/graphics/noButtonLabelText.png")] private static const noButtonLabelTextClass:Class;
		public static function getNoButtonLabelText():Bitmap { return new noButtonLabelTextClass() as Bitmap; };
		public static const noButtonLabelText:Bitmap = getNoButtonLabelText();
		
		[Embed(source = "/assets/graphics/dragHandle.png")] private static const dragHandleClass:Class;
		public static function getDragHandle():Bitmap { return new dragHandleClass() as Bitmap; };
		public static const dragHandle:Bitmap = getDragHandle();		
		
		[Embed(source = "/assets/graphics/portraitBannerYes.png")] private static const portraitBannerYesClass:Class;
		public static function getPortraitBannerYes():Bitmap { return new portraitBannerYesClass() as Bitmap; };
		public static const portraitBannerYes:Bitmap = getPortraitBannerYes();
		
		[Embed(source = "/assets/graphics/portraitBannerNo.png")] private static const portraitBannerNoClass:Class;
		public static function getPortraitBannerNo():Bitmap { return new portraitBannerNoClass() as Bitmap; };
		public static const portraitBannerNo:Bitmap = getPortraitBannerNo();

		[Embed(source = "/assets/graphics/saysText.png")] private static const saysTextClass:Class;
		public static function getSaysText():Bitmap { return new saysTextClass() as Bitmap; };
		public static const saysText:Bitmap = getSaysText();		
		
		[Embed(source = "/assets/graphics/statsButtonCenter.png")] private static const statsButtonCenterClass:Class;
		public static function getStatsButtonCenter():Bitmap { return new statsButtonCenterClass() as Bitmap; };
		public static const statsButtonCenter:Bitmap = getStatsButtonCenter();
		
		[Embed(source = "/assets/graphics/balloonButtonBackground.png")] private static const balloonButtonBackgroundClass:Class;
		public static function getBalloonButtonBackground():Bitmap { return new balloonButtonBackgroundClass() as Bitmap; };
		public static const balloonButtonBackground:Bitmap = getBalloonButtonBackground();
		
		[Embed(source = "/assets/graphics/balloonButtonText.png")] private static const balloonButtonTextClass:Class;
		public static function getBalloonButtonText():Bitmap { return new balloonButtonTextClass() as Bitmap; };
		public static const balloonButtonText:Bitmap = getBalloonButtonText();		
		
		[Embed(source = "/assets/graphics/sortedByText.png")] private static const sortedByTextClass:Class;
		public static function getSortedByText():Bitmap { return new sortedByTextClass() as Bitmap; };
		public static const sortedByText:Bitmap = getSortedByText();
		
		[Embed(source = "/assets/graphics/leftCarat.png")] private static const leftCaratClass:Class;
		public static function getLeftCarat():Bitmap { return new leftCaratClass() as Bitmap; };
		public static const leftCarat:Bitmap = getLeftCarat();
		
		[Embed(source = "/assets/graphics/rightCarat.png")] private static const rightCaratClass:Class;
		public static function getRightCarat():Bitmap { return new rightCaratClass() as Bitmap; };
		public static const rightCarat:Bitmap = getRightCarat();
		
		[Embed(source = "/assets/graphics/leftCaratBig.png")] private static const leftCaratBigClass:Class;
		public static function getLeftCaratBig():Bitmap { return new leftCaratBigClass() as Bitmap; };
		public static const leftCaratBig:Bitmap = getLeftCaratBig();
				
		[Embed(source = "/assets/graphics/rightCaratBig.png")] private static const rightCaratBigClass:Class;
		public static function getRightCaratBig():Bitmap { return new rightCaratBigClass() as Bitmap; };
		public static const rightCaratBig:Bitmap = getRightCaratBig();
		
		[Embed(source = "/assets/graphics/closeButton.png")] private static const closeButtonClass:Class;
		public static function getCloseButton():Bitmap { return new closeButtonClass() as Bitmap; };
		public static const closeButton:Bitmap = getCloseButton();				
		
		[Embed(source = "/assets/graphics/wordCloudGradient.png")] private static const wordCloudGradientClass:Class;
		public static function getWordCloudGradient():Bitmap { return new wordCloudGradientClass() as Bitmap; };
		public static const wordCloudGradient:Bitmap = getWordCloudGradient();				
		
		[Embed(source = "/assets/graphics/leftArrow.png")] private static const leftArrowClass:Class;
		public static function getLeftArrow():Bitmap { return new leftArrowClass() as Bitmap; };
		public static const leftArrow:Bitmap = getLeftArrow();
		
		[Embed(source = "/assets/graphics/rightArrow.png")] private static const rightArrowClass:Class;
		public static function getRightArrow():Bitmap { return new rightArrowClass() as Bitmap; };
		public static const rightArrow:Bitmap = getRightArrow();
		
		[Embed(source = "/assets/graphics/bottomButtonTile.png")] private static const bottomButtonTileClass:Class;
		public static function getBottomButtonTile():Bitmap { return new bottomButtonTileClass() as Bitmap; };
		public static const bottomButtonTile:Bitmap = getBottomButtonTile();
		
		[Embed(source = "/assets/graphics/bottomEdgeMask.png")] private static const bottomEdgeMaskClass:Class;
		public static function getBottomEdgeMask():Bitmap { return new bottomEdgeMaskClass() as Bitmap; };
		public static const bottomEdgeMask:Bitmap = getBottomEdgeMask();
		
		[Embed(source = "/assets/graphics/buttonBackground.png")] private static const buttonBackgroundClass:Class;
		public static function getButtonBackground():Bitmap { return new buttonBackgroundClass() as Bitmap; };
		public static const buttonBackground:Bitmap = getButtonBackground();
		
		[Embed(source = "/assets/graphics/leftButtonTile.png")] private static const leftButtonTileClass:Class;
		public static function getLeftButtonTile():Bitmap { return new leftButtonTileClass() as Bitmap; };
		public static const leftButtonTile:Bitmap = getLeftButtonTile();
		
		[Embed(source = "/assets/graphics/leftEdgeMask.png")] private static const leftEdgeMaskClass:Class;
		public static function getLeftEdgeMask():Bitmap { return new leftEdgeMaskClass() as Bitmap; };
		public static const leftEdgeMask:Bitmap = getLeftEdgeMask();		
		
		[Embed(source = "/assets/graphics/portraitPlaceholder.png")] private static const portraitPlaceholderClass:Class;
		public static function getPortraitPlaceholder():Bitmap { return new portraitPlaceholderClass() as Bitmap; };
		public static const portraitPlaceholder:Bitmap = getPortraitPlaceholder();
		
		[Embed(source = '/assets/graphics/areYouStillThereText.png')] private static const areYouStillThereTextClass:Class;
		public static function getAreYouStillThereText():Bitmap { return new areYouStillThereTextClass() as Bitmap; };
		public static const areYouStillThereText:Bitmap = getAreYouStillThereText();

		// TODO get rid of this?
		[Embed(source = "/assets/graphics/bubblePerimeter.png")] private static const bubblePerimeterClass:Class;
		public static function getBubblePerimeter():Bitmap { return new bubblePerimeterClass() as Bitmap; };
		public static const bubblePerimeter:Bitmap = getBubblePerimeter();
		
		[Embed(source = "/assets/graphics/bubbleBackground.png")] private static const bubbleBackgroundClass:Class;
		public static function getBubbleBackground():Bitmap { return new bubbleBackgroundClass() as Bitmap; };
		public static const bubbleBackground:Bitmap = getBubbleBackground();
		
		[Embed(source = "/assets/graphics/circleBackground.png")] private static const circleBackgroundClass:Class;
		public static function getCircleBackground():Bitmap { return new circleBackgroundClass() as Bitmap; };
		public static const circleBackground:Bitmap = getCircleBackground();
		
		[Embed(source = "/assets/graphics/circlePerimeter.png")] private static const circlePerimeterClass:Class;
		public static function getCirclePerimeter():Bitmap { return new circlePerimeterClass() as Bitmap; };
		public static const circlePerimeter:Bitmap = getCirclePerimeter();

		
		// Generators
		public static function getStatsUnderlay():Bitmap { return new Bitmap(new BitmapData(1080, 1920, false, 0xffffff)); };
		public static const statsUnderlay:Bitmap = getStatsUnderlay();
		
		// Wallsaver
		// New Title Sequence
		[Embed(source = "/assets/graphics/titleChevron.png")] private static const titleChevronClass:Class;
		public static function getTitleChevron():Bitmap { return new titleChevronClass() as Bitmap; };
		public static const titleChevron:Bitmap = getTitleChevron();
		
		[Embed(source = "/assets/graphics/wallText.png")] private static const wallTextClass:Class;
		public static function getWallText():Bitmap { return new wallTextClass() as Bitmap; };
		public static const wallText:Bitmap = getWallText();
		
		[Embed(source = "/assets/graphics/theText.png")] private static const theTextClass:Class;
		public static function getTheText():Bitmap { return new theTextClass() as Bitmap; };
		public static const theText:Bitmap = getTheText();
		
		[Embed(source = "/assets/graphics/taglineText.png")] private static const taglineTextClass:Class;
		public static function getTaglineText():Bitmap { return new taglineTextClass() as Bitmap; };
		public static const taglineText:Bitmap = getTaglineText();
		
		
		// Quotation Marks
		[Embed(source = "/assets/graphics/quoteNoClose.png")] private static const quoteNoCloseClass:Class;
		public static function getQuoteNoClose():Bitmap { return new quoteNoCloseClass() as Bitmap; };
		public static const quoteNoClose:Bitmap = getQuoteNoClose();
		
		[Embed(source = "/assets/graphics/quoteYesClose.png")] private static const quoteYesCloseClass:Class;
		public static function getQuoteYesClose():Bitmap { return new quoteYesCloseClass() as Bitmap; };
		public static const quoteYesClose:Bitmap = getQuoteYesClose();
		
		[Embed(source = "/assets/graphics/quoteYesOpen.png")] private static const quoteYesOpenClass:Class;
		public static function getQuoteYesOpen():Bitmap { return new quoteYesOpenClass() as Bitmap; };
		public static const quoteYesOpen:Bitmap = getQuoteYesOpen();
		
		[Embed(source = "/assets/graphics/quoteNoOpen.png")] private static const quoteNoOpenClass:Class;
		public static function getQuoteNoOpen():Bitmap { return new quoteNoOpenClass() as Bitmap; };
		public static const quoteNoOpen:Bitmap = getQuoteNoOpen();
		
		
		// Calls To Action
		[Embed(source = "/assets/graphics/touchToBeginText.png")] private static const touchToBeginTextClass:Class;
		public static function getTouchToBeginText():Bitmap { return new touchToBeginTextClass() as Bitmap; };
		public static const touchToBeginText:Bitmap = getTouchToBeginText();
		
		[Embed(source = "/assets/graphics/joinTheDebateText.png")] private static const joinTheDebateTextClass:Class;
		public static function getJoinTheDebateText():Bitmap { return new joinTheDebateTextClass() as Bitmap; };
		public static const joinTheDebateText:Bitmap = getJoinTheDebateText();
		
		// Graph Labels
		[Embed(source = "/assets/graphics/graphLabelNo.png")] private static const graphLabelNoClass:Class;
		public static function getGraphLabelNo():Bitmap { return new graphLabelNoClass() as Bitmap; };
		public static const graphLabelNo:Bitmap = getGraphLabelNo();
		
		[Embed(source = "/assets/graphics/graphLabelYes.png")] private static const graphLabelYesClass:Class;
		public static function getGraphLabelYes():Bitmap { return new graphLabelYesClass() as Bitmap; };
		public static const graphLabelYes:Bitmap = getGraphLabelYes();
		
		
		// Sample Screens
		[Embed(source = "/assets/graphics/sampleScreen1.jpg")] private static const sampleScreen1Class:Class;
		public static function getsampleScreen1():Bitmap { return new sampleScreen1Class() as Bitmap; };
		public static const sampleScreen1:Bitmap = getsampleScreen1();
	
		[Embed(source = "/assets/graphics/sampleScreen2.jpg")] private static const sampleScreen2Class:Class;
		public static function getsampleScreen2():Bitmap { return new sampleScreen2Class() as Bitmap; };
		public static const sampleScreen2:Bitmap = getsampleScreen2();		
		
		
		[Embed(source = "/assets/graphics/sampleScreen3.jpg")] private static const sampleScreen3Class:Class;
		public static function getsampleScreen3():Bitmap { return new sampleScreen3Class() as Bitmap; };
		public static const sampleScreen3:Bitmap = getsampleScreen3();
		
		[Embed(source = "/assets/graphics/sampleScreen4.jpg")] private static const sampleScreen4Class:Class;
		public static function getsampleScreen4():Bitmap { return new sampleScreen4Class() as Bitmap; };
		public static const sampleScreen4:Bitmap = getsampleScreen4();		
		
		[Embed(source = "/assets/graphics/sampleScreen5.jpg")] private static const sampleScreen5Class:Class;
		public static function getsampleScreen5():Bitmap { return new sampleScreen5Class() as Bitmap; };
		public static const sampleScreen5:Bitmap = getsampleScreen5();				
		

		// Fonts
		[Embed(source="/assets/fonts/fonts.swf", symbol="RockwellLight")] public static const FontLight:Class;
		public static const FONT_LIGHT:String = "Rockwell Std Light";		
		
		[Embed(source="/assets/fonts/fonts.swf", symbol="RockwellRegular")] public static const FontRegular:Class;
		public static const FONT_REGULAR:String = "Rockwell Std";
		
		[Embed(source="/assets/fonts/fonts.swf", symbol="RockwellBold")] public static const FontBold:Class;
		public static const FONT_BOLD:String = "Rockwell Std"; // Gets bolded through textfield		
		
		[Embed(source="/assets/fonts/fonts.swf", symbol="RockwellExtraBold")] public static const FontHeavy:Class;		
		public static const FONT_HEAVY:String = "Rockwell Std Extra Bold";		
		
		[Embed(source="/assets/fonts/fonts.swf", symbol="RockwellLightItalic")] public static const FontLightItalic:Class;
		public static const FONT_LIGHT_ITALIC:String = "Rockwell Std"; // gets italicized in textfield?	
		
		[Embed(source="/assets/fonts/fonts.swf", symbol="RockwellItalic")] public static const FontRegularItalic:Class;
		public static const FONT_REGULAR_ITALIC:String = "Rockwell Std Italic";
		
		[Embed(source="/assets/fonts/fonts.swf", symbol="RockwellBoldItalic")] public static const FontBoldItalic:Class;
		public static const FONT_BOLD_ITALIC:String = "Rockwell Std"; // gets bolded and italicized in textfield?		

		
		// Colors
		public static const COLOR_RED_SELECTION:uint = ColorUtil.rgb(255, 26, 23);
		
		public static const COLOR_YES_EXTRA_LIGHT:uint = ColorUtil.rgb(185, 229, 250); //Utilities.color(109, 207, 246);
		public static const COLOR_YES_LIGHT:uint = ColorUtil.rgb(0, 185, 255);
		public static const COLOR_YES_MEDIUM:uint = ColorUtil.rgb(0, 155, 255);
		public static const COLOR_YES_DARK:uint = ColorUtil.rgb(0, 115, 255);
		public static const COLOR_YES_OVERLAY:uint = ColorUtil.rgb(53, 124, 146);
		public static const COLOR_YES_WATERMARK:uint = ColorUtil.rgb(239, 249, 254);
		public static const COLOR_YES_DISABLED:uint = ColorUtil.rgb(34, 63, 110); 
		public static const COLOR_YES_HIGHLIGHT:uint = COLOR_YES_DISABLED; // TBD		
	
		public static const COLOR_NO_EXTRA_LIGHT:uint = ColorUtil.rgb(251, 200, 180); //Utilities.color(247, 150, 121);
		public static const COLOR_NO_LIGHT:uint = ColorUtil.rgb(255, 90, 0); // TODO medium and light are identical in the design template!
		public static const COLOR_NO_MEDIUM:uint = ColorUtil.rgb(255, 75, 0); // TODO medium and light are identical in the designtemplate!
		public static const COLOR_NO_DARK:uint = ColorUtil.rgb(255, 60, 0);
		public static const COLOR_NO_OVERLAY:uint = ColorUtil.rgb(255, 60, 0);
		public static const COLOR_NO_WATERMARK:uint = ColorUtil.rgb(255, 242, 235);
		public static const COLOR_NO_DISABLED:uint = ColorUtil.rgb(140, 41, 4);		
		public static const COLOR_NO_HIGHLIGHT:uint = COLOR_NO_DISABLED; // TBD		

		public static const COLOR_GRAY_2:uint = ColorUtil.rgb(248, 248, 248); // ?% K
		public static const COLOR_GRAY_5:uint = ColorUtil.rgb(241, 242, 242); // 5% K
		public static const COLOR_GRAY_15:uint = ColorUtil.rgb(220, 221, 222); // 15% K		
		public static const COLOR_GRAY_20:uint = ColorUtil.rgb(230, 231, 232); // 20% K
		public static const COLOR_GRAY_25:uint = ColorUtil.rgb(199, 200, 202); // 25% K
		public static const COLOR_GRAY_50:uint = ColorUtil.rgb(147, 149, 152); // 50% K
		public static const COLOR_GRAY_75:uint = ColorUtil.rgb(99, 100, 102); // 75% K
		public static const COLOR_GRAY_85:uint = ColorUtil.rgb(77, 77, 79); // 85% K
		public static const COLOR_GRAY_90:uint = ColorUtil.rgb(65, 66, 64); // 90% K		
	}
}
