// Searches specific ranges of posts in onLoadComplete() in Data.as;
posts.sortOn("created", Array.NUMERIC);			
var uniqueUsers:Array = [];
			
for each (var post:Post in posts) {				
	if ((post.origin == "kiosk") && (((post.created.date == 19) && (post.created.hours >= 14)) || ((post.created.date == 20) && (post.created.hours < 16)))) {					
		trace(post.user.username + " said "+ post.stance + ": " + "\"" + post.text + "\" at " + dateToTimeString(post.created));
		ArrayUtil.pushIfUnique(uniqueUsers, post.user.username);
	}
}
			
uniqueUsers = uniqueUsers.sort();
			
trace("Users: ");
trace(uniqueUsers);