package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.kiosk.Kiosk;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.kiosk.blocks.BlockBase;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.events.Event;
	
	public class DebateList extends BlockBase {
		
		private const numItems:int = 5;
		private const yPadding:Number = 15;
		
		private var onSelected:Function = null;
		
		public function DebateList() {
			super();
			
			// background?
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, 503, 844);
			graphics.endFill();
		}
		
		// takes a bunch of string ids
		public function setItems(items:Array):void {
			GraphicsUtil.removeChildren(this);
			
			var yAccumulator:Number = 0;
			
			for (var i:int = 0; i < items.length; i++) {
				
				var item:DebateListItem = new DebateListItem(items[i], i + 1);
				item.setOnClick(onItemSelected);
				item.visible = true;
				item.y = yAccumulator;
				addChild(item);
					
				yAccumulator += item.height + yPadding;
			}
			
		}
		
		public function deactivateAll():void {
			for(var i:int = 0; i < numChildren; i++) {
				(getChildAt(i) as DebateListItem).deactivate();
			}
			
		}		
		
		public function setOnSelected(f:Function):void {
			onSelected = f;
		}
		
		public function onItemSelected(e:Event):void {
			// deselect the others
			var clickedItem:DebateListItem = e.currentTarget as DebateListItem;
			
			for(var i:int = 0; i < this.numChildren; i++) {
				var item:DebateListItem = this.getChildAt(i) as DebateListItem;
				
				if (clickedItem.post.id != item.post.id) {
					item.deactivate();
				}
			}
			
			
			if (!clickedItem.toggledOn) {
				// activate the new one id it's not already				
				clickedItem.activate();
				
				// send event				
				if(onSelected != null) onSelected(clickedItem);				
			}
			
			
			
		}
		
	}
}