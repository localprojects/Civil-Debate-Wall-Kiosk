package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.events.MouseEvent;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class BackButton extends WhiteButton	{
		public function BackButton(params:Object=null) {
			super({
				text: "BACK",
				width: 189,
				height: 64
			});
			
			onButtonUp.push(onUp);
			setParams(params);
		}

		private function onUp(e:MouseEvent):void {
			CivilDebateWall.state.setView(CivilDebateWall.state.backDestination);			
		}				
		
	}
}