package com.civildebatewall.staging.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.kiosk.Kiosk;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SortLinks extends BlockBase	{
		
		private var sortedText:Bitmap;
		private var recentText:LinkButton;
		private var dividerA:BlockText;		
		private var yesText:LinkButton;
		private var dividerB:BlockText;
		private var noText:LinkButton;		
		private var dividerC:BlockText;
		private var mostDebatedText:LinkButton;
		
		
		private var selectedLink:LinkButton;		
		
		public function SortLinks(params:Object=null) {
			super({
				backgroundColor: Assets.COLOR_GRAY_5,
				width: 1080,
				height: 78
			});
			
			sortedText = Assets.getSortedByText();
			
			recentText = new LinkButton({
				text: "Recent",
				value: State.SORT_BY_RECENT
				
			});
			
			dividerA = new BlockText({
				textFont: Assets.FONT_REGULAR,
				backgroundColor: Assets.COLOR_GRAY_5,
				textColor: Assets.COLOR_GRAY_25,
				textSize: 14,
				text: "/"				
			});
			
			yesText = new LinkButton({
				text: "Yes",
				value: State.SORT_BY_YES
			});
			
			dividerB = new BlockText({
				textFont: Assets.FONT_REGULAR,
				backgroundColor: Assets.COLOR_GRAY_5,
				textColor: Assets.COLOR_GRAY_25,
				textSize: 14,
				text: "/"				
			});			
			
			noText = new LinkButton({
				text: "No",
				value: State.SORT_BY_NO				
			});
			
			dividerC = new BlockText({
				textFont: Assets.FONT_REGULAR,
				backgroundColor: Assets.COLOR_GRAY_5,
				textColor: Assets.COLOR_GRAY_25,
				textSize: 14,
				text: "/"				
			});			
			
			mostDebatedText = new LinkButton({
				text: "Most Debated",
				value: State.SORT_BY_MOST_DEBATED				
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
			recentText.onButtonDown.push(down);
			yesText.onButtonDown.push(down);
			noText.onButtonDown.push(down);
			mostDebatedText.onButtonDown.push(down);
		
			recentText.onButtonUp.push(up);
			yesText.onButtonUp.push(up);
			noText.onButtonUp.push(up);
			mostDebatedText.onButtonUp.push(up);			
		}
		
		private var clickedLink:LinkButton;
		
		private function down(e:MouseEvent):void {
			clickedLink = e.currentTarget as LinkButton;
			clickedLink.drawMouseDown();
		}
		
		private function up(e:MouseEvent):void {
			if (selectedLink != clickedLink) {
				selectedLink.drawMouseUp();
				clickedLink.drawMouseDown();
				selectedLink = clickedLink;
				
				
				CivilDebateWall.state.setSort(selectedLink.value)
				// change the order
				
				
			}
		}
		
	}
}