package com.civildebatewall.web.api {
    
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    
    public interface IUserOperations extends IEventDispatcher {
        
        function getUser(id:String):void;
        function updateUser(id:String, params:Object):void;
        function addPhotoToUser(userId:String, photo:ByteArray):void;
        
    }
    
}