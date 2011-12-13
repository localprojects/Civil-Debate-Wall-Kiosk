package com.civildebatewall.data {

	import com.adobe.crypto.SHA1;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.Utilities;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.civildebatewall.data.containers.Category;
	import com.civildebatewall.data.containers.Post;
	import com.civildebatewall.data.containers.Question;
	import com.civildebatewall.data.containers.Thread;
	import com.civildebatewall.data.containers.User;
	
	public class Data extends EventDispatcher {
		
		private static const logger:ILogger = getLogger(CivilDebateWall);		
		
		public static const DATA_UPDATE_EVENT:String = "dataUpdateEvent";
		public static const DATA_PRE_UPDATE_EVENT:String = "dataPreUpdateEvent";
		
		public static const LIKE_UPDATE_LOCAL:String = "likeUpdateLocal";
		public static const LIKE_UPDATE_SERVER:String = "likeUpdateServer";		
		public static const FLAG_UPDATE_LOCAL:String = "flagUpdateLocal";
		public static const FLAG_UPDATE_SERVER:String = "flagUpdateServer";		
		
		// the data
		public var badWords:Array;
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
		private var updateStartTime:int;
		private var updateIntermediateTime:int;		
		private var newThreads:Array;
		private var newPosts:Array;
		private var newUsers:Array;
		private var changedThreads:Array;
		private var newAndChangedThreads:Array;		
		private var photoLoadStartTime:int;
		
		
		public function Data() {
			super();
			// Hash the secret key (just once at start up)
			CivilDebateWall.settings.secretKeyHash = SHA1.hash(CivilDebateWall.settings.secretKey);			
			logger.info("Hashed secret key: " + CivilDebateWall.settings.secretKeyHash);
			photoQueue = new LoaderMax({name:"portraitQueue", skipFailed: true, onProgress: photoProgressHandler, onComplete: photoCompleteHandler, onError: photoErrorHandler, maxConnections: 6});			
		}
		
		// Run once at startup
		public function load():void {
			logger.info("Starting data load...");
			loadBadWords();
		}
		
		public function onLoadComplete():void {
			logger.info("...Data load complete");
			
			if (CivilDebateWall.state.firstLoad) {
				logger.info("This is first load");
				this.dispatchEvent(new Event(Data.DATA_PRE_UPDATE_EVENT));
				CivilDebateWall.state.setActiveThread(ArrayUtil.randomElement(threads));
			}
			this.dispatchEvent(new Event(Data.DATA_UPDATE_EVENT));
			
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.homeView);
			CivilDebateWall.state.firstLoad = false;
			
			loadImages();
		}

		public function update():void {
			logger.info("Starting data update...");			
			// reset timers
			CivilDebateWall.state.updateQuestionTime = 0;
			CivilDebateWall.state.updateThreadsTime = 0;
			CivilDebateWall.state.updatePostsAndUsersTime = 0;
			CivilDebateWall.state.updateStatsTime = 0;
			CivilDebateWall.state.updateTotalTime = 0;
			
			photoQueue.pause();
			
			updateStartTime = getTimer();
			updateIntermediateTime = getTimer();

			updateQuestion();
		}
		
		public function onUpdateComplete():void {
			CivilDebateWall.state.updateTotalTime = getTimer() - updateStartTime;
			
			logger.info("...Data update complete");
			logger.info("Update time: " + CivilDebateWall.state.getUpdateTimeString());
			
			this.dispatchEvent(new Event(Data.DATA_UPDATE_EVENT));
			
			loadImages();
		}
		
		private function loadImages():void {
			logger.info("Starting photo loading");
			photoLoadStartTime = getTimer();
			photoQueue.load(); // last minute			
		}
		
		// LOAD IMPLEMENTATION ================================================================
		
		private function loadBadWords(onLoad:Function = null):void {
			logger.info("Loading bad words...");
			Utilities.getRequestJSON("http://beta.civildebatewall.com/api/utils/badwords", function(response:Object):void {
				badWords = [];
				for each (var badWord:String in response["words"]) badWords.push(badWord);
				logger.info("...Loaded " + badWords.length + " bad words");
				(onLoad != null) ? onLoad() :	loadBoringWords();
			});
		}
		
		private function loadBoringWords(onLoad:Function = null):void {
			logger.info("Loading boring words...");
			// TODO get this from back end!
			var response:Array = ["not", "for", "this", "and", "are", "but", "your", "has", "have", "the", "that", "they", "with", "its", "it's", "this", "them"];
			boringWords = new Vector.<String>();
			for each (var boringWord:String in response) boringWords.push(boringWord);
			boringWords.fixed = true;
			logger.info("...Loaded " + boringWord.length + " boring words");
			(onLoad != null) ? onLoad() :	loadCategories();
		}
		
		private function loadCategories(onLoad:Function = null):void {
			logger.info("Loading categories...");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/categories", function(response:Object):void {
				categories = [];
				for each (var category:Object in response) categories.push(new Category(category));
				logger.info("...Loaded " + categories.length + " categories");				
				(onLoad != null) ? onLoad() :	loadQuestions();
			});
		}
		
		// depends on categories
		private function loadQuestions(onLoad:Function = null):void {
			logger.info("Loading questions...");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions", function(response:Object):void {
				questions = [];
				for each (var question:Object in response) questions.push(new Question(question));
				logger.info("...Loaded " + questions.length + " questions");	
				(onLoad != null) ? onLoad() :	getActiveQuestion();
			});
		}
		
		// depends on questions
		private function getActiveQuestion(onLoad:Function = null):void {
			logger.info("Loading active question...");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/current", function(response:Object):void {
				CivilDebateWall.state.activeQuestion = getQuestionByID(response.id);
				logger.info("...Loaded active question: " + CivilDebateWall.state.activeQuestion.text);
				CivilDebateWall.state.activeQuestion = CivilDebateWall.state.activeQuestion;
				logger.info("In category: " + CivilDebateWall.state.activeQuestion.category.name);
				(onLoad != null) ? onLoad() :	loadThreads();
			});
		}

		// depends on active question
		private function loadThreads(onLoad:Function = null):void {
			logger.info("Loading threads...");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/" + CivilDebateWall.state.activeQuestion.id + "/threads", function(response:Object):void {
				threads = [];
				for each (var thread:Object in response) threads.push(new Thread(thread));
				logger.info("...Loaded " + threads.length + " threads");
				
				// empty case
				if (threads.length == 0) {
					logger.warn("All threads are empty... going to no opinion view.");					
					CivilDebateWall.kiosk.questionHeaderHome.text = CivilDebateWall.state.activeQuestion.text;
					CivilDebateWall.kiosk.questionHeaderDecision.text = CivilDebateWall.state.activeQuestion.text;
					CivilDebateWall.kiosk.opinionEntryOverlay.question.text = CivilDebateWall.state.activeQuestion.text;
					CivilDebateWall.state.setView(CivilDebateWall.kiosk.noOpinionView);
				}
				else {
					(onLoad != null) ? onLoad() :	loadPostsAndUsers();
				}
			});
		}
			
		// depends on threads	
		private function loadPostsAndUsers():void {
			posts = [];
			users = [];
			threadsLoaded = 0;
			
			// loads posts for each thread
			for (var i:int = 0; i < threads.length; i++) {
				Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/threads/" + threads[i].id, onThreadPostsLoaded, threads[i]);
			}
		}
		
		private function onThreadPostsLoaded(response:Object, thread:Thread):void {
			threadsLoaded++;

			logger.info("Loaded thread post " + threadsLoaded + " / " + threads.length + " (" + thread.id + ")");
			
			for each (var jsonPost:Object in response["posts"]) {
				// create post
				var tempPost:Post = new Post(jsonPost, thread); 				
				CivilDebateWall.data.posts.push(tempPost); // and one reference  globally
				thread.posts.push(tempPost); // push another reference to thread
				logger.info("Creating post " + tempPost.id);
				
				// create user
				var tempUser:User = getUserByID(jsonPost["author"]["id"]);
				if (tempUser == null) {
					tempUser = new User(jsonPost["author"]);
					users.push(tempUser);
					logger.info("Creating user " + tempUser.username + " (" + tempUser.id + ")");
				}
				else {
					logger.info("Already created user " + tempUser.username + " (" + tempUser.id + ")");
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
		
		// UPDATE IMPLEMENTATION ================================================================
			
		// TODO: if the question is new, reload everything
		// TODO: handle deletion
		
		
		private function updateQuestion():void {
			// if the question changed, restart
			updateIntermediateTime = getTimer();
			logger.info("Updating question...");
			
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/current", function(response:Object):void {
				if (response.id != CivilDebateWall.state.activeQuestion.id) {
					logger.warn("...Question changed, need to restart. (From " + CivilDebateWall.state.activeQuestion.id + " to " + response.id + ")");
					logger.error("TODO implement question restart");  // TODO
				}
				else {
					logger.info("...Question unchanged");
					updateThreads();
				}
			});					
		}
		
		
		// depends on active question
		private function updateThreads():void {
			CivilDebateWall.state.updateQuestionTime = getTimer() - updateIntermediateTime;			
			updateIntermediateTime = getTimer();
			
			logger.info("Updating threads...");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/" + CivilDebateWall.state.activeQuestion.id + "/threads", function(response:Object):void {
				newThreads = [];
				changedThreads = [];
				newAndChangedThreads = [];
				for each (var jsonObject:Object in response) {
					// Check for unique
					var id:String = jsonObject["id"];
					var thread:Thread = getThreadByID(jsonObject["id"]); 
					
					if (thread == null) {
						logger.info("New thread " + id);
						newThreads.push(new Thread(jsonObject));
					}
					else if (thread.postCount != jsonObject["postCount"]) {
						// Check for change (based on post count, TODO this still misses edits...)
						logger.info("Thread changed, post count went from " + thread.postCount + " to " + jsonObject["postCount"] + "(" + id + ")");
						changedThreads.push(thread);
					}
				}
				// Merge all changed threads so they're easier to work with below
				newAndChangedThreads = newThreads.concat(changedThreads);
				
				logger.info("...Updated " + newAndChangedThreads.length + " threads");
				
				// nothing to update
				if (newAndChangedThreads.length == 0) {
					logger.info("No threads need updating, skipping to onUpdateComplete()");
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
			threadsLoaded = 0;
			newPosts = [];
			newUsers = [];
			
			// loads posts for each new or changed thread
			for (var i:int = 0; i < newAndChangedThreads.length; i++) {
				Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + "/api/threads/" + newAndChangedThreads[i].id, onThreadPostsUpdated, newAndChangedThreads[i]);
			}
		}
		
		private function onThreadPostsUpdated(response:Object, thread:Thread):void {
			threadsLoaded++;
			
			logger.info("Updating thread posts " + threadsLoaded + " / " + newAndChangedThreads.length + " (" + thread.id + ")");
			
			// push global
			for each (var jsonPost:Object in response["posts"]) {
				var id:String = jsonPost["id"];
				
				if (getPostByID(id) == null) {
					var tempPost:Post = new Post(jsonPost, thread);
					newPosts.push(tempPost); // // global comes later
					thread.posts.push(tempPost); // push another reference to thread
					logger.info("Creating post " + tempPost.id);					
					
					// create user
					var tempUser:User = getUserByID(jsonPost["author"]["id"]);
					if (tempUser == null) {
						tempUser = new User(jsonPost["author"]);
						newUsers.push(tempUser); // global comes later
						logger.info("Creating user " + tempUser.username + " (" + tempUser.id + ")");						
					}
					else {
						logger.info("Already created user " + tempUser.username + " (" + tempUser.id + ")");
					}
					tempPost.user = tempUser;
				}
			}
			thread.init();			
			
			if (threadsLoaded == (newThreads.length + changedThreads.length)) {
				onUpdatePostsAndUsers();
			}
		}
		
		private function onUpdatePostsAndUsers():void {
			logger.info("New posts loaded: " + newPosts.length);
			logger.info("New users loaded: " + newUsers.length);
			
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
			logger.info("Calculating stats");
			
			// most liked debates
			stats = new Stats();			
			
			stats.mostLikedPosts = [];
			posts.sortOn("likes", Array.DESCENDING | Array.NUMERIC);
			for (var i:int = 0; i < Math.min(posts.length, 5); i++) {
				stats.mostLikedPosts.push(posts[i]);
			}
			
			// most debated threads
			stats.mostDebatedThreads = [];
			threads.sortOn("postCount", Array.DESCENDING | Array.NUMERIC);
			threads.sorton
			for (var j:int = 0; j < Math.min(threads.length, 5); j++) {
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
		
		
		// PHOTO LOADERMAX QUEUE CALLBACKS ===================================================
		
		private function photoProgressHandler(event:LoaderEvent):void {
			// Nothing to see here...
		}
		
		private function photoErrorHandler(event:LoaderEvent):void {
			logger.error("Problem loading image:" + event.text);
			// TODO what to do?
		}
		
		private function photoCompleteHandler(event:LoaderEvent):void {
			CivilDebateWall.state.photoLoadTime = getTimer() - photoLoadStartTime;
			logger.info("...Photo loading complete. Load time: " + CivilDebateWall.state.photoLoadTime);			
			
			if (!CivilDebateWall.wallSaver.timeline.active) {
				logger.info("Rebuilding wallsaver face grid");				
				CivilDebateWall.wallSaver.rebuildFaceGrid();
			}
		}			
		
		// CONTENT UPLOAD IMPLEMENTATION ===================================================
		
		public function uploadResponse(threadID:String, responseTo:String, userID:String, opinion:String, stance:String, origin:String, callback:Function):void {
			logger.info("Uploading response");
			var yesno:int = (stance == Post.STANCE_YES) ? 1 : 0;
			var params:Object = {"yesno": yesno, "text": opinion, "responseto": responseTo, "author": userID, "origin": origin};
			Utilities.postRequestJSON(CivilDebateWall.settings.serverPath + "/api/threads/" + threadID + "/posts", params, callback);
		}
					
		public function uploadThread(questionId:String, userID:String, opinion:String, stance:String, origin:String, callback:Function):void {
			logger.info("Uploading thread");
			var yesno:int = (stance == Post.STANCE_YES) ? 1 : 0;
			var params:Object = {"yesno": yesno, "text": opinion, "author": userID, "origin": origin}; 
			Utilities.postRequestJSON(CivilDebateWall.settings.serverPath + "/api/questions/" + questionId + "/threads", params, callback);			
		}		
		
		public function createUser(username:String, phoneNumber:String = "", callback:Function = null):void {
			logger.info("Creating and uploading user: " + username + " with phone number: " + phoneNumber);

			// Only include phone number if we have it
			var payload:Object = {"username": username};
			if (phoneNumber != "") payload["phonenumber"] = phoneNumber;
			
			Utilities.postRequestJSON(CivilDebateWall.settings.serverPath + "/api/users", payload, callback);			
		}	
		
		public function like(post:Post):void {
			logger.info("Uploading like for post " + post.id);
			post.likes++;
			Utilities.postRequest(CivilDebateWall.settings.serverPath + "/api/posts/" + post.id + "/like", {}, onLikeUpdated);
			this.dispatchEvent(new Event(LIKE_UPDATE_LOCAL));
		}
		
		public function flag(post:Post):void {
			logger.info("Uploading flag for post " + post.id);
			Utilities.postRequest(CivilDebateWall.settings.serverPath + "/api/posts/" + post.id + "/flag", {}, onFlagUpdated);
			this.dispatchEvent(new Event(FLAG_UPDATE_LOCAL));
		}
		
		private function onLikeUpdated(r:Object):void {
			logger.info("Likes updated server side for post " + r);
			this.dispatchEvent(new Event(LIKE_UPDATE_SERVER));
		}
		
		private function onFlagUpdated(r:Object):void {
			logger.info("Flags updated server side for post " + r);
			this.dispatchEvent(new Event(FLAG_UPDATE_SERVER));
		}		
		
		
		// COMPOUND HELPERS ===================================================
		
		// Syncs state up to the cloud		
		public function submitDebate():void {
			// Make sure phone nubmer is an emptry string instead of null
			logger.info("Submitting Debate");
			if (CivilDebateWall.state.userPhoneNumber == null) CivilDebateWall.state.userPhoneNumber = "";
			createUser(CivilDebateWall.state.userName, CivilDebateWall.state.userPhoneNumber, onUserCreated);
		}
				
		private function onUserCreated(response:Object):void {
			CivilDebateWall.state.userID = response["id"];					
			
			// save the images
			logger.info("Saving photos to disk...");
			var photoSaveStartTime:int = getTimer();
			
			if (CivilDebateWall.state.userImageFull != null) {
				// Original SLR photo
				FileUtil.saveJpeg(CivilDebateWall.state.userImageFull, CivilDebateWall.settings.imagePath + "original/", CivilDebateWall.state.userID + ".jpg");			
				CivilDebateWall.state.userImageFull.bitmapData.dispose();
				CivilDebateWall.state.userImageFull = null;
			}
			
			if (CivilDebateWall.state.userImage != null) {
				// Kiosk full size face cropped photo
				FileUtil.saveJpeg(CivilDebateWall.state.userImage, CivilDebateWall.settings.imagePath + "kiosk/", CivilDebateWall.state.userID + ".jpg");

				// Web full size face cropped photo
				var webFull:Bitmap = new Bitmap(new BitmapData(550, 650, false));
				webFull.bitmapData.copyPixels(BitmapUtil.scaleDataToFill(CivilDebateWall.state.userImage.bitmapData, 550, 978), new Rectangle(0, 51, 550, 650), new Point(0, 0));
				FileUtil.saveJpeg(webFull, CivilDebateWall.settings.imagePath + "web/", CivilDebateWall.state.userID + ".jpg");
				
				// Web thumbnail size face cropped photo
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
			
			logger.info("...Saving photos took " + (getTimer() - photoSaveStartTime));			
				
			// Finally, upload info
			var payload:Object;
			if (CivilDebateWall.state.userIsDebating) {
				// create and upload new post
				logger.info("Uploading post in response to " + CivilDebateWall.state.userRespondingTo.id + "...");
				// TODO "userInProgress" and "postInProgress" objects in state
				CivilDebateWall.data.uploadResponse(CivilDebateWall.state.activeThread.id, CivilDebateWall.state.userRespondingTo.id, CivilDebateWall.state.userID, CivilDebateWall.state.userOpinion, CivilDebateWall.state.userStance, Post.ORIGIN_KIOSK, onDebateUploaded);
			}
			else {
				// create and upload new thread
				logger.info("Uploading new post to a new thread...");
				CivilDebateWall.data.uploadThread(CivilDebateWall.state.activeQuestion.id, CivilDebateWall.state.userID, CivilDebateWall.state.userOpinion, CivilDebateWall.state.userStance, Post.ORIGIN_KIOSK, onDebateUploaded);
			}
		}
		
		private function onDebateUploaded(r:Object):void {
			logger.info("...Upload complete, got response from server");
			if (CivilDebateWall.state.userIsDebating) {
				CivilDebateWall.state.userPostID = r["id"];		
			}
			else {
				CivilDebateWall.state.userPostID = r["firstPost"]["id"];				
			}
			
			if (CivilDebateWall.data.threads.length == 0) {
				logger.warn("This is the first thread upload for this question, reloading from scratch");
				CivilDebateWall.state.clearUser();
				load();
			}
			else {
				addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate); // Listen for own updates...
				update();
			}
		}		
		
		private function onDataUpdate(e:Event):void {
			logger.info("Data class got post-upload data update... going to whatever changed");
			removeEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
			
			// get the thread
			var userThread:Thread = getThreadByPostID(CivilDebateWall.state.userPostID);
			CivilDebateWall.state.userThreadID = userThread.id;
			CivilDebateWall.state.setActiveThread(userThread);
			
			if (CivilDebateWall.state.userIsDebating) {
				// go to comment
				logger.info("Going to post " + CivilDebateWall.state.userPostID + " in thread " + CivilDebateWall.state.userThreadID);
				CivilDebateWall.state.setActivePost(getPostByID(CivilDebateWall.state.userPostID));
				CivilDebateWall.state.setView(CivilDebateWall.kiosk.threadView);					
			}
			else {
				// go to thread
				logger.info("Going to thread " + CivilDebateWall.state.userThreadID);
				CivilDebateWall.state.setView(CivilDebateWall.kiosk.homeView);			
			}

			// TODO should this happen before view change?
			// clear most user data
			CivilDebateWall.state.clearUser();
		}
		
		
		// CONVENIENCE HELPERS ===================================================		
		
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
		}			

		public function getPostByID(id:String):Post {
			for each (var post:Post in posts) {
				if (post.id == id) return post;
			}
			return null;
		}		
		
		public function getUserByID(id:String):User {
			for each (var user:User in users) {
				if (user.id == id) return user;
			}
			return null;
		}
		
	}
}