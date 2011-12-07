package com.civildebatewall.kiosk.elements {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.kiosk.legacy.OldBlockBase;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class CameraOverlay extends OldBlockBase {
		
		private var opacity:Number;
		private var backgroundColor:uint;
		private var window:Rectangle;
		private var label:Bitmap;

		public function CameraOverlay()	{
			super();
			init();
		}
		
		private function init():void {
			window = new Rectangle(116, 265, 848, 1546);
			opacity = 0.85;
			draw();
			
			label = Assets.getPhotoPrompt();
			label.x = 272;
			label.y = 186;
			addChild(label);
			
			this.cacheAsBitmap = true;
			
			CivilDebateWall.state.addEventListener(State.USER_STANCE_CHANGE, onUserStanceChange);
		}
		
		private function draw():void {
			this.graphics.clear();
			
			// Draw the frame
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
		}
		
		private function onUserStanceChange(e:Event):void {
			if (CivilDebateWall.state.userStance == Post.STANCE_YES) {
				backgroundColor = ColorUtil.rgb(62, 124, 148);	
			}
			else {
				backgroundColor = ColorUtil.rgb(141, 50, 3);
			}
			
			draw();			
		}
		
	}
}