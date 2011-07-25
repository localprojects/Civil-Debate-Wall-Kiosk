package net.localprojects {
	import com.adobe.serialization.json.*;
	import com.greensock.*;
	import com.greensock.events.*;
	import com.greensock.loading.*;
	
	import flash.events.*;
	import flash.net.*;
	
	public class Database extends EventDispatcher {
		
		
		
		// startup:
		// load everything from the server, put it into flash objects
		
		// download all the images, save them locally
		
		// update:
		// load everything form the server since the last time, put it into flash objects		
		
		public const BASE_PATH:String = 'http://ec2-50-19-25-31.compute-1.amazonaws.com'
		
		
		public var questions:Array = [];
		public var users:Array = [];
		public var debates:Array = [];			
			
		private var imageQueue:LoaderMax;
			
		public function Database() {
			super();
		}
		
		public function load():void {
			loadAllUsers();
			loadAllQuestions();			
		}
		
		private function loadAllDebates():void {
			var urlRequest:URLRequest = new URLRequest(BASE_PATH + "/debates/list");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onAllQuestionsLoaded);  
			urlLoader.load(urlRequest);			
		}
		
		private function onAllDebatessLoaded(e:Event):void {
			trace("Loaded debates list from server");			
			var debateList:* = JSON.decode(e.target.data);
			
			for each (var debate:* in debateList) {
				trace(debate);
				debates.push(debate);
			}
		}		
		
		private function loadAllQuestions():void {
			var urlRequest:URLRequest = new URLRequest(BASE_PATH + "/questions/list");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onAllQuestionsLoaded);  
			urlLoader.load(urlRequest);
		}		
		
		private function onAllQuestionsLoaded(e:Event):void {
			trace("Loaded question list from server");			
			var questionList:* = JSON.decode(e.target.data);
			
			for each (var question:* in questionList) {
				trace(question);
				questions.push(question);
			}
		}
		
		public function loadAllUsers():void {
			var urlRequest:URLRequest = new URLRequest(BASE_PATH + "/users/list");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onAllUsersLoaded);  
			urlLoader.load(urlRequest);
		}
		
		public function onAllUsersLoaded(e:Event):void {
			// receives a JSON object of all users from the database,
			// starts download and caching user images
			trace("Loaded user list from server");
			
			var response:* = JSON.decode(e.target.data);
			
			// manage image loading
			imageQueue = new LoaderMax({name:"imageQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});			
			
			for each (var user:* in response) {
				trace(user.firstName);
				
				if (user.photos.length > 0) {
					user.hasPhoto = true;
					
					var thumbnailUrlRequest:URLRequest = new URLRequest(BASE_PATH + '/static/' + user.photos[user.photos.length - 1].thumbnailUrl);
					var portraitUrlRequest:URLRequest = new URLRequest(BASE_PATH + '/static/' + user.photos[user.photos.length - 1].originalUrl);										
					
					
					user.thumbnailLoader = new ImageLoader(thumbnailUrlRequest, {estimatedBytes:2400});
					user.portraitLoader = new ImageLoader(portraitUrlRequest, {estimatedBytes:2400});					
					
					// enqueue the photos
					imageQueue.append(user.thumbnailLoader);
					imageQueue.append(user.portraitLoader);
				}
				else {
					// use placeholder
					user.hasPhoto = false;					
				}
				
				// add the user to the db
				users.push(user);			
			}
			
			//start loading images
			imageQueue.load();											
		}
		
		
		
		private function completeHandler(event:LoaderEvent):void {
			trace(event.target + " is complete!");
			
			// pull out the bitmaps
			for each (var user:* in users) {
				if (user.hasPhoto) {
					user.thumbnail = user.thumbnailLoader.rawContent;
					user.portrait= user.portraitLoader.rawContent;
				}
			}
			
			// forward to the stage
			this.dispatchEvent(event);
		}		
		
		
		private function progressHandler(event:LoaderEvent):void {
			trace("progress: " + event.target.progress);
		}
		

		private function errorHandler(event:LoaderEvent):void {
			trace("error occured with " + event.target + ": " + event.text);
		}				
		
	}
}