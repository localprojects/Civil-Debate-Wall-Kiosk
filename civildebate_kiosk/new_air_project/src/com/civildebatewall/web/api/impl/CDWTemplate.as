package com.civildebatewall.web.api.impl {
    
    import com.civildebatewall.web.api.ICivilDebateWallApi;
    import com.civildebatewall.web.api.IPostOperations;
    import com.civildebatewall.web.api.IQuestionOperations;
    import com.civildebatewall.web.api.IUserOperations;
    
    import flash.events.EventDispatcher;
    
    public class CDWTemplate extends EventDispatcher implements ICivilDebateWallApi {
        
        public static const API_URL_BASE:String = "http://www.civildebatewall.com/api/";
        
        private var _apiEndpoint:String;
        private var _userOps:IUserOperations;
        private var _questionOps:IQuestionOperations;
        private var _postOps:IPostOperations;
        
        public function CDWTemplate(apiEndpoint:String = null) {
            _apiEndpoint = (apiEndpoint != null) ? apiEndpoint : API_URL_BASE;
            _userOps = new UserTemplate(this);
            _questionOps = new QuestionTemplate(this);
            _postOps = new PostTemplate(this);
        }
        
        public function get userOperations():IUserOperations {
            return _userOps; 
        }
        
        public function get questionOperations():IQuestionOperations {
            return _questionOps;
        }
        
        public function get postOperations():IPostOperations {
            return _postOps;
        }
        
        public function get apiEndpoint():String {
            return _apiEndpoint;
        }
          
        
    }
    
}