package com.civildebatewall.web.api {
    
    import flash.events.Event;
    
    public class CivilDebateWallApiEvent extends Event {
        
        public static const GET_QUESTION:String = "getQuestion";
        public static const GET_CATEGORIES:String = "getCategories";
        public static const GET_THREADS:String = "getThreads";
        public static const UPDATE_QUESTION:String = "updateQuestion";
        public static const UPDATE_USER:String = "updateUser";
        
        private var _params:Object;
        
        public function CivilDebateWallApiEvent(type:String, params:Object = null, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type, bubbles, cancelable);
            _params = (params == null) ? {} : params;
        }
        
        public function get params():Object {
            return _params;
        }
        
    }
    
}