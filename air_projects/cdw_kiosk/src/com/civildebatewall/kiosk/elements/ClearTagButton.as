package com.civildebatewall.kiosk.elements {

	import com.civildebatewall.Assets;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ClearTagButton extends BlockText	{
		
		public static const CLEAR_TAG_EVENT:String = "clearTagEvent";		
		
		private var divider:Shape;
		private var icon:Bitmap;
		
		public function ClearTagButton() {
			super({
				width: 212,
				height: 64,
				text: "Clear Tag",
				textColor: 0xffffff,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 18,
				letterSpacing: -1,
				buttonMode: true,
				paddingLeft: 29,
				alignmentY: 0.5,
				backgroundColor: 0x000000
			});
			
			divider = GraphicsUtil.shapeFromSize(1, 18, 0xFFFFFF);
			divider.x = 153;
			divider.y = 23;
			background.addChild(divider);
			
			icon = Assets.getClearIcon();
			icon.x = 164;
			icon.y = 23;
			background.addChild(icon);
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(icon, 0.1, {transformAroundCenter: {scaleX: 0.5, scaleY: 0.5}});			
		}
		
		private function onUp(e:MouseEvent):void {
			this.dispatchEvent(new Event(CLEAR_TAG_EVENT));			
			TweenMax.to(icon, 0.5, {transformAroundCenter: {scaleX: 1, scaleY: 1}});		
		}	

	}
}