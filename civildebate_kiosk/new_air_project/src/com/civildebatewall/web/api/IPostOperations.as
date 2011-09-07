package com.civildebatewall.web.api {
    
    import flash.events.IEventDispatcher;
    
    public interface IPostOperations extends IEventDispatcher {
        
        function getPost(id:String):void;
        function getThread(id:String):void;
        function createPost(threadId:String, params:Object):void;
        function getByThread(threadId:String):void;
        function flag(id:String):void;
        function like(id:String):void;
        function search():void;
        function update():void;
        
    }
    
}