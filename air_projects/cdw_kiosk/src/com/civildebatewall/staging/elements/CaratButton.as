package com.civildebatewall.staging.elements
{
	
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.MouseEvent;
	
	public class CaratButton extends BlockBitmap	{
		public function CaratButton(params:Object = null)		{
			super(params);
			buttonMode = true;
			width = 64;
			height = 64;
			visible = true;
			alignmentPoint = Alignment.CENTER;

			onButtonDown.push(onDown);
			onStageUp.push(onUp);			
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(bitmap, 0, {alpha: 0.5});			
		}
		
		private function onUp(e:MouseEvent):void {
			TweenMax.to(bitmap, 0.5, {alpha: 1});
		}
	}
}