package com.civildebatewall.web.api {
    
    public class Thread {
        
        public var id:String;
        public var created:Date;
        public var question:Question;
        public var posts:Vector.<Post>;
        
        public function Thread() {
            
        }
        
    }
    
}