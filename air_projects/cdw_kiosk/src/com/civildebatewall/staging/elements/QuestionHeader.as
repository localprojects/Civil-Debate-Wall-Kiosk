package com.civildebatewall.staging.elements {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Data;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.blocks.Padding;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	
	import flash.display.Shape;
	import flash.events.Event;
	

	public class QuestionHeader extends BlockText	{
		
		// Listen to state changes
		private var questionText:BlockText;

		public var showLines:Boolean;
		
		public var topLine:Shape;
		public var bottomLine:Shape;

		public function QuestionHeader(params:Object = null) {
			super({
				paddingTop: 65,
				paddingRight: 100,
				paddingBottom: 65,
				paddingLeft: 100,
				backgroundColor: 0xffffff,
				backgroundAlpha: 0.85,
				text: 'Waiting for question from server',
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textColor: 0x000000,
				showLines: true,
				alignmentPoint: Alignment.CENTER
			});
			
			setParams(params);

			// Lines
			if (showLines) {
				topLine = new Shape();
				topLine.graphics.beginFill(Assets.COLOR_YES_LIGHT);
				topLine.graphics.drawRect(0, 0, 1080, 5);
				topLine.graphics.endFill();
				topLine.x = 49;
				topLine.y = 30;
				background.addChild(topLine); // in the background so it doesn't affect alignment
	
				bottomLine = new Shape();
				bottomLine.graphics.beginFill(Assets.COLOR_NO_LIGHT);
				bottomLine.graphics.drawRect(0, 0, 1080, 5);
				bottomLine.graphics.endFill();
				bottomLine.x = 49;
				bottomLine.y = 277;
				background.addChild(bottomLine);
			}

			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataChange);
			CivilDebateWall.state.addEventListener(State.VIEW_CHANGE, onViewChange);
		}
		
		override public function update(contentWidth:Number = -1, contentHeight:Number = -1):void {
			if (!lockUpdates) {
				super.update(contentWidth, contentHeight); // TODO pass bounds vector instead?
				
				if (showLines && (topLine != null) && (bottomLine != null)) {
					topLine.y = height * .1;
					bottomLine.y = height - (height * .1);
					topLine.width = background.width * 0.9092592593;
					bottomLine.width = background.width * 0.9092592593;
				}
			}
		}

		private function onDataChange(e:Event):void {
			text = CivilDebateWall.data.question.text;
		}
		
		private function onViewChange(e:Event):void {
			// do it this way?
		}		
		
	}
}