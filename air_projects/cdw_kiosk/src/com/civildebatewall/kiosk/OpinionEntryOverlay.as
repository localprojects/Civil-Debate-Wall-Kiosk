package com.civildebatewall.kiosk {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Shape;
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
				width: 1022,
				height: 188
			});

			addChild(question);
			
			var formUnderlay:Shape = GraphicsUtil.shapeFromSize(1022, 929, ColorUtil.gray(211));
			formUnderlay.y = question.bottom;
			addChild(formUnderlay);
			
			var nameLabel:BlockText = new BlockText({
				text: "WHAT IS YOUR NAME?",
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textColor: ColorUtil.gray(79),
				textSizePixels: 16,
				letterSpacing: -1,
				x: 72, 
				y: 322
			});
			
			addChild(nameLabel);
			
			
			
			
			
			
			

			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		private function onDataUpdate(e:Event):void {
			question.text = CivilDebateWall.data.question.text;
		}
				
	}
}