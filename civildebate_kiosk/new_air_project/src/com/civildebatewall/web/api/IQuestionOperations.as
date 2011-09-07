package com.civildebatewall.web.api {
    
    import flash.events.IEventDispatcher;

    public interface IQuestionOperations extends IEventDispatcher {
        
        function createThread(questionId:String, params:Object):void;
        function getCategories():void;
        function getCurrentQuestion():void;
        function getQuestion(id:String):void;
        function getThreads(id:String):void;
        function updateQuestion(id:String, params:Object):void;
        
    }
    
}