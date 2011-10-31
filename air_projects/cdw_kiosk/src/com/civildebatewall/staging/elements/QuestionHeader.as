package com.civildebatewall.staging.elements {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.kiosk.Kiosk;
	import com.civildebatewall.staging.futilProxies.BlockBaseTweenable;
	import com.civildebatewall.staging.futilProxies.BlockTextTweenable;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.engine.TextBlock;
	
	//ChangeWatcher.watch(this, "firstName", propertyChangeHandler);	
	
	public class QuestionHeader extends BlockBaseTweenable	{
		
		// Listen to state changes
		private var questionText:BlockText;

		public function QuestionHeader() {
			
			super({
				backgroundColor: 0xffffff,
				backgroundAlpha: 0.85,
				width: 1080,
				height: 312
			});
			
			questionText = new BlockText({
				text: 'Waiting for question from server',
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSizePixels: 39,
				leading: 30,
			  textColor: 0x000000,
			  backgroundColor: 0xffffff,
				backgroundAlpha: 0,
			  growthMode: BlockText.MAXIMIZE_HEIGHT,
				registrationPoint: Alignment.CENTER,
				minWidth: 100,
				maxWidth: 982,
				height: 211
			});
			questionText.y = (312 / 2) + (questionText.leading / 2);
			questionText.x = 1080 / 2;
			addChild(questionText);

			// Lines
			var topLine:Shape = new Shape();
			topLine.graphics.beginFill(Assets.COLOR_YES_LIGHT);
			topLine.graphics.drawRect(0, 0, 982, 5);
			topLine.graphics.endFill();
			topLine.x = 49;
			topLine.y = 30;
			addChild(topLine);
			
			var bottomLine:Shape = new Shape();
			bottomLine.graphics.beginFill(Assets.COLOR_NO_LIGHT);
			bottomLine.graphics.drawRect(0, 0, 982, 5);
			bottomLine.graphics.endFill();
			bottomLine.x = 49;
			bottomLine.y = 277;
			addChild(bottomLine);			
			
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataChange);
		}

		protected function onDataChange(e:Event):void {
			questionText.text = CivilDebateWall.data.question.text;
		}
		
	}
}