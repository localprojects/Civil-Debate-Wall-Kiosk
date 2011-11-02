package com.civildebatewall.kiosk {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.Event;

	public class OpinionEntryOverlay extends BlockInertialScroll {
		
		private var question:BlockText;
		
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
				backgroundAlpha: 0.85,
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
				width: 1023
			});

			addChild(question);
		
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		private function onDataUpdate(e:Event):void {
			question.text = CivilDebateWall.data.question.text;
		}
		
		
		
		
		
	}
}