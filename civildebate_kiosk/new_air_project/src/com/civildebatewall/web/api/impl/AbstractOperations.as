package com.civildebatewall.web.api.impl {
    
    import com.adobe.serialization.json.JSONParseError;
    import com.civildebatewall.web.api.CivilDebateWallApiErrorEvent;
    import com.civildebatewall.web.api.CivilDebateWallApiEvent;
    
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    
    public class AbstractOperations extends EventDispatcher {
        
        protected var cdw:CDWTemplate
        
        public function AbstractOperations(cdw:CDWTemplate) {
            this.cdw = cdw;
        }
        
        protected function initEventListeners(loader:URLLoader, successEvent:String, parseFunction:Function):URLLoader {
            var self:AbstractOperations = this;
            loader.addEventListener(Event.COMPLETE, 
                function(event:Event):void {
                    var data:String = URLLoader(event.target).data;
                    try {
                        self.dispatchEvent(new CivilDebateWallApiEvent(successEvent, parseFunction(data)));
                    } catch(e:Error) {
                        self.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.message))
                    }
                }, false, 0, true
            );
            loader.addEventListener(IOErrorEvent.IO_ERROR,
                function(event:IOErrorEvent):void {
                    self.dispatchEvent(event.clone());
                }, false, 0, true
            );
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                function(event:IOErrorEvent):void {
                    self.dispatchEvent(event.clone());
                }, false, 0, true
            );
            return loader;
        }
        
        protected function createLoader(request:URLRequest, successEvent:String, parseFunction:Function):URLLoader {
            return initEventListeners(new URLLoader(request), successEvent, parseFunction);
        }
        
        protected function createRequest(url:String, method:String, params:Object = null):URLRequest {
            var request:URLRequest = new URLRequest(url);
            request.method = method;
            if(params != null) {
                var vars:URLVariables = new URLVariables();
                for(var key:String in params) {
                    vars[key] = params[key];
                }
                request.data = params;
            }
            return request;
        }
        
        public function get(url:String, params:Object, successEvent:String, parseFunction:Function):URLLoader {
            return createLoader(
                createRequest(url, URLRequestMethod.GET, params), successEvent, parseFunction 
            );
        }
        
        public function post(url:String, params:Object, successEvent:String, parseFunction:Function):URLLoader {
            return createLoader(
                createRequest(url, URLRequestMethod.POST, params), successEvent, parseFunction
            );
        }
        
    }
    
}