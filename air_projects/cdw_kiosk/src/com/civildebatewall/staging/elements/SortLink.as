package com.civildebatewall.staging.elements {
	
	import com.civildebatewall.Assets;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	
	import flash.display.Shape;
	
	public class SortLink extends BlockText {

		private var underline:Shape;
		
		public function SortLink(params:Object=null) {
			
			super(
				ObjectUtil.mergeObjects(
					params, 		
					{textFont: Assets.FONT_REGULAR,
					backgroundColor: Assets.COLOR_GRAY_5,
					textColor: Assets.COLOR_GRAY_25,
					textSizePixels: 14,
					buttonMode: true})
			);
			
			underline = new Shape();
			underline.graphics.beginFill(Assets.COLOR_GRAY_85);
			underline.graphics.drawRect(0, 0, this.width - 2, 2);
			underline.graphics.endFill();
			underline.y = this.height + 5;
			underline.x = 3;
			underline.alpha = 0;
			addChild(underline);
		}
		
		public function drawMouseDown():void {
			textColor = Assets.COLOR_GRAY_85;
			underlineAlpha = 1;
		}
		
		public function drawMouseUp():void {
			TweenMax.to(this, 0.5, {textColor: Assets.COLOR_GRAY_25, underlineAlpha: 0});			
		}

		public function get underlineAlpha():Number {	return underline.alpha;	}		
		public function set underlineAlpha(a:Number):void {
			underline.alpha = a;
		}
		
	}
}