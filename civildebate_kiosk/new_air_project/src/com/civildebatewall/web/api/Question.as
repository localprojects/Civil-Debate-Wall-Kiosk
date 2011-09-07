package com.civildebatewall.web.api {
    
    public class Question {
        
        public var id:String;
        public var category:Category;
        public var text:String;
        public var author:User;
        
        public function Question() {
            
        }
        
    }
    
}