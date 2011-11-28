package com.civildebatewall.data {
	import com.adobe.crypto.SHA1;
	import com.adobe.serialization.json.*;
	import com.civildebatewall.*;
	import com.greensock.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
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
		
		public var question:Question;
		public var users:Array;
		public var threads:Array;
		public var posts:Array;
		
		// stats
		public var mostDebatedThreads:Array;
		public var mostLikedPosts:Array;
		public var frequentWords:Array;
		public var likeTotals:Object;
		public var stanceTotals:Object;
		public var yesPercent:Number; // normalized yes / total
		public var stats:Object; // container
		
		
		// a bunch of boring 3+ letter words (TODO get from server)
		private const boringWords:Array = ["not", "for", "this", "and", "are", "but", "your", "has", "have", "the", "that", "they", "with"];		
			
		public function Data() {
			super();
			
			// Hash the secret key (just once)
			CivilDebateWall.settings.secretKeyHash = SHA1.hash(CivilDebateWall.settings.secretKey);
			
			clear();
		}
		
		private function clear():void {
			question = null;
			users = [];
			threads = [];
			posts = [];
			stats = {};			
			mostDebatedThreads = [];
			mostLikedPosts = [];
			frequentWords = [];
			likeTotals = {};
			stanceTotals = {};			
		}
		
		public function load():void {
			// load the question
			clear();
			
			trace('Loading question');
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + '/api/questions/current', onQuestionReceived);						
		}
		
		
		private function onQuestionReceived(r:Object):void {
			trace('Question Loaded, getting users');
			
			// Store the question
			question = new Question(r);
		
			// Get users
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + '/api/users', onUsersReceived);			
		}
		
		
		public var photoQueue:LoaderMax = new LoaderMax({name:"portraitQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
			
		private function onUsersReceived(jsonUserObjects:Object):void {
			for each (var jsonUserObject:Object in jsonUserObjects) {
				users.push(new User(jsonUserObject));
			}
			
			photoQueue.load();
		}
			
		private function progressHandler(event:LoaderEvent):void {
			//trace("progress: " + event.target.progress);
		}
		
		private function errorHandler(event:LoaderEvent):void {
			trace("error occured with " + event.target + ": " + event.text);
		}		
		
		private function completeHandler(event:LoaderEvent):void {
			//trace(event.target + " is complete!");
			trace("loading threads");
			Utilities.getRequestJSON(CivilDebateWall.settings.serverPath + '/api/questions/' + question.id + '/threads', onThreadsReceived);
		}
		
		public var postQueue:LoaderMax = new LoaderMax({name:"postQueue", onProgress:progressHandler, onComplete:onPostsLoaded, onError:errorHandler});		
		
		private function onThreadsReceived(r:Object):void {
			for each (var jsonThread:Object in r) {
				threads.push(new Thread(jsonThread));
			}
			
			
			
			postQueue.load();
		}
		
		private function onPostsLoaded(event:LoaderEvent):void {
			trace("posts loaded, generating stats");
	
			// get stats
			// Use client side for this stuff for now
			
			// most liked debates
			posts.sortOn('likes', Array.DESCENDING | Array.NUMERIC);
			for (var i:uint = 0; i < Math.min(posts.length, 5); i++) {
				mostLikedPosts.push(posts[i]);
			}
			
			// most debated threads
			threads.sortOn('postCount', Array.DESCENDING | Array.NUMERIC);
			threads.sorton
			for (var j:uint = 0; j < Math.min(threads.length, 5); j++) {
				mostDebatedThreads.push(threads[j]);
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
						
			likeTotals = {'yes': yesLikes, 'no': noLikes};
			stanceTotals = {'yes': yesPosts, 'no': noPosts};
				
			// get this from server instead
			// build the corpus
			var wordSearch:RegExp = new RegExp(/\w*\w/g);
			var corpus:Array = [];
			for each (post in posts) {
				corpus = ArrayUtil.mergeUnique(corpus, post.text.toLowerCase().match(wordSearch));
			}
			
			
			frequentWords = [];
			for each (var corpusWord:String in corpus) {
				// filter out small words
				if (corpusWord.length > 2) {
					// filter out boring words
					// ignore boring words
					if (boringWords.indexOf(corpusWord) > - 1) {
						trace(corpusWord + " is boring, skipping it");
					}
					else {
						frequentWords.push(new Word(corpusWord));
					}
				}
			}
			
			
			// find frequency, store in json for easy plug-in to future server side implementation
			for each (var word:Word in frequentWords) {
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
			
			frequentWords.sortOn('total', Array.DESCENDING, Array.NUMERIC);
			
			
			trace("Stance totals: ");
			ObjectUtil.traceObject(stanceTotals);
			
			yesPercent = stanceTotals.yes / (stanceTotals.yes + stanceTotals.no); 
			
			// end stats
			

			// now sort by date
			
			// TODO go back to sorting based on state?
			CivilDebateWall.state.setSort(CivilDebateWall.state.sortMode);
			
			
			//threads.sortOn('created', Array.DESCENDING | Array.NUMERIC); // newest first // Is this working?
			//posts.sortOn('created', Array.DESCENDING); // newest first			
				
			// Updated!
			this.dispatchEvent(new Event(Data.DATA_PRE_UPDATE_EVENT));
			this.dispatchEvent(new Event(Data.DATA_UPDATE_EVENT));
		}		

		
		
		
//		
//		// STUBS
//		public function getQuestionText():String {
//			return question['question'];
//		}
//		
//		public function getActivePortrait():Bitmap {
//			return getDebateAuthorPortrait(CDW.state.activeDebate);
//		}
//		
//		public function getDebateAuthor(debateID:String):String {
//			return debates[debateID]['author']['_id']['$oid'];
//		}
//		
//		public function getDebateAuthorPortrait(debateID:String):Bitmap {
//			return portraits[getDebateAuthor(debateID)]; 
//		}
//		
//		public function getPortrait(authorID:String):Bitmap {
//			return portraits[authorID]; 
//		}		
//		
//		public function getDebateAuthorName(debateID:String):String {
//			return Utilities.toTitleCase(debates[debateID]['author']['firstName']); 
//		}		
//		
//		public function getOpinion(debateID:String):String {
//			return debates[debateID]['opinion'];
//		}
//		
//		public function getStance(debateID:String):String {
//			return debates[debateID]['stance'];
//		}
//		

//		
//		public function getCommentCount(debateID:String):int {
//			var i:int = 0;
//			
//			for (var commentID:String in debates[debateID]['comments']) {
//				trace('comment ID: ' + commentID);
//				i++;
//			}
//			return i;
//		}		
//		
//		
//		public function cloneDebateAuthorPortrait(debateID:String):Bitmap {
//			return new MetaBitmap(portraits[getDebateAuthor(debateID)].bitmapData.clone());
//		}
//		
//		// returns list of IDs of most debated posts
//		public function getMostDebatedList():Array {
//			var mostDebated:Array = [];
//			
//			for each (var row:Object in stats['mostDebatedOpinions']) {
//				mostDebated.push(row['id']);
//			}
//			
//			return mostDebated;
//		}
//		
//		// returns list of IDs of most debated posts
//		public function getMostLikedList():Array {
//			var mostLiked:Array = [];
//			
//			for each (var row:Object in stats['mostLikedDebates']) {
//				mostLiked.push(row['id']);
//			}
//			
//			return mostLiked;
//		}		
//		
//		
		
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
			Utilities.postRequest(CivilDebateWall.settings.serverPath + '/api/posts/' + post.id + '/flag', {}, onFlagUpdated);
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
		
		

		// NEW STUFF
		
		// User stuff
		
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
		
		public function getUserByPhoneNumber(phoneNumber:String):User {
			phoneNumber = phoneNumber.replace('+1', '');
			
			for each (var user:User in users) {
				if (user.phoneNumber == phoneNumber) return user;
			}
			return null;
			// todo else raise error
		}		
		
	}
}