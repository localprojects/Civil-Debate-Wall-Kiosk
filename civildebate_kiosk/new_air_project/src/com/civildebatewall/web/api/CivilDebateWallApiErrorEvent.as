package com.civildebatewall.web.api {
    
    import flash.events.ErrorEvent;

    public class CivilDebateWallApiErrorEvent extends ErrorEvent {
        
        public static const JSON_PARSE_ERROR:String = "jsonParseError";
        
        public function CivilDebateWallApiErrorEvent(type:String, message:String, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type, bubbles, cancelable, message);
        }
        
    }
    
}