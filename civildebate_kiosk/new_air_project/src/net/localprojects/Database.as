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
	import flash.net.*;
		
	public class Database extends EventDispatcher {
		
	
		public var question:Object = {};
		public var debates:Object = {};
		public var portraits:Object = {};
			
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
			trace('Question Loaded, getting debates');
			
			// Store the question
			question = r;
			
			// User info is included automatically via Python's MongoDB DOCRef dereferencing
			Utilities.postRequestJSON(CDW.settings.serverPath + '/api/debates/list', {'question': '4e2755b50f2e420354000001'}, onDebatesReceived);
		}
		

		private var queue:LoaderMax = new LoaderMax({name:"portraitQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});

		private function onDebatesReceived(r:Object):void {
			trace('Debates Loaded, getting portrait images');
						
			for each (var debate:Object in r) {
				
				// Store the debates in an id-keyed array					
				var debateID:String = debate['_id']['$oid'];
				debates[debateID] = debate;
				
				// start loading images, sotring them in an author-id keyed array
				var authorID:String = debate['author']['_id']['$oid']
				
				if (authorID in portraits) {
					trace('Already loading portrait for ' + authorID);
				}
				else {
					// load the image
					portraits[authorID] = new Bitmap();
					
					queue.append(new ImageLoader((new File(CDW.settings.imagePath + authorID + '-full.jpg')).url, {name: authorID, estimatedBytes:2400, container:this}) );
				}
			}
			
			queue.load();
		}
		
		private function progressHandler(event:LoaderEvent):void {
			trace("progress: " + event.target.progress);
		}
		
		private function completeHandler(event:LoaderEvent):void {
			trace(event.target + " is complete!");

			for (var id:String in portraits) {
				portraits[id] = (LoaderMax.getContent(id) as ContentDisplay).rawContent;
			}

			// ready to start
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function errorHandler(event:LoaderEvent):void {
			trace("error occured with " + event.target + ": " + event.text);
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
		
		public function getDebateAuthorName(debateID:String):String {
			return debates[debateID]['author']['firstName']; 
		}		
		
		public function getOpinion(debateID:String):String {
			return debates[debateID]['opinion'];
		}
		
		public function getStance(debateID:String):String {
			return debates[debateID]['stance'];
		}
		
		
		public function cloneDebateAuthorPortrait(debateID:String):Bitmap {
			return new Bitmap(portraits[getDebateAuthor(debateID)].bitmapData.clone());
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