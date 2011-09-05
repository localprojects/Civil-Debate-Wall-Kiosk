package net.localprojects {
	import com.adobe.serialization.json.*;
	import com.greensock.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.*;
	
	import sekati.utils.ColorUtil;
	
	public class Database extends EventDispatcher {
		
		
		public var question:Object = {};
		public var debates:OrderedObject = new OrderedObject();
		public var portraits:Object = {};
		public var stats:Object = {};
			
		private var imageQueue:LoaderMax;
			
		public function Database() {
			super();
		}
		
		public function load():void {
			// load the question
			// TODO get active question from server
			trace('Loading from DB');
			trace('Loading question');
			Utilities.postRequestJSON(CDW.settings.serverPath + '/api/questions/get', {'id': '4e2755b50f2e420354000001'}, onQuestionReceived);
		}
		
		private function onQuestionReceived(r:Object):void {
			trace('Question Loaded, getting users');
			
			// Store the question
			question = r;
		
			// Get users
			Utilities.getRequestJSON(CDW.settings.serverPath + '/users/list', onUsersReceived);			
		}
			
			
		
		private var queue:LoaderMax = new LoaderMax({name:"portraitQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
		
		private function onUsersReceived(r:Object):void {
			trace('Users received, now loading portraits');
			
			portraits = {};
			var userID:String;
			
			// create list of unique users...
			for (var userIndex:String in r) {
				userID = r[userIndex]['_id']['$oid'];
				portraits[userID] = null;
			}
			
			// load images
			for (userID in portraits) {
				
				// see if it exists

				
				var imageFile:File = new File(CDW.settings.imagePath + userID + '.jpg');
				
				if (imageFile.exists) {
					// load the portrait
					trace('Loading image from file for ' + userID);
					queue.append(new ImageLoader(imageFile.url, {name: userID, estimatedBytes:2400, container:this}) );
				}
				else {
					// use placeholder
					trace('Using placeholder for ' + userID);
					portraits[userID] = Assets.portraitPlaceholder;
				}
			}
			
			queue.load();
		}
		
		
		private function progressHandler(event:LoaderEvent):void {
			trace("progress: " + event.target.progress);
		}
		
		private function errorHandler(event:LoaderEvent):void {
			trace("error occured with " + event.target + ": " + event.text);
		}		
		
		private function completeHandler(event:LoaderEvent):void {
			trace(event.target + " is complete!");
			
			for (var id:String in portraits) {
				if (portraits[id] == null) {
					try {
						portraits[id] = new MetaBitmap(((LoaderMax.getContent(id) as ContentDisplay).rawContent as Bitmap).bitmapData, "auto", true); 
					}
					catch (error:Error) {
						trace("error" + error);
					}
				}
			}
				
			
			// load debates
			// TODO dynamic question
			Utilities.postRequestJSON(CDW.settings.serverPath + '/api/debates/list', {'question': '4e2755b50f2e420354000001'}, onDebatesReceived);			
		}
		

		private function onDebatesReceived(r:Object):void {
			trace('Debates received.');
						
			for each (var debate:Object in r) {
				// Store the debates in an ordered object			
				var debateID:String = debate['_id']['$oid'];
				
				debates[debateID] = debate;
			}
			
			// reverse them, newest first
			debates.reverse();			
			
			
			// load stats						
			Utilities.postRequestJSON(CDW.settings.serverPath + '/api/stats/get', {'question': '4e2755b50f2e420354000001'}, onStatsReceived);			
		}
		
		private function onStatsReceived(r:Object):void {
			trace('Stats received.');
			stats = r;
			
			// ready to start
			this.dispatchEvent(new Event(Event.COMPLETE));			
		}
		
		

		
		// STUBS
		public function getQuestionText():String {
			return question['question'];
		}
		
		public function getActivePortrait():Bitmap {
			return getDebateAuthorPortrait(CDW.state.activeDebate);
		}
		
		public function getDebateAuthor(debateID:String):String {
			return debates[debateID]['author']['_id']['$oid'];
		}
		
		public function getDebateAuthorPortrait(debateID:String):Bitmap {
			return portraits[getDebateAuthor(debateID)]; 
		}
		
		public function getPortrait(authorID:String):Bitmap {
			return portraits[authorID]; 
		}		
		
		public function getDebateAuthorName(debateID:String):String {
			return Utilities.toTitleCase(debates[debateID]['author']['firstName']); 
		}		
		
		public function getOpinion(debateID:String):String {
			return debates[debateID]['opinion'];
		}
		
		public function getStance(debateID:String):String {
			return debates[debateID]['stance'];
		}
		
		public function getDebateCount():int {
			var i:int = 0;
			for (var debateID:String in debates) {
				i++;
			}
			return i;
		}
		
		public function getCommentCount(debateID:String):int {
			var i:int = 0;
			
			for (var commentID:String in debates[debateID]['comments']) {
				trace('comment ID: ' + commentID);
				i++;
			}
			return i;
		}		
		
		
		public function cloneDebateAuthorPortrait(debateID:String):Bitmap {
			return new MetaBitmap(portraits[getDebateAuthor(debateID)].bitmapData.clone());
		}
		
		
		public function getNextDebate():String {
			var grabNext:Boolean;
			
			// walk the object
			for (var debateID:String in debates) {
				
				if (grabNext) {
					return debateID;
				}
				
				if (debateID == CDW.state.activeDebate) {
					grabNext = true;
				}
			}
			
			return null;
		}		
		
		public function getPreviousDebate():String {
			var lastID:String = null;
			
			// walk the object
			for (var debateID:String in debates) {
				if (debateID == CDW.state.activeDebate) {
					return lastID;
				}
				else {
					lastID = debateID;
				}
			}
			
			return null;
		}
		
	}
}