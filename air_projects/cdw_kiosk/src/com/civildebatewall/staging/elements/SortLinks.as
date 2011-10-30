package com.civildebatewall.staging.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CDW;
	import com.civildebatewall.staging.futilProxies.BlockBaseTweenable;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SortLinks extends BlockBaseTweenable	{
		
		private var sortedText:Bitmap;
		private var recentText:SortLink;
		private var dividerA:BlockText;		
		private var yesText:SortLink;
		private var dividerB:BlockText;
		private var noText:SortLink;		
		private var dividerC:BlockText;
		private var mostDebatedText:SortLink;
		
		
		private var selectedLink:SortLink;		
		
		public function SortLinks(params:Object=null) {
			super({
				backgroundColor: Assets.COLOR_GRAY_5,
				width: 1080,
				height: 78
			});
			
			sortedText = Assets.getSortedByText();
			
			recentText = new SortLink({
				text: "Recent"				
			});
			
			dividerA = new BlockText({
				textFont: Assets.FONT_REGULAR,
				backgroundColor: Assets.COLOR_GRAY_5,
				textColor: Assets.COLOR_GRAY_25,
				textSizePixels: 14,
				text: "/"				
			});
			
			yesText = new SortLink({
				text: "Yes"
			});
			
			dividerB = new BlockText({
				textFont: Assets.FONT_REGULAR,
				backgroundColor: Assets.COLOR_GRAY_5,
				textColor: Assets.COLOR_GRAY_25,
				textSizePixels: 14,
				text: "/"				
			});			
			
			noText = new SortLink({
				text: "No"				
			});
			
			dividerC = new BlockText({
				textFont: Assets.FONT_REGULAR,
				backgroundColor: Assets.COLOR_GRAY_5,
				textColor: Assets.COLOR_GRAY_25,
				textSizePixels: 14,
				text: "/"				
			});			
			
			mostDebatedText = new SortLink({
				text: "Most Debated"				
			});
			

			var xOffset:Number = 321;
			var yOffset:Number = 32;
			var spacing:Number = 5;
			
			sortedText.x = xOffset;
			sortedText.y = yOffset;
			
			addChild(sortedText);
			
			recentText.x = sortedText.x + sortedText.width + (spacing * 2);
			recentText.y = yOffset;
			
			addChild(recentText);
			
			dividerA.x = recentText.x + recentText.width + spacing;
			dividerA.y = yOffset;
			
			addChild(dividerA);
			
			yesText.x = dividerA.x + dividerA.width + spacing;
			yesText.y = yOffset;
			
			addChild(yesText);
			
			dividerB.x = yesText.x + yesText.width + spacing;
			dividerB.y = yOffset;
			
			addChild(dividerB);
			
			noText.x = dividerB.x + dividerB.width + spacing;
			noText.y = yOffset;
			
			addChild(noText);
			
			dividerC.x = noText.x + noText.width + spacing;
			dividerC.y = yOffset;
			
			addChild(dividerC);	
			
			mostDebatedText.x = dividerC.x + dividerC.width + spacing;
			mostDebatedText.y = yOffset;
			
			addChild(mostDebatedText);

			recentText.drawMouseDown();
			selectedLink = recentText;
			
			
			// Events, TODO drop these into block
			recentText.setOnDown(onMouseDownLink);
			yesText.setOnDown(onMouseDownLink);
			noText.setOnDown(onMouseDownLink);
			mostDebatedText.setOnDown(onMouseDownLink);
		
			recentText.setOnClick(onMouseUpLink);
			yesText.setOnClick(onMouseUpLink);
			noText.setOnClick(onMouseUpLink);
			mostDebatedText.setOnClick(onMouseUpLink);			
		}
		
		private var clickedLink:SortLink;
		
		
		private function onMouseDownLink(e:MouseEvent):void {
			clickedLink = e.currentTarget as SortLink;
			clickedLink.drawMouseDown();
		}
		
		private function onMouseUpLink(e:MouseEvent):void {
			if (selectedLink != clickedLink) {
				selectedLink.drawMouseUp();
				clickedLink.drawMouseDown();
				selectedLink = clickedLink;
				}
		}
		
	}
}