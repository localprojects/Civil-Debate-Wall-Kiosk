package com.civildebatewall.data {

	import com.adobe.crypto.SHA1;
	import com.adobe.serialization.json.*;
	import com.civildebatewall.*;
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.*;
	
	public class Data extends EventDispatcher {
		
		
		public static const DATA_UPDATE_EVENT:String = "dataUpdateEvent";
		public static const DATA_PRE_UPDATE_EVENT:String = "dataPreUpdateEvent";
		
		
		public static const LIKE_UPDATE_LOCAL:String = "likeUpdateLocal";
		public static const LIKE_UPDATE_SERVER:String = "likeUpdateServer";		
		public static const FLAG_UPDATE_LOCAL:String = "flagUpdateLocal";
		public static const FLAG_UPDATE_SERVER:String = "flagUpdateServer";		
		
		
		// TODO back to arrays... faster for objects and easier to grow / shrink
		public var badWords:Vector.<String>;
		public var boringWords:Vector.<String>;
		public var categories:Array;
		public var questions:Array;
		public var users:Array;
		public var threads:Array;
		public var posts:Array;
		
		// stats
		public var stats:Stats; // container		
		
			
		public function Data() {
			super();
			// Hash the secret key (just once at start up)
			CivilDebateWall.settings.secretKeyHash = SHA1.hash(CivilDebateWall.settings.secretKey);
		}
		
		
		public function load():void {
			trace("Loading data");
			loadBadWords();
		}
		
		public function onLoadComplete():void {
			trace("Load complete");
			
			if (CivilDebateWall.state.firstLoad) {
				this.dispatchEvent(new Event(Data.DATA_PRE_UPDATE_EVENT));
				CivilDebateWall.state.activeThread = ArrayUtil.randomElement(threads);
			}
			this.dispatchEvent(new Event(Data.DATA_UPDATE_EVENT));
			
			CivilDebateWall.state.firstLoad = false;
		}
		
		
		// Implementation ========================================================================================================================
		
		


		// loaders in function variables for chaining
		private function loadBadWords(onLoad:Function = null):void {
			trace("Loading bad words");
			// TODO get this from back end!
			var response:Array = [];
			badWords = new Vector.<String>();
			for each (var badWord:String in response) badWords.push(badWord);			
			badWords.fixed = true;
			trace("Loaded " + badWords.length + " bad words");
			(onLoad != null) ? onLoad() :	onLoadBadWords();
		}
			
		private function onLoadBadWords():void {
			loadBoringWords();
		}
		
		private function loadBoringWords(onLoad:Function = null):void {
			trace("Loading boring words");
			// TODO get this from back end!
			var response:Array = ["not", "for", "this", "and", "are", "but", "your", "has", "have", "the", "that", "they", "with"];
			boringWords = new Vector.<String>();
			for each (var boringWord:String in response) boringWords.push(boringWord);
			boringWords.fixed = true;
			trace("Loaded " + boringWord.length + " boring words");
			(onLoad != null) ? onLoad() :	onLoadBoringWords();
		}
			
		private function onLoadBoringWords():void {
			loadCategories();
		}			
		
		private function loadCategories(onLoad:Function = null):void {
			trace("Loading categories");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/categories", function(response:Object):void {
				categories = [];
				for each (var category:Object in response) categories.push(new Category(category));
				trace("Loaded " + categories.length + " categories");				
				(onLoad != null) ? onLoad() :	onLoadCategories();
			});
		}
			
			private function onLoadCategories():void {
				loadQuestions();
			}
		
		// depends on categories...
		private function loadQuestions(onLoad:Function = null):void {
			trace("Loading questions.");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions", function(response:Object):void {
				questions = [];
				for each (var question:Object in response) questions.push(new Question(question));
				trace("Loaded " + questions.length + " questions");	
				(onLoad != null) ? onLoad() :	onLoadQuestions();
			});
		}
		
		
			
		private function onLoadQuestions():void {
			getActiveQuestion();
		}
		
		private function getActiveQuestion(onLoad:Function = null):void {
			trace("Loading active question");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/current", function(response:Object):void {
				CivilDebateWall.state.question = getQuestionByID(response.id);
				trace("Loaded active question: \"" + CivilDebateWall.state.question.text + "\"");
				CivilDebateWall.state.question = CivilDebateWall.state.question;
				trace("In category: \"" + CivilDebateWall.state.question.category.name + "\"");
				(onLoad != null) ? onLoad() :	onGetActiveQuestion();
			});
		}
			
		private function onGetActiveQuestion():void {
			loadThreads();
		}			
		
			
		// depends on active question
		private function loadThreads(onLoad:Function = null):void {
			trace("Loading threads");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + '/api/questions/' + CivilDebateWall.state.question.id + '/threads', function(response:Object):void {
				threads = [];
				for each (var thread:Object in response) threads.push(new Thread(thread));
				trace ("Loaded " + threads.length + " threads");
				(onLoad != null) ? onLoad() :	onLoadThreads();
			});
		}
			
		private function onLoadThreads():void {
			loadPosts();
		}
			
		// depends on threads
		private var threadsLoaded:int;	
		
		private function loadPosts(onLoad:Function = null):void {
			posts = [];
			
			threadsLoaded = 0;
			// loads posts for each thread
			for (var i:int = 0; i < threads.length; i++) {
				Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + '/api/threads/' + threads[i].id, onThreadPostsLoaded, threads[i]);
			}
		}
		
		private function onThreadPostsLoaded(response:Object, thread:Thread):void {
			threadsLoaded++;

			trace("Loaded thread posts " + threadsLoaded + " / " + threads.length + " (" + thread.id + ")");
			
			// push global
			for each (var jsonPost:Object in response['posts']) {
				var tempPost:Post = new Post(jsonPost, thread); 				
				CivilDebateWall.data.posts.push(tempPost); // and one reference  globally
				thread.posts.push(tempPost); // push another reference to thread
			}
			thread.init();			
			
			if (threadsLoaded == threads.length) {
				onLoadPosts();
			}
		};					

		private function onLoadPosts():void {
			loadUsers();
		}
		
		public var photoQueue:LoaderMax;
		private function loadUsers():void {
			trace("Loading users");
			// TODO only get users active for this question
			photoQueue = new LoaderMax({name:"portraitQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});			
			
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + '/api/users', function(response:Object):void {
				trace("Loaded users");
				users = [];
				for each (var json:Object in response) users.push(new User(json));
				onLoadUsers();
			});						
			
			
			trace("Loading images");
			photoQueue.load();
		}
		
		private function progressHandler(event:LoaderEvent):void {
			//MonsterDebugger.trace(this, "progress: " + event.target.progress);
		}
		
		private function errorHandler(event:LoaderEvent):void {
			MonsterDebugger.trace(this, "error occured loading image " + event.target + ": " + event.text);
		}		
		
		private function completeHandler(event:LoaderEvent):void {
			trace("Image loading complete.");
		}		
		
		
		// last batch, images load in background
		private function onLoadUsers():void {
			
			// fill in user references in posts
			for each (var post:Post in posts) {
				post.initUser();
			}
			
			
			calculateStats();
			onLoadComplete();
		}	
		
		/// END LOADING IMPLEMENTATION ======================================================================
		
		private function calculateStats():void {
			trace("Calculating stats");
			
			// most liked debates
			stats = new Stats();			
			
			stats.mostLikedPosts = [];
			posts.sortOn('likes', Array.DESCENDING | Array.NUMERIC);
			for (var i:uint = 0; i < Math.min(posts.length, 5); i++) {
				stats.mostLikedPosts.push(posts[i]);
			}
			
			// most debated threads
			stats.mostDebatedThreads = [];
			threads.sortOn('postCount', Array.DESCENDING | Array.NUMERIC);
			threads.sorton
			for (var j:uint = 0; j < Math.min(threads.length, 5); j++) {
				stats.mostDebatedThreads.push(threads[j]);
			}
			
			var yesLikes:uint = 0;
			var noLikes:uint = 0;
			var yesPosts:uint = 0;
			var noPosts:uint = 0;			
			
			for each (var post:Post in posts) {
				if (post.stance == Post.STANCE_YES) {
					yesLikes += post.likes;
					yesPosts++;
				}
				else {
					noLikes += post.likes;				
					noPosts++;
				}
			}
						
			stats.likesYes = yesLikes;
			stats.likesNo = noLikes;
			stats.likesTotal = yesLikes + noLikes;
			
			stats.postsYes = yesPosts;
			stats.postsNo = noPosts;
			stats.postsTotal = yesPosts + noPosts;
				
			// get this from server instead
			// build the corpus
			var wordSearch:RegExp = new RegExp(/\w*\w/g);
			var corpus:Array = [];
			for each (post in posts) {
				corpus = ArrayUtil.mergeUnique(corpus, post.text.toLowerCase().match(wordSearch));
			}
			
			
			stats.frequentWords = [];
			for each (var corpusWord:String in corpus) {
				// filter out small words
				if (corpusWord.length > 2) {
					// filter out boring words
					// ignore boring words
					if (boringWords.indexOf(corpusWord) > - 1) {
						MonsterDebugger.trace(this, corpusWord + " is boring, skipping it");
					}
					else {
						stats.frequentWords.push(new Word(corpusWord));
					}
				}
			}
			
			
			// find frequency, store in json for easy plug-in to future server side implementation
			for each (var word:Word in stats.frequentWords) {
				// search all posts
				for each (post in posts) {
					var regex:RegExp = new RegExp(/\b/.source + word +  /\b/.source, 'g');					
					
					var wordsInPost:Array = post.text.toLowerCase().match(wordSearch);
					
					for each (var wordInPost:String in wordsInPost) {
						
						if (wordInPost === word.theWord) {
							if (post.stance == Post.STANCE_YES) {
								word.yesCases++;
							}
							else {
								word.noCases++;
							}
							
							ArrayUtil.pushIfUnique(word.posts, post);
							word.total++;
						}
					}
				}
			}			
			
			stats.frequentWords.sortOn('total', Array.DESCENDING, Array.NUMERIC);
			
			
			stats.yesPercent = stats.postsYes / stats.postsTotal; 
			
			// end stats
			// now sort by date
			// TODO go back to sorting based on state?
			CivilDebateWall.state.setSort(CivilDebateWall.state.sortMode);
			
			threads.sortOn('created', Array.DESCENDING | Array.NUMERIC); // newest first // Is this working?
			posts.sortOn('created', Array.DESCENDING); // newest first
		}
		

			
		
		// ====== UPDATES =================
		
		// mutate server
		public function uploadResponse(threadID:String, responseTo:String, userID:String, opinion:String, stance:String, origin:String, callback:Function):void {
			var yesno:uint = (stance == Post.STANCE_YES) ? 1 : 0;
			var params:Object = {'yesno': yesno, 'text': opinion, 'responseto': responseTo, 'author': userID, 'origin': origin};
			Utilities.postRequestJSON(CivilDebateWall.settings.serverPath + '/api/threads/' + threadID + '/posts', params, callback);
		}
					
		public function uploadThread(questionId:String, userID:String, opinion:String, stance:String, origin:String, callback:Function):void {
			var yesno:uint = (stance == Post.STANCE_YES) ? 1 : 0;
			var params:Object = {'yesno': yesno, 'text': opinion, 'author': userID, 'origin': origin}; 
			Utilities.postRequestJSON(CivilDebateWall.settings.serverPath + '/api/questions/' + questionId + '/threads', params, callback);			
		}		
		
		public function createUser(username:String, phoneNumber:String, callback:Function):void {
			trace("Creating user with phone: " + phoneNumber);
			trace("Creating user with username: " + username);			
			Utilities.postRequestJSON(CivilDebateWall.settings.serverPath + '/api/users', {'phonenumber': phoneNumber, 'username': username}, callback);			
		}	
		

		
		public function like(post:Post):void {
			post.likes++;
			Utilities.postRequest(CivilDebateWall.settings.serverPath + '/api/posts/' + post.id + '/like', {}, onLikeUpdated);
			this.dispatchEvent(new Event(LIKE_UPDATE_LOCAL));
		}
		
		public function flag(post:Post):void {
			trace("flagging");
			Utilities.postRequest(CivilDebateWall.settings.serverPath + '/api/posts/' + post.id + '/flag', {}, onFlagUpdated);
			this.dispatchEvent(new Event(FLAG_UPDATE_LOCAL));
		}
		
		private function onLikeUpdated(r:Object):void {
			MonsterDebugger.trace(this, "likes updated server side for post " + r);
			this.dispatchEvent(new Event(LIKE_UPDATE_SERVER));
		}
		
		private function onFlagUpdated(r:Object):void {
			trace("flags updated server side for post " + r);
			this.dispatchEvent(new Event(FLAG_UPDATE_SERVER));
		}		
		
		
		// helpers
		
		public function submitDebate():void {
			// Syncs state up to the cloud

			if (CivilDebateWall.state.userPhoneNumber == null) CivilDebateWall.state.userPhoneNumber = "";
			
			createUser(CivilDebateWall.state.userName, CivilDebateWall.state.userPhoneNumber, function(response:Object):void {
				trace("Created user");
				trace(response["id"]);

				// user id,
				CivilDebateWall.state.userID = response["id"];					
				
				// save the images // TODO fix directory structure
				if (CivilDebateWall.state.userImageFull != null) FileUtil.saveJpeg(CivilDebateWall.state.userImageFull, CivilDebateWall.settings.imagePath, CivilDebateWall.state.userID + '-full.jpg');			
				if (CivilDebateWall.state.userImage != null) FileUtil.saveJpeg(CivilDebateWall.state.userImage, CivilDebateWall.settings.imagePath, CivilDebateWall.state.userID + '.jpg');
				
				var payload:Object;

				if (CivilDebateWall.state.userIsDebating) {
					// create and upload new post
					trace("Uploading response post");
					
					// TODO "userInProgress" and "postInProgress" objects in state
					trace("Responding to: " + CivilDebateWall.state.userRespondingTo.id);
					CivilDebateWall.data.uploadResponse(CivilDebateWall.state.activeThread.id, CivilDebateWall.state.userRespondingTo.id, CivilDebateWall.state.userID, CivilDebateWall.state.userOpinion, CivilDebateWall.state.userStance, Post.ORIGIN_KIOSK, onDebateUploaded);
				}
				else {
					// create and upload new thread
					trace("Uploading new thread");				
					CivilDebateWall.data.uploadThread(CivilDebateWall.state.question.id, CivilDebateWall.state.userID, CivilDebateWall.state.userOpinion, CivilDebateWall.state.userStance, Post.ORIGIN_KIOSK, onDebateUploaded);
				}				
				
			});
		}
		
		private function onDebateUploaded(r:Object):void {
			MonsterDebugger.trace(this, "submitting");
			
			trace("Debate uploaded");
			CivilDebateWall.state.userThreadID = r['id'];
			// CivilDebateWall.state.userPostID;; // comes later
			
			//submitOverlayContinueButton.tweenOut(-1, {alpha: 0, x: submitOverlayContinueButton.x, y: submitOverlayContinueButton.y});
			
//			if (CivilDebateWall.state.activeThread != null) {
//				CivilDebateWall.state.activeThreadID = CivilDebateWall.state.activeThread.id; // store the strings since objects will be wiped
//				CivilDebateWall.state.activeThread = null;
//			}
//			
//			if (CivilDebateWall.state.activePost != null) {			
//				CivilDebateWall.state.activePostID = CivilDebateWall.state.activePost.id; // store the strings since objects will be wiped				
//				CivilDebateWall.state.activePost = null;			
//			}			
			
			
			CivilDebateWall.data.load();
		}		
		
		
		// ID Lookup
		public function getCategoryById(id:String):Category {
			for each (var category:Category in categories) {
				if (category.id == id) return category;
			}
			return null;	
		}
		
		public function getQuestionByID(id:String):Question {
			for each (var question:Question in questions) {
				if (question.id == id) return question;
			}
			return null;
		}
		
		public function getThreadByID(id:String):Thread {
			for each (var thread:Thread in threads) {
				if (thread.id == id) return thread;
			}
			return null;
			// todo else raise error
		}			

		public function getPostByID(id:String):Post {
			for each (var post:Post in posts) {
				if (post.id == id) return post;
			}
			return null;
			// todo else raise error
		}		
		
		public function getUserByID(id:String):User {
			for each (var user:User in users) {
				if (user.id == id) return user;
			}
			return null;
			// todo else raise error
		}
		
	
		
	}
}