package com.civildebatewall.kiosk.buttons {
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	
		public class BigGrayButton extends BlockBitmap	{
			
			private var _overColor:uint;
			
			public function BigGrayButton(b:Bitmap) {
				super({
					bitmap: b,
					overColor: ColorUtil.gray(77),
					backgroundColor: 0xffffff,
					width: 432,
					height: 142,
					backgroundRadius: 13,
					alignmentPoint: Alignment.CENTER,
					buttonMode: true,
					showRegistrationPoint: true
				});
				
				
				onButtonDown.push(onDown);
				onStageUp.push(onUp);
				onButtonCancel.push(onCancel);
				
				drawUp();
			}

			private function onDown(e:MouseEvent):void {
				drawDown();			
			}
			
			private function onUp(e:MouseEvent):void {
				drawUp();
			}
			
			private function onCancel(e:MouseEvent):void {
				removeStageUpListener();
				drawUp();
			}
			
			private function drawUp():void {
				TweenMax.to(this, 0.5, {backgroundColor: 0xffffff});
				TweenMax.to(bitmap, 0.5, {colorMatrixFilter: {colorize: _overColor, amount: 1}});
			}
			
			private function drawDown():void {
				TweenMax.to(this, 0, {backgroundColor: _overColor});
				TweenMax.to(bitmap, 0, {colorMatrixFilter: {colorize: 0xffffff, amount: 1}});
			}
			
			public function get overColor():uint {return _overColor; }
			public function set overColor(value:uint):void { _overColor = value; }
	}
}