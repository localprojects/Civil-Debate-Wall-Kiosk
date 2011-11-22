package com.civildebatewall.staging
{
	import com.kitschpatrol.futil.blocks.BlockText;
	
	import flash.text.TextLineMetrics;
	
	public class BlockTextOpinion extends BlockText
	{
		public function BlockTextOpinion(params:Object=null)
		{
			super(params);
		}
		
		override public function update(contentWidth:Number = -1, contentHeight:Number = -1):void {
			super.update(contentWidth, contentHeight);
			drawBackground();
		}
		
		protected function drawBackground():void {
			background.graphics.clear();
			
			if (textField != null) {
			
			var yPos:Number = 0;			
			for (var i:int = 0; i < textField.numLines; i++) {
				var metrics:TextLineMetrics = textField.getLineMetrics(i);				
				
				
				background.graphics.beginFill(backgroundColor); // white fill for manipulation by tweenmax			
				
				if (i == 0 || i == textField.numLines - 1) {
					// first or last line
					background.graphics.drawRect(0, yPos, Math.round(metrics.width - 4) + paddingLeft + paddingRight, textSize + paddingTop + paddingBottom);
				}
				else {
					// middle line
					background.graphics.drawRect(0, yPos + 4, Math.round(metrics.width - 4) + paddingLeft + paddingRight, textSize + paddingTop + paddingBottom - 4);					
				}
				
				
				background.graphics.endFill();
				yPos += metrics.height;				
			}		
			}
		}
	}
}
