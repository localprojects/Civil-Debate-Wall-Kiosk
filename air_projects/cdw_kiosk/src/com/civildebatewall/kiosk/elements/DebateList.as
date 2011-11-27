package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.kiosk.core.Kiosk;
	import com.civildebatewall.kiosk.legacy.OldBlockBase;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
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
					
					var mostLikedPosts:Array = [];
					for (var j:int = 0; j < CivilDebateWall.data.mostLikedPosts.length; j++) {
						mostLikedPosts.push(CivilDebateWall.data.mostLikedPosts[j]);
					}
					
					setItems(mostLikedPosts);
					
					break;
				default:
					trace("invalid stats view");
			}
			
			// select the first item
			
			
			
			
			
			
			
			
		}
		
		// takes a list of posts
		public function setItems(items:Array):void {
			GraphicsUtil.removeChildren(this);
			
			var yAccumulator:Number = 0;
			
			var containsSuperlativePost:Boolean = false;
			
			for (var i:int = 0; i < items.length; i++) {
				var item:DebateListItem = new DebateListItem(items[i], i + 1);
				
				
				// What to call out?
				switch (CivilDebateWall.state.statsView) {
					case State.VIEW_MOST_DEBATED:
						item.callout.text = item.post.thread.postCount + " " + StringUtil.plural("Response", item.post.thread.postCount);
						break;
					case State.VIEW_MOST_LIKED:
						item.callout.text = item.post.likes + " " + StringUtil.plural("Like", item.post.likes);
						break;
					default:
						trace("invalid stats view");
				}				
				
				
				item.onButtonDown.push(onItemSelected);
				item.visible = true;
				item.y = yAccumulator;
				addChild(item);
				
				if (CivilDebateWall.state.superlativePost != null) {
					if (item.post.id == CivilDebateWall.state.superlativePost.id) {
						containsSuperlativePost = true;
						item.activate();
					}
				}
					
				yAccumulator += item.height + yPadding;
			}
			
			// nothing is selected? make the first one
			if (!containsSuperlativePost) {
				CivilDebateWall.state.setSuperlativePost((getChildAt(0) as DebateListItem).post);
				item.activate();
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