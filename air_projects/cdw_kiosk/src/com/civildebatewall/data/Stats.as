package com.civildebatewall.data {
	public class Stats {
		
		public var likesTotal:int;
		public var likesYes:int;
		public var likesNo:int;
		
		public var postsTotal:int;
		public var postsYes:int;
		public var postsNo:int;
		
		public var mostDebatedThreads:Array;
		public var mostLikedPosts:Array;
		public var frequentWords:Array;
		public var yesPercent:Number; // normalized yes / total		
		
		public function Stats()	{

		}
	}
}