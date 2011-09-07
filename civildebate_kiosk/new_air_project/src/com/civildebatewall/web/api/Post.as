package com.civildebatewall.web.api {
    
    public class Post {
        
        public var id:String;
        public var created:Date;
        public var yesNo:Boolean;
        public var likes:int;
        public var text:String;
        public var author:User;
        
        public function Post() {
            
        }
        
    }
    
}