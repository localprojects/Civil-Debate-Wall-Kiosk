package net.localprojects.elements {
	
	import flash.geom.Rectangle;
	
	import net.localprojects.Assets;
	import net.localprojects.CDW;
	import net.localprojects.blocks.BlockBase;
	
	public class CameraOverlay extends BlockBase {
		
		private var opacity:Number;
		private var backgroundColor:uint;
		private var borderColor:uint;		
		private var window:Rectangle;

		public function CameraOverlay()	{
			super();
			init();
		}
		
		private function init():void {
			window = new Rectangle(116, 289, 849, 1522);
			opacity = 0.25;
			draw();
			this.cacheAsBitmap = true;
		}
		
		private function draw():void {
			this.graphics.clear();
			
			this.graphics.beginFill(backgroundColor, opacity);
			this.graphics.drawRect(0, 0, 1080, window.y); // top
			this.graphics.endFill();
			
			this.graphics.beginFill(backgroundColor, opacity);			
			this.graphics.drawRect(window.x + window.width, window.y, 1080 - (window.x + window.width), window.height); // right
			this.graphics.endFill();
			
			this.graphics.beginFill(backgroundColor, opacity);			
			this.graphics.drawRect(0, window.y + window.height, 1080, 1920 - (window.y + window.height)); // bottom
			this.graphics.endFill();

			this.graphics.beginFill(backgroundColor, opacity);			
			this.graphics.drawRect(0, window.y, 1080 - (window.x + window.width), window.height); // left
			this.graphics.endFill();
			
			this.graphics.lineStyle(15, borderColor, 1.0, true);
			this.graphics.drawRect(window.x, window.y, window.width, window.height);
			this.graphics.endFill();
		}
		
		public function setColor(borderC:uint, backgroundC:uint):void {
			borderColor = borderC;
			backgroundColor = backgroundC;			
			draw();
		}

	}
}