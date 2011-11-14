package com.civildebatewall.kiosk.blocks
{
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Data;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	import com.kitschpatrol.futil.utilitites.NumberUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class PhoneHeader extends BlockBase {
		
		private var instructions:Bitmap;
		private var number:BlockText;
		
		public function PhoneHeader(params:Object=null)	{
			super({
				backgroundColor: 0xffffff,
				width: 880,
				height: 187
			});
			
			instructions = Assets.getSmsPhoneLabel();
			instructions.x = 30;
			instructions.y = 30;
			addChild(instructions);
			
			number = new BlockText({
				text: NumberUtil.formatPhoneNumber("5555555555"),
				textFont: Assets.FONT_BOLD,
				backgroundAlpha: 0,	
				textColor: ColorUtil.gray(77),
				textSize: 87,
				visible: true
			});
			number.x = 30;
			number.y = 67;
			addChild(number);
			
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		private function onDataUpdate(e:Event):void {
			// TODO temp off for back end
			//number.text = NumberUtil.formatPhoneNumber(CivilDebateWall.data.smsNumber);
		}
		
		
	}
}