package net.localprojects {
	import com.adobe.serialization.json.*;
	import com.greensock.*;
	import com.greensock.events.*;
	import com.greensock.loading.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.net.*;
	
	public class Database extends EventDispatcher {
		
		
		
		// startup:
		// load everything from the server, put it into flash objects
		
		// download all the images, save them locally
		
		// update:
		// load everything form the server since the last time, put it into flash objects		
		
		public const BASE_PATH:String = CDW.settings.imagePath;
		

		// todo, just use debate list with automatic python dereferencing!?
		
		
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
			Utilities.postRequestJSON('http://ec2-50-19-25-31.compute-1.amazonaws.com/api/questions/get', {'id': '4e2755b50f2e420354000001'}, onQuestionReceived);
		}
		
		private function onQuestionReceived(r:Object):void {
			trace('Question Loaded, getting debates');
			
			// Store the question
			question = r;
			
			// User info is included automatically via Python's MongoDB DOCRef dereferencing
			Utilities.postRequestJSON('http://ec2-50-19-25-31.compute-1.amazonaws.com/api/debates/list', {'question': '4e2755b50f2e420354000001'}, onDebatesReceived);
		}
		
		
		
		private var portraitsRequested:int = 0;
		private var portraitsLoaded:int = 0;
		
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
					portraitsRequested++;
					
					// load the image
					portraits[authorID] = new Bitmap();
					Utilities.loadImageFromDiskToTarget(CDW.settings.imagePath + authorID + '-full.jpg', portraits[authorID], onImageLoaded);
				}
				
			}
			
		}
		
		private function onImageLoaded():void {
			portraitsLoaded++;
			
			trace("loaded " + portraitsLoaded + " out of " + portraitsRequested);
			
			if (portraitsRequested == portraitsLoaded) {
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
			
			portraitsLoaded = portraitsLoaded;
		}
		
		
		// STUBS
		public function getQuestionText():String {
			return '';
		}
		
		public function getActivePortrait():Bitmap {
			trace('Author '  + getDebateAuthor(CDW.state.activeDebate));
			return portraits[getDebateAuthor(CDW.state.activeDebate)];
		}
		
		private function getDebateAuthor(debateID:String):String {
			return debates[debateID]['author']['_id']['$oid'];
		}
		
	}
}