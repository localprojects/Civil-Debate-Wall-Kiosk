package net.localprojects {
	
	import flash.events.*;
	import flash.utils.*;
	
	import net.localprojects.blocks.*;
	import net.localprojects.events.*;
	import net.localprojects.pages.*;
	
	
	public class ViewManager extends Object {
		
		// Controls What's on Screen
		
		// blocks (move to view class)
		//public var blocks:Array = new Array();		
		public var header:Header;
		public var debatePicker:DebatePicker;
		public var question:Question;
		public var faceOff:FaceOff;		
		
		// pages (move to view class)
		// public var pages:Array = new Array();		
		public var homePage:Page;
		public var portraitPage:Page;
		public var reviewOpinionPage:Page;
		public var resultsPage:Page;	
		
		public var stancePage:Page;
		public var answerPage:Page;

		
		public function ViewManager() {

		}
		
		public function init():void {
			// set up the blocks
			header = new Header();
			debatePicker = new DebatePicker();
			question = new Question();
			faceOff = new FaceOff();
			
			// set up the pages
			homePage = new HomePage();
			stancePage = new StancePage();
			answerPage = new AnswerPage();				
			
			// listent to the state
			Main.state.addEventListener(State.VIEW_CHANGE, onViewChange);			
		}
		
		
		private function onViewChange(e:Event):void {
			trace("view changed");
			
			// clear everything
			if ((Main.state.getLastView() != null) && Main.stageRef.contains(Main.state.getLastView())) {
				Main.stageRef.removeChild(Main.state.getLastView());
			}
			
			Main.stageRef.addChild(Main.state.getView());
		}
		
		public function setBlocks(... newBlocks):void {
			
			// build the array of existing blocks
			var oldBlocks:Array = new Array();
			
			for (var i:int = 0; i < Main.stageRef.numChildren; i++) {
				trace(getQualifiedClassName(Main.stageRef.getChildAt(i)));				
				if ("className"  == "Block") {
					oldBlocks.push(Main.stageRef.getChildAt(i));
				}
			}
			
			trace("Old blocks: ");
			trace(oldBlocks);
			
			// add new blocks
			for (var j:int = 0; j < newBlocks.length; j++) {
				if (!Utilities.arrayContains(newBlocks[j], oldBlocks)) {
					trace("Adding: " + newBlocks[j]);
					Main.stageRef.addChild(newBlocks[j]);
				}
			}
			
			// remove old ones
			for (var k:int = 0; k < oldBlocks.length; k++) {			
				if (!Utilities.arrayContains(oldBlocks[k], newBlocks)) {
					trace("Removing: " + oldBlocks[k]);
					Main.stageRef.removeChild(oldBlocks[k]);	
				}
				
			}		

		

			
			
			
			
			
		}
		
		
		
	}
}