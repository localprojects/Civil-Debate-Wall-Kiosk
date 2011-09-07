package com.civildebatewall.web.api.impl {
    
    import com.adobe.serialization.json.JSON;
    import com.civildebatewall.web.api.Category;
    import com.civildebatewall.web.api.Post;
    import com.civildebatewall.web.api.Question;
    import com.civildebatewall.web.api.Thread;
    import com.civildebatewall.web.api.User;

    public class JsonParser {
        
        public static function parseBoolean(value:int):Boolean {
            return (value == 1) ? true : false;
        }
        
        public static function parseDate(dateStr:String):Date {
            var split:Array = dateStr.split(" ");
            var date:Array = split[0].split("-");
            var time:Array = split[1].split(":");
            var ssmm:Array = time[2].split(".");
            
            var y:String = date[0];
            var m:String = date[1];
            var d:String = date[2];
            var hh:String = time[0];
            var mm:String = time[1];
            var ss:String = ssmm[0];
            
            return new Date(y, m, d, hh, mm, ss);
        }
        
        public static function questionFromJson(data:String):Question {
            return questionFromObject(JSON.decode(data));
        }
        
        public static function questionFromObject(o:Object):Question {
            var q:Question = new Question();
            q.id = o.id;
            q.text = o.text;
            q.category = categoryFromObject(o.category);
            q.author = userFromObject(o.author);
            return q;
        }
        
        public static function categoryFromJson(data:String):Category {
            return categoryFromObject(JSON.decode(data));
        }
        
        public static function categoryFromObject(o:Object):Category {
            var c:Category = new Category()
            c.id = o.id;
            c.name = o.name;
            return c;
        }
        
        public static function categoryListFromJson(data:String):Vector.<Category> {
            return categoryListFromObject(JSON.decode(data));
        }
        
        public static function categoryListFromObject(list:Array):Vector.<Category> {
            var result:Vector.<Category> = new Vector.<Category>();
            for(var i:int = 0; i < list.length; i++) {
                result.push(categoryFromObject(list[i]));
            }
            return result;
        }
        
        public static function threadFromJson(data:String):Thread {
            return threadFromObject(JSON.decode(data));
        }
        
        public static function threadFromObject(o:Object):Thread {
            var t:Thread = new Thread();
            t.id = o.id;
            t.created = parseDate(o.created);
            t.question = questionFromObject(o.question);
            t.posts = postListFromObject(o.posts);
            return t;
        }
        
        public static function threadListFromJson(data:String):Vector.<Thread> {
            return threadListFromObject(JSON.decode(data));
        }
        
        public static function threadListFromObject(list:Array):Vector.<Thread> {
            var result:Vector.<Thread> = new Vector.<Thread>();
            for(var i:int = 0; i < list.length; i++) {
                result.push(threadFromObject(list[i]));
            }
            return result;
        }
        
        public static function userFromJson(data:String):User {
            return userFromObject(JSON.decode(data));
        }
        
        public static function userFromObject(o:Object):User {
            var u:User = new User();
            u.id = o.id;
            u.username = o.username;
            u.firstName = o.firstName;
            u.lastName = o.lastName;
            u.phoneNumber = o.phoneNumber;
            u.email = o.email;
            u.origin = o.origin;
            return u;
        }
        
        public static function userFromObjectList(list:Array):Vector.<User> {
            var result:Vector.<User> = new Vector.<User>();
            for(var i:int = 0; i < list.length; i++) {
                result.push(userFromObject(list[i]));
            }
            return result;
        }
        
        public static function postFromJson(data:String):Post {
            return postFromObject(JSON.decode(data));
        }
        
        public static function postFromObject(o:Object):Post {
            var p:Post = new Post();
            p.id = o.id;
            p.author = userFromObject(o.author);
            p.created = parseDate(o.created);
            p.likes = o.likes;
            p.text = o.text;
            p.yesNo = parseBoolean(o.yesNo);
            return p;
        }
        
        public static function postListFromObject(list:Array):Vector.<Post> {
            var result:Vector.<Post> = new Vector.<Post>();
            for(var i:int = 0; i < list.length; i++) {
                result.push(postFromObject(list[i]));
            }
            return result;
        }
        
    }
    
}