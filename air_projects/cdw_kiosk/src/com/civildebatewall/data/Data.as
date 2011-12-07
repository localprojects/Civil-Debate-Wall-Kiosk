package com.civildebatewall.data {

	import com.adobe.crypto.SHA1;
	import com.adobe.serialization.json.*;
	import com.civildebatewall.*;

	import com.greensock.*;
	import com.greensock.easing.Elastic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.utils.getTimer;
	
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
		
		// implementation
		public var photoQueue:LoaderMax;
		private var threadsLoaded:int;		
			
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
			trace("Load complete");
			
			if (CivilDebateWall.state.firstLoad) {
				this.dispatchEvent(new Event(Data.DATA_PRE_UPDATE_EVENT));
				CivilDebateWall.state.setActiveThread(ArrayUtil.randomElement(threads));
			}
			this.dispatchEvent(new Event(Data.DATA_UPDATE_EVENT));
			
			CivilDebateWall.state.firstLoad = false;
			
			trace("Loading new images");			
			photoQueue.load(); // start at the last minute			
		}
		

		// keep track of how long this takes..
		private var updateStartTime:uint;
		private var updateIntermediateTime:uint;
		
		public function update():void {
			// reset timers
			CivilDebateWall.state.updatePostsAndUsersTime = 0;
			CivilDebateWall.state.updateThreadsTime = 0;
			CivilDebateWall.state.updateTotalTime = 0;
			CivilDebateWall.state.updateStatsTime = 0;
			CivilDebateWall.state.updateQuestionTime = 0;
			
			updateStartTime = getTimer();
			updateIntermediateTime = getTimer();
			trace("Updating data");
			updateQuestion();
		}
		
		public function onUpdateComplete():void {
			CivilDebateWall.state.updateTotalTime = getTimer() - updateStartTime;
			
			trace("Update complete");
			this.dispatchEvent(new Event(Data.DATA_UPDATE_EVENT));
			
			trace("Loading new images");			
			photoQueue.load(); // last minute
		}
		
		
		// ====================================================================
		
		// Load Routine

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
			var response:Array = ["not", "for", "this", "and", "are", "but", "your", "has", "have", "the", "that", "they", "with", "its", "it's", "this", "them"];
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
		
		// TODO only load current question?
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
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/" + CivilDebateWall.state.question.id + "/threads", function(response:Object):void {
				threads = [];
				for each (var thread:Object in response) threads.push(new Thread(thread));
				trace ("Loaded " + threads.length + " threads");
				
				// empty case
				if (threads.length == 0) {
					//dispatchEvent(new Event(Data.DATA_PRE_UPDATE_EVENT));
					//dispatchEvent(new Event(Data.DATA_UPDATE_EVENT));
					CivilDebateWall.kiosk.view.questionHeaderHome.text = CivilDebateWall.state.question.text;
					CivilDebateWall.kiosk.view.questionHeaderDecision.text = CivilDebateWall.state.question.text;
					CivilDebateWall.kiosk.view.opinionEntryOverlay.question.text = CivilDebateWall.state.question.text;
					CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.noOpinionView);
				}
				else {
					(onLoad != null) ? onLoad() :	onLoadThreads();
				}
			});
		}
			
		private function onLoadThreads():void {
			loadPostsAndUsers();
		}
			
		// depends on threads	
		private function loadPostsAndUsers(onLoad:Function = null):void {
			posts = [];
			users = [];
			
			// TODO only get users active for this question
			photoQueue = new LoaderMax({name:"portraitQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler, maxConnections: 6});
			
			
			
			threadsLoaded = 0;
			// loads posts for each thread
			for (var i:int = 0; i < threads.length; i++) {
				Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/threads/" + threads[i].id, onThreadPostsLoaded, threads[i]);
			}
		}
		
		
		private function onThreadPostsLoaded(response:Object, thread:Thread):void {
			threadsLoaded++;

			trace("Loaded thread post " + threadsLoaded + " / " + threads.length + " (" + thread.id + ")");
			
			for each (var jsonPost:Object in response["posts"]) {
				// create post
				var tempPost:Post = new Post(jsonPost, thread); 				
				CivilDebateWall.data.posts.push(tempPost); // and one reference  globally
				thread.posts.push(tempPost); // push another reference to thread
				
				// create user
				var tempUser:User = getUserByID(jsonPost["author"]["id"]);
				if (tempUser == null) {
					trace("creating user");
					tempUser = new User(jsonPost["author"]);
					users.push(tempUser);
				}
				else {
					trace("user exists");
				}
				tempPost.user = tempUser;
				
			}
			thread.init();
			
			if (threadsLoaded == threads.length) {
				onLoadUsersAndPosts();
			}
		};					

		// last batch, images load in background
		private function onLoadUsersAndPosts():void {
			calculateStats();
			onLoadComplete();
		}	
		
		
		// Photo Queue Callbacks
		private function progressHandler(event:LoaderEvent):void {
			trace("progress");
			//trace("progress: " + event.target.progress);
		}
		
		private function errorHandler(event:LoaderEvent):void {
			trace("error");
			trace("error occured loading image " + event.target + ": " + event.text);
		}		
		
		private function completeHandler(event:LoaderEvent):void {
			trace("complete");
			trace("Image loading complete.");
			trace("Setting wallsaver face grid.");
			if (!CivilDebateWall.wallSaver.timeline.active) {
				CivilDebateWall.wallSaver.rebuildFaceGrid();
			}
		}				
		
		/// END LOADING IMPLEMENTATION ======================================================================
		
		
		// TODO, if the question is new, reload everything
		// TODO D.R.Y.
		// TODO deletion
		
		private var newThreads:Array;
		private var newPosts:Array;
		private var newUsers:Array;
		
		
		private function updateQuestion():void {
			// if the question changed, restart
			updateIntermediateTime = getTimer();
			trace("Updating question");			
			
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/current", function(response:Object):void {
				if (response.id != CivilDebateWall.state.question.id) {
					trace("Question change!");
					trace("QUESTION CHANGE. NEED TO RESTART.");
					// TODO
				}
				else {
					trace("Question unchanged.");
					updateThreads();
				}
			});					
		}
		
		
		private var changedThreads:Array = [];
		private var newAndChangedThreads:Array = [];
		
		// depends on active question
		private function updateThreads():void {
			CivilDebateWall.state.updateQuestionTime = getTimer() - updateIntermediateTime;			
			updateIntermediateTime = getTimer();
			
			trace("Updating threads");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/" + CivilDebateWall.state.question.id + "/threads", function(response:Object):void {
				newThreads = [];
				changedThreads = [];
				for each (var jsonObject:Object in response) {
					// Check for unique
					var id:String = jsonObject["id"];
					
					var thread:Thread = getThreadByID(jsonObject["id"]); 
					
					if (thread == null) {
						trace("New thread!");
						newThreads.push(new Thread(jsonObject));
					}
					else if (thread.postCount != jsonObject["postCount"]) {
						// if the post cound changed, the thread probably changed
						trace("Thread changed!");
						changedThreads.push(thread);
					}
					
				}
				trace("Updated " + newThreads.length + " threads");
				
				newAndChangedThreads = newThreads.concat(changedThreads);				
				
				// nothing to update
				if (newAndChangedThreads.length == 0) {
					onUpdateComplete();
				}
				else {
					onUpdateThreads();
				}
			});
		}
		
		private function onUpdateThreads():void {
			// put the new threads in with our existing threads
			for (var i:int = 0; i < newThreads.length; i++) {
				threads.push(newThreads[i]);
			}
			
			CivilDebateWall.state.updateThreadsTime = getTimer() - updateIntermediateTime;
			
			updatePostsAndUsers();
		}
		
		// depends on threads	
		private function updatePostsAndUsers():void {
			updateIntermediateTime = getTimer();
			
			newPosts = [];
			newUsers = [];
			
			
			
			threadsLoaded = 0;
			// loads posts for each thread (not just new ones!)
			for (var i:int = 0; i < newAndChangedThreads.length; i++) {
				Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/threads/" + newAndChangedThreads[i].id, onThreadPostsUpdated, newAndChangedThreads[i]);
			}
		}
		
		private function onThreadPostsUpdated(response:Object, thread:Thread):void {
			threadsLoaded++;
			
			trace("Updating thread posts " + threadsLoaded + " / " + threads.length + " (" + thread.id + ")");
			
			// push global
			for each (var jsonPost:Object in response["posts"]) {
				var id:String = jsonPost["id"];
				
				if (getPostByID(id) == null) {
					var tempPost:Post = new Post(jsonPost, thread);
					newPosts.push(tempPost); // // global comes later
					thread.posts.push(tempPost); // push another reference to thread
					
					
					// create user
					var tempUser:User = getUserByID(jsonPost["author"]["id"]);
					if (tempUser == null) {
						trace("creating user");
						tempUser = new User(jsonPost["author"]);
						newUsers.push(tempUser); // global comes later
					}
					else {
						trace("user exists");
					}
					tempPost.user = tempUser;
				}
			}
			thread.init();			
			
			if (threadsLoaded == (newThreads.length + changedThreads.length)) {
				onUpdatePostsAndUsers();
			}
		};					
		
		private function onUpdatePostsAndUsers():void {
			
			trace(newPosts.length + " new posts.");
			trace(newUsers.length + " new users.");
			
			// put the new posts in with our existing posts 
			for (var i:int = 0; i < newPosts.length; i++) {
				posts.push(newPosts[i]);
			}
			
			// and put the new users in with our existing users
			for (var j:int = 0; j < newUsers.length; j++) {
				users.push(newUsers[j]);
			}
			
			CivilDebateWall.state.updatePostsAndUsersTime = getTimer() - updateIntermediateTime;
			
			updateIntermediateTime = getTimer();
			calculateStats();
			CivilDebateWall.state.updateStatsTime = getTimer() - updateIntermediateTime;			
			
			onUpdateComplete();
		}		
		
		// ===============================================================================================================================================================================
		
		
		private function calculateStats():void {
			trace("Calculating stats");
			
			// most liked debates
			stats = new Stats();			
			
			stats.mostLikedPosts = [];
			posts.sortOn("likes", Array.DESCENDING | Array.NUMERIC);
			for (var i:uint = 0; i < Math.min(posts.length, 5); i++) {
				stats.mostLikedPosts.push(posts[i]);
			}
			
			// most debated threads
			stats.mostDebatedThreads = [];
			threads.sortOn("postCount", Array.DESCENDING | Array.NUMERIC);
			threads.sorton
			for (var j:uint = 0; j < Math.min(threads.length, 5); j++) {
				stats.mostDebatedThreads.push(threads[j]);
			}
			
			for each (var post:Post in posts) {
				if (post.stance == Post.STANCE_YES) {
					stats.likesYes += post.likes;
					stats.postsYes++;
				}
				else {
					stats.likesNo += post.likes;				
					stats.postsNo++;
				}
			}
			
			stats.likesTotal = stats.likesYes + stats.likesNo;
			stats.postsTotal = stats.postsYes + stats.postsNo;
			stats.yesPercent = stats.postsYes / stats.postsTotal;
			
			
			// just take the top 50
			stats.frequentWords = [];
			var wordSearch:RegExp = new RegExp(/\w{2,}\w/g); // at least 3 letters long
			var words:Array; 
			var word:String;
			var corpusWord:Word;
			var index:int;
			
			for each (post in posts) {
				words = post.text.toLowerCase().match(wordSearch);
				
				for (var k:int = 0; k < words.length; k++) {
					word = words[k];
					
					if (boringWords.indexOf(word) == -1) {
						
						// is it already in the list?
						index = -1;
						for (var m:int = 0; m < stats.frequentWords.length; m++) {
							if (stats.frequentWords[m].theWord == word) {
								index = m;
								break; 
							}
						}
						
						if (index == -1) {
							// add it to the array
							corpusWord = new Word(word);
							corpusWord.total++;
							(post.stance == Post.STANCE_YES) ? corpusWord.yesCases++ : corpusWord.noCases++;
							corpusWord.posts.push(post);
							stats.frequentWords.push(corpusWord);
						}
						else {
							// increment it	
							stats.frequentWords[index].total++;
							(post.stance == Post.STANCE_YES) ? stats.frequentWords[index].yesCases++ : stats.frequentWords[index].noCases++;
							ArrayUtil.pushIfUnique(stats.frequentWords[index].posts, post);
						}
					}
				}
			}
			
			// sort and trim
			var maxCorpusSize:int = 50;
			stats.frequentWords.sortOn("total", Array.DESCENDING, Array.NUMERIC);
			stats.frequentWords = stats.frequentWords.slice(0, Math.min(maxCorpusSize, stats.frequentWords.length));

			CivilDebateWall.state.setSort(CivilDebateWall.state.sortMode);
		}
		

			
		
		// ====== UPDATES =================
		
		// mutate server
		public function uploadResponse(threadID:String, responseTo:String, userID:String, opinion:String, stance:String, origin:String, callback:Function):void {
			var yesno:uint = (stance == Post.STANCE_YES) ? 1 : 0;
			var params:Object = {"yesno": yesno, "text": opinion, "responseto": responseTo, "author": userID, "origin": origin};
			Utilities.postRequestJSON(CivilDebateWall.settings.serverPath + "/api/threads/" + threadID + "/posts", params, callback);
		}
					
		public function uploadThread(questionId:String, userID:String, opinion:String, stance:String, origin:String, callback:Function):void {
			var yesno:uint = (stance == Post.STANCE_YES) ? 1 : 0;
			var params:Object = {"yesno": yesno, "text": opinion, "author": userID, "origin": origin}; 
			Utilities.postRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/" + questionId + "/threads", params, callback);			
		}		
		
		public function createUser(username:String, phoneNumber:String, callback:Function):void {
			trace("Creating user with phone: " + phoneNumber);
			trace("Creating user with username: " + username);			

			// only add phone number if we have it
			var payload:Object = {"username": username};
			if ((phoneNumber != "") && (phoneNumber != null)) payload["phonenumber"] = phoneNumber;
				
		trace("user post payload: " );
		ObjectUtil.traceObject(payload);
			
			
			Utilities.postRequestJSON(CivilDebateWall.settings.serverPath + "/api/users", payload, callback);			
		}	
		

		
		public function like(post:Post):void {
			post.likes++;
			Utilities.postRequest(CivilDebateWall.settings.serverPath + "/api/posts/" + post.id + "/like", {}, onLikeUpdated);
			this.dispatchEvent(new Event(LIKE_UPDATE_LOCAL));
		}
		
		public function flag(post:Post):void {
			trace("flagging");
			Utilities.postRequest(CivilDebateWall.settings.serverPath + "/api/posts/" + post.id + "/flag", {}, onFlagUpdated);
			this.dispatchEvent(new Event(FLAG_UPDATE_LOCAL));
		}
		
		private function onLikeUpdated(r:Object):void {
			trace("likes updated server side for post " + r);
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

				
				ObjectUtil.traceObject(response);
				
				// user id,
				CivilDebateWall.state.userID = response["id"];					
				
				// save the images
				if (CivilDebateWall.state.userImageFull != null) {
					FileUtil.saveJpeg(CivilDebateWall.state.userImageFull, CivilDebateWall.settings.imagePath + "original/", CivilDebateWall.state.userID + ".jpg");			
					CivilDebateWall.state.userImageFull.bitmapData.dispose();
					CivilDebateWall.state.userImageFull = null;
				}
				if (CivilDebateWall.state.userImage != null) {
					FileUtil.saveJpeg(CivilDebateWall.state.userImage, CivilDebateWall.settings.imagePath + "kiosk/", CivilDebateWall.state.userID + ".jpg");
				}
				
				//
				if (CivilDebateWall.state.userImage != null) {
					
					// web full
					var webFull:Bitmap = new Bitmap(new BitmapData(550, 650, false));
					webFull.bitmapData.copyPixels(BitmapUtil.scaleDataToFill(CivilDebateWall.state.userImage.bitmapData, 550, 978), new Rectangle(0, 51, 550, 650), new Point(0, 0));
					FileUtil.saveJpeg(webFull, CivilDebateWall.settings.imagePath + "web/", CivilDebateWall.state.userID + ".jpg");
					
					// web thumb
					var webThumb:Bitmap = new Bitmap(new BitmapData(71, 96, false));
					webThumb.bitmapData.copyPixels(BitmapUtil.scaleDataToFill(CivilDebateWall.state.userImage.bitmapData, 118, 210), new Rectangle(24, 35, 71, 96), new Point(0, 0));
					FileUtil.saveJpeg(webThumb, CivilDebateWall.settings.imagePath + "thumbnails/", CivilDebateWall.state.userID + ".jpg");
					
					// Clean up
					webFull.bitmapData.dispose();
					webFull = null;
					webThumb.bitmapData.dispose();
					webThumb = null;
					CivilDebateWall.state.userImage.bitmapData.dispose();					
					CivilDebateWall.state.userImage = null;
				}
				
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
			ObjectUtil.traceObject(r);
			trace("submitting");
			
			if (CivilDebateWall.state.userIsDebating) {
				CivilDebateWall.state.userPostID = r["id"];		
			}
			else {
				CivilDebateWall.state.userPostID = r["firstPost"]["id"];				
			}
			
			if (CivilDebateWall.data.threads.length == 0) {
				CivilDebateWall.state.clearUser();
				load();
			}
			else {
				addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
				update();
			}
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