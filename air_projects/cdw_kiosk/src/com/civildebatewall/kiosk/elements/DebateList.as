package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.kiosk.Kiosk;
	import com.civildebatewall.kiosk.blocks.OldBlockBase;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.elements.BreakElement;
	
	import sekati.layout.Arrange;
	
	public class DebateList extends BlockBase {
		
		private const numItems:int = 5;
		private const yPadding:Number = 15;
		
		
		
		public function DebateList() {
			super();
			width = 505;
			height = 845;
			backgroundAlpha = 0;
			
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
			CivilDebateWall.state.addEventListener(State.ON_STATS_VIEW_CHANGE, onViewChange);		
		}
		
		private function onViewChange(e:Event):void {
			updateList();
		}
		
		private function onDataUpdate(e:Event):void {
			updateList();
		}
		
		private function updateList():void {
			// rebuild the list
			switch (CivilDebateWall.state.statsView) {
				case State.VIEW_MOST_DEBATED:
					
					// pull out the first posts so we're working with posts instead of threads
					var mostDebatedFirstPosts:Array = [];
					for (var i:int = 0; i < CivilDebateWall.data.mostDebatedThreads.length; i++) {
						mostDebatedFirstPosts.push(CivilDebateWall.data.mostDebatedThreads[i].firstPost);
					}
					
					setItems(mostDebatedFirstPosts);
					
					break;
				case State.VIEW_MOST_LIKED:
					
					var mostLikedFirstPosts:Array = [];
					for (var j:int = 0; j < CivilDebateWall.data.mostLikedPosts.length; j++) {
						mostLikedFirstPosts.push(CivilDebateWall.data.mostLikedPosts[j].firstPost);
					}
					
					setItems(mostLikedFirstPosts);
					
					break;
				default:
					trace("invalid stats view");
			}			
		}
		
		// takes a list of posts
		public function setItems(items:Array):void {
			GraphicsUtil.removeChildren(this);
			
			var yAccumulator:Number = 0;
			
			for (var i:int = 0; i < items.length; i++) {
				var item:DebateListItem = new DebateListItem(items[i], i + 1);
				item.onButtonDown.push(onItemSelected);
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
		
		public function onItemSelected(e:MouseEvent):void {
			// deselect the others
			
			
			
			var clickedItem:DebateListItem = e.currentTarget as DebateListItem;			
			
			for(var i:int = 0; i < this.numChildren; i++) {
				var item:DebateListItem = this.getChildAt(i) as DebateListItem;
				
				if (clickedItem.post.id != item.post.id) {
					item.deactivate();
				}
			}
			
			clickedItem.activate();			
			
			// activate the new one id it's not already				
			
				
				// send event
				
				// tell the state!
			CivilDebateWall.state.setSuperlativePost(clickedItem.post);
				
				
				// if(onSelected != null) onSelected(clickedItem);				
			
		}
		
	}
}