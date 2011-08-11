package net.localprojects.ui {
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.elements.BlockLabel;
	
	public class BigButton extends ButtonBase	{
		
		private var labelText:BlockLabel;
		private var label:String;
		private var buttonWidth:Number;
		private var buttonHeight:Number;
		private var button:Sprite;		
		private var textPanelWidth:Number;
		private var textPanelHeight:Number;
		private var buttonMask:Shape;
		private var topPanel:Sprite;
		
		
		
		
		private var leftButtonEdge:Sprite;
		private var leftEdgeMatrix:Matrix;
		
		private var bottomButtonEdge:Sprite;
		private var bottomEdgeMatrix:Matrix;		
		
		public function BigButton(buttonLabel:String) {
			super();
			buttonWidth = 520;
			buttonHeight = 141;
			label = buttonLabel;			
			init();
		}
		
		private function init():void {
	
			// draw the bounding box
			buttonMask = new Shape();
			buttonMask.graphics.beginFill(0x000000);
			buttonMask.graphics.drawRect(0, 0, 520, 141);
			buttonMask.graphics.endFill();
			
			// create the actual button panel
			button = new Sprite();
			
			
			// bottom edge
			bottomButtonEdge = new Sprite();
			
			bottomEdgeMatrix = new Matrix();
			bottomButtonEdge.graphics.beginBitmapFill(Assets.bottomButtonTile.bitmapData, bottomEdgeMatrix);
			bottomButtonEdge.graphics.drawRect(0, 0, 521, 42);
			bottomButtonEdge.graphics.endFill();
			bottomButtonEdge.cacheAsBitmap = true;
			bottomButtonEdge.y = 98;
			
			var bottomMask:Bitmap = Assets.bottomEdgeMask;
			bottomMask.cacheAsBitmap = true;
			bottomMask.y = 98;
			
			button.addChild(bottomButtonEdge);
			button.addChild(bottomMask);
			
			bottomButtonEdge.mask = bottomMask;					
			
			
			// left edge
			leftButtonEdge = new Sprite();			
			
			leftEdgeMatrix = new Matrix();
			leftButtonEdge.graphics.beginBitmapFill(Assets.leftButtonTile.bitmapData, leftEdgeMatrix);
			leftButtonEdge.graphics.drawRect(0, 0, 35, 141);
			leftButtonEdge.graphics.endFill();
			leftButtonEdge.cacheAsBitmap = true;
			
			var leftMask:Bitmap = Assets.leftEdgeMask;
			leftMask.cacheAsBitmap = true;
			
			button.addChild(leftButtonEdge);			
			button.addChild(leftMask);
			
			leftButtonEdge.mask = leftMask;
			
			
			// top surface
			
			
			topPanel = new Sprite();
			topPanel.graphics.beginBitmapFill(Assets.buttonBackground.bitmapData);
			topPanel.graphics.drawRect(0, 0, 485, 98);
			topPanel.graphics.endFill();			
			topPanel.x = 35;
			
			button.addChild(topPanel);			
			
			// create the button text format
			labelText = new BlockLabel(label, 36, 0x4c4d4f, 0x000000, true, false);
			labelText.visible = true;
			labelText.setPadding(0, 0, 0, 0);
			Utilities.centerWithin(labelText, topPanel);

			
			addChild(buttonMask);
			addChild(button);
			topPanel.addChild(labelText);
			
			button.mask = buttonMask;
			
			enable();
		}
		
		
		// pass through to the label
		public function setText(s:String, instant:Boolean = false):void {
			labelText.setText(s, instant);
			
			Utilities.centerWithin(labelText, topPanel);			
		}
		

		private function onEnterFrame(e:Event):void {
			// barber pole animation			
			
			leftEdgeMatrix.tx += 1;
			
			leftButtonEdge.graphics.beginBitmapFill(Assets.leftButtonTile.bitmapData, leftEdgeMatrix);
			leftButtonEdge.graphics.drawRect(0, 0, 35, 141);
			leftButtonEdge.graphics.endFill();
			
			bottomEdgeMatrix.ty -= 1;
			
			bottomButtonEdge.graphics.beginBitmapFill(Assets.bottomButtonTile.bitmapData, bottomEdgeMatrix);
			bottomButtonEdge.graphics.drawRect(0, 0, 521, 42);
			bottomButtonEdge.graphics.endFill();			
		}
		
		
		override protected function onMouseDown(e:MouseEvent):void {
			super.onMouseDown(e);
			disable();
		}
		
		// move to parent?
		override public function disable():void {
			super.disable();
			TweenMax.to(button, 0.25, {x: -26, y: 32, ease:Strong.easeOut, colorMatrixFilter:{saturation: 0}});
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);						
		}
		
		override public function enable():void {
			super.enable();
			TweenMax.to(button, 0.1, {x: 0, y: 0, ease:Strong.easeOut, colorMatrixFilter:{saturation: 1}});
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);			
		}

		
		
		

		
		
	}
}