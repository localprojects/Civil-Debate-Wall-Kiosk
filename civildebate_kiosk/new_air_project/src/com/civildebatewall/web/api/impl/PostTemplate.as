package com.civildebatewall.web.api.impl {
    
    import com.civildebatewall.web.api.IPostOperations;
    
    public class PostTemplate extends AbstractOperations implements IPostOperations {
        
        public function PostTemplate(cdw:CDWTemplate) {
            super(cdw);
        }
        
        public function getPost(id:String):void {
        }
				
				public function getThread(id:String):void {
					
				}
				
        
        public function getByThread(threadId:String):void {
        }
				
				public function createPost(threadId:String, params:Object):void {
					
				}
        
        public function flag(id:String):void {
        }
        
        public function like(id:String):void {
        }
        
        public function search():void {
        }
        
        public function update():void {
        }
				
        
    }
    
}