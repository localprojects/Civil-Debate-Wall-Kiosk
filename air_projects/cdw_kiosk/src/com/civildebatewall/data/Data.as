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
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	
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
		
		// the data
		public var badWords:Vector.<String>;
		public var boringWords:Vector.<String>;
		public var categories:Array;
		public var questions:Array;
		public var users:Array;
		public var threads:Array;
		public var posts:Array;
		public var stats:Stats;		
		
			
		public function Data() {
			super();
			// Hash the secret key (just once at start up)
			CivilDebateWall.settings.secretKeyHash = SHA1.hash(CivilDebateWall.settings.secretKey);
			trace(CivilDebateWall.settings.secretKeyHash);
		}
		
		// Run once at startup
		public function load():void {
			loadBadWords();
		}
		
		public function onLoadComplete():void {
			MonsterDebugger.trace(null, "Load complete");
			
			if (CivilDebateWall.state.firstLoad) {
				this.dispatchEvent(new Event(Data.DATA_PRE_UPDATE_EVENT));
				CivilDebateWall.state.setActiveThread(ArrayUtil.randomElement(threads));
			}
			this.dispatchEvent(new Event(Data.DATA_UPDATE_EVENT));
			
			CivilDebateWall.state.firstLoad = false;
		}
		
		
		
		public function update():void {
			MonsterDebugger.trace(null, "Updating data");
			updateThreads();
		}
		
		public function onUpdateComplete():void {
			MonsterDebugger.trace(null, "Update complete");
			this.dispatchEvent(new Event(Data.DATA_UPDATE_EVENT));
		}
		
		
		// Load Routine

		// loaders in function variables for chaining
		private function loadBadWords(onLoad:Function = null):void {
			MonsterDebugger.trace(null, "Loading bad words");
			// TODO get this from back end!
			var response:Array = [];
			badWords = new Vector.<String>();
			for each (var badWord:String in response) badWords.push(badWord);			
			badWords.fixed = true;
			MonsterDebugger.trace(null, "Loaded " + badWords.length + " bad words");
			(onLoad != null) ? onLoad() :	onLoadBadWords();
		}
			
		private function onLoadBadWords():void {
			loadBoringWords();
		}
		
		private function loadBoringWords(onLoad:Function = null):void {
			MonsterDebugger.trace(null, "Loading boring words");
			// TODO get this from back end!
			var response:Array = ["not", "for", "this", "and", "are", "but", "your", "has", "have", "the", "that", "they", "with"];
			boringWords = new Vector.<String>();
			for each (var boringWord:String in response) boringWords.push(boringWord);
			boringWords.fixed = true;
			MonsterDebugger.trace(null, "Loaded " + boringWord.length + " boring words");
			(onLoad != null) ? onLoad() :	onLoadBoringWords();
		}
			
		private function onLoadBoringWords():void {
			loadCategories();
		}			
		
		private function loadCategories(onLoad:Function = null):void {
			MonsterDebugger.trace(null, "Loading categories");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/categories", function(response:Object):void {
				categories = [];
				for each (var category:Object in response) categories.push(new Category(category));
				MonsterDebugger.trace(null, "Loaded " + categories.length + " categories");				
				(onLoad != null) ? onLoad() :	onLoadCategories();
			});
		}
			
			private function onLoadCategories():void {
				loadQuestions();
			}
		
		// depends on categories...
		private function loadQuestions(onLoad:Function = null):void {
			MonsterDebugger.trace(null, "Loading questions.");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions", function(response:Object):void {
				questions = [];
				for each (var question:Object in response) questions.push(new Question(question));
				MonsterDebugger.trace(null, "Loaded " + questions.length + " questions");	
				(onLoad != null) ? onLoad() :	onLoadQuestions();
			});
		}
		
		private function onLoadQuestions():void {
			getActiveQuestion();
		}
		
		private function getActiveQuestion(onLoad:Function = null):void {
			MonsterDebugger.trace(null, "Loading active question");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/current", function(response:Object):void {
				CivilDebateWall.state.question = getQuestionByID(response.id);
				MonsterDebugger.trace(null, "Loaded active question: \"" + CivilDebateWall.state.question.text + "\"");
				CivilDebateWall.state.question = CivilDebateWall.state.question;
				MonsterDebugger.trace(null, "In category: \"" + CivilDebateWall.state.question.category.name + "\"");
				(onLoad != null) ? onLoad() :	onGetActiveQuestion();
			});
		}
			
		private function onGetActiveQuestion():void {
			loadThreads();
		}			
		
			
		// depends on active question
		private function loadThreads(onLoad:Function = null):void {
			MonsterDebugger.trace(null, "Loading threads");
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

			MonsterDebugger.trace(null, "Loaded thread posts " + threadsLoaded + " / " + threads.length + " (" + thread.id + ")");
			
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
			MonsterDebugger.trace(null, "Loading users");
			// TODO only get users active for this question
			photoQueue = new LoaderMax({name:"portraitQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});			
			
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + '/api/users', function(response:Object):void {
				MonsterDebugger.trace(null, "Loaded users");
				users = [];
				for each (var json:Object in response) users.push(new User(json));
				onLoadUsers();
			});						
			
			
			MonsterDebugger.trace(null, "Loading images");
			
		}
		
		private function progressHandler(event:LoaderEvent):void {
			trace("progress");
			//MonsterDebugger.trace( this, "progress: " + event.target.progress);
		}
		
		private function errorHandler(event:LoaderEvent):void {
			trace("error");
			MonsterDebugger.trace( this, "error occured loading image " + event.target + ": " + event.text);
		}		
		
		private function completeHandler(event:LoaderEvent):void {
			trace("complete");
			MonsterDebugger.trace(null, "Image loading complete.");
		}		
		
		
		// last batch, images load in background
		private function onLoadUsers():void {
			
			// fill in user references in posts
			for each (var post:Post in posts) {
				post.initUser();
			}
			
			photoQueue.load();
			calculateStats();
			onLoadComplete();
		}	
		
		/// END LOADING IMPLEMENTATION ======================================================================
		
		
		// TODO, if the question is new, reload everything
		// TODO D.R.Y.
		// TODO deletion
		
		private var newThreads:Array;
		private var newPosts:Array;
		private var newUsers:Array;
		
		// depends on active question
		private function updateThreads():void {
			MonsterDebugger.trace(null, "Updating threads");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + '/api/questions/' + CivilDebateWall.state.question.id + '/threads', function(response:Object):void {
				newThreads = [];
				for each (var jsonObject:Object in response) {
					// Check for unique
					var id:String = jsonObject['id'];
					
					if (getThreadByID(jsonObject['id']) == null) {
						newThreads.push(new Thread(jsonObject));
					}
				}
				MonsterDebugger.trace(null, "Updated " + newThreads.length + " threads");
				onUpdateThreads();
			});
		}
		
		private function onUpdateThreads():void {
			
			// put the new threads in with our existing threads
			for (var i:int = 0; i < newThreads.length; i++) {
				threads.push(newThreads[i]);
			}
			
			updatePosts();
		}
		
		// depends on threads	
		private function updatePosts():void {
			newPosts = [];
			
			threadsLoaded = 0;
			// loads posts for each thread (not just new ones!)
			for (var i:int = 0; i < threads.length; i++) {
				Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + '/api/threads/' + threads[i].id, onThreadPostsUpdated, threads[i]);
			}
		}
		
		private function onThreadPostsUpdated(response:Object, thread:Thread):void {
			threadsLoaded++;
			
			MonsterDebugger.trace(null, "Updating thread posts " + threadsLoaded + " / " + threads.length + " (" + thread.id + ")");
			
			// push global
			for each (var jsonPost:Object in response['posts']) {
				var id:String = jsonPost['id'];
				
				if (getPostByID(id) == null) {
					var tempPost:Post = new Post(jsonPost, thread);
					newPosts.push(tempPost); // // global comes later
					thread.posts.push(tempPost); // push another reference to thread					
				}
			}
			thread.init();			
			
			if (threadsLoaded == threads.length) {
				onUpdatePosts();
			}
		};					
		
		private function onUpdatePosts():void {
			
			MonsterDebugger.trace(null, newPosts.length + " new posts.");
			
			// put the new posts in with our existing posts 
			for (var i:int = 0; i < newPosts.length; i++) {
				posts.push(newPosts[i]);
			}
			
			updateUsers();
		}
		
		private function updateUsers():void {
			MonsterDebugger.trace(null, "Updating users");

			// TODO only get users active for this question
			// photo queue already instantiated
			
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + '/api/users', function(response:Object):void {
				MonsterDebugger.trace(null, "Updated users");
				newUsers = [];
				for each (var json:Object in response) {
					var id:String = json['id'];
					
					if (getUserByID(id) == null) {
						users.push(new User(json));	
					}
				}
				onUpdateUsers();
			});						
			
		
		}

		
		
		// last batch, images load in background
		private function onUpdateUsers():void {
			
			MonsterDebugger.trace(null, "Loaded " + newUsers.length + " new user");
			
			// put the new posts in with our existing posts 
			for (var i:int = 0; i < newUsers.length; i++) {
				users.push(newUsers[i]);
			}
			
			// fill in user references in posts
			for each (var newPost:Post in newPosts) {
				newPost.initUser();
			}
			
			MonsterDebugger.trace(null, "Loading new images");
			photoQueue.load();			
			
			
			calculateStats();
			onUpdateComplete();
		}	
		
		
		
		// ===============================================================================================================================================================================
		
		
		
		
		
		
		private function calculateStats():void {
			MonsterDebugger.trace(null, "Calculating stats");
			
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
						MonsterDebugger.trace( this, corpusWord + " is boring, skipping it");
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
			MonsterDebugger.trace(null, "Creating user with phone: " + phoneNumber);
			MonsterDebugger.trace(null, "Creating user with username: " + username);			

			// only add phone number if we have it
			var payload:Object = {'username': username};
			if (phoneNumber != "" || phoneNumber != null) payload['phonenumber'] = phoneNumber;
				
			Utilities.postRequestJSON(CivilDebateWall.settings.serverPath + '/api/users', payload, callback);			
		}	
		

		
		public function like(post:Post):void {
			post.likes++;
			Utilities.postRequest(CivilDebateWall.settings.serverPath + '/api/posts/' + post.id + '/like', {}, onLikeUpdated);
			this.dispatchEvent(new Event(LIKE_UPDATE_LOCAL));
		}
		
		public function flag(post:Post):void {
			MonsterDebugger.trace(null, "flagging");
			Utilities.postRequest(CivilDebateWall.settings.serverPath + '/api/posts/' + post.id + '/flag', {}, onFlagUpdated);
			this.dispatchEvent(new Event(FLAG_UPDATE_LOCAL));
		}
		
		private function onLikeUpdated(r:Object):void {
			MonsterDebugger.trace( this, "likes updated server side for post " + r);
			this.dispatchEvent(new Event(LIKE_UPDATE_SERVER));
		}
		
		private function onFlagUpdated(r:Object):void {
			MonsterDebugger.trace(null, "flags updated server side for post " + r);
			this.dispatchEvent(new Event(FLAG_UPDATE_SERVER));
		}		
		
		
		// helpers
		
		public function submitDebate():void {
			// Syncs state up to the cloud

			if (CivilDebateWall.state.userPhoneNumber == null) CivilDebateWall.state.userPhoneNumber = "";
			
			createUser(CivilDebateWall.state.userName, CivilDebateWall.state.userPhoneNumber, function(response:Object):void {
				MonsterDebugger.trace(null, "Created user");
				MonsterDebugger.trace(null, response["id"]);

				
				ObjectUtil.traceObject(response);
				
				// user id,
				CivilDebateWall.state.userID = response["id"];					
				
				// save the images // TODO fix directory structure
				if (CivilDebateWall.state.userImageFull != null) FileUtil.saveJpeg(CivilDebateWall.state.userImageFull, CivilDebateWall.settings.imagePath, CivilDebateWall.state.userID + '-full.jpg');			
				if (CivilDebateWall.state.userImage != null) FileUtil.saveJpeg(CivilDebateWall.state.userImage, CivilDebateWall.settings.imagePath, CivilDebateWall.state.userID + '.jpg');
				
				var payload:Object;

				if (CivilDebateWall.state.userIsDebating) {
					// create and upload new post
					MonsterDebugger.trace(null, "Uploading response post");
					
					// TODO "userInProgress" and "postInProgress" objects in state
					MonsterDebugger.trace(null, "Responding to: " + CivilDebateWall.state.userRespondingTo.id);
					CivilDebateWall.data.uploadResponse(CivilDebateWall.state.activeThread.id, CivilDebateWall.state.userRespondingTo.id, CivilDebateWall.state.userID, CivilDebateWall.state.userOpinion, CivilDebateWall.state.userStance, Post.ORIGIN_KIOSK, onDebateUploaded);
				}
				else {
					// create and upload new thread
					MonsterDebugger.trace(null, "Uploading new thread");				
					CivilDebateWall.data.uploadThread(CivilDebateWall.state.question.id, CivilDebateWall.state.userID, CivilDebateWall.state.userOpinion, CivilDebateWall.state.userStance, Post.ORIGIN_KIOSK, onDebateUploaded);
				}				
				
			});
		}
		
		private function onDebateUploaded(r:Object):void {
			ObjectUtil.traceObject(r);
			MonsterDebugger.trace(null, "submitting");
			
			if (CivilDebateWall.state.userIsDebating) {
				CivilDebateWall.state.userPostID = r["id"];		
			}
			else {
				CivilDebateWall.state.userPostID = r["firstPost"]["id"];				
			}
			
			addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
			update();
		}		
		
		private function onDataUpdate(e:Event):void {
			trace("Post data update!");
			removeEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
			
			// get the thread
			var userThread:Thread = getThreadByPostID(CivilDebateWall.state.userPostID);
			CivilDebateWall.state.userThreadID = userThread.id;
			CivilDebateWall.state.setActiveThread(userThread);
			
			if (CivilDebateWall.state.userIsDebating) {
				// go to comment
				trace("go to comment");
				CivilDebateWall.state.setActivePost(getPostByID(CivilDebateWall.state.userPostID));
				CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.threadView);					
			}
			else {
				// go to thread
				trace("go to thread");
				CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.homeView);			
			}
			
			// clear most user data
			CivilDebateWall.state.clearUser();			
			
		}
		
		
		// ID Lookup
		public function getCategoryById(id:String):Category {
			for each (var category:Category in categories) {
				if (category.id == id) return category;
			}
			return null;	
		}
		
		public function getThreadByPostID(id:String):Thread {
			for each (var thread:Thread in threads) {
				for each (var post:Post in thread.posts) {
					if (post.id == id) return thread;
				}
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