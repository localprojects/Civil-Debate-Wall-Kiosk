package com.civildebatewall.web.api {
    
    public interface ICivilDebateWallApi {
        
        function get userOperations():IUserOperations;
        function get questionOperations():IQuestionOperations;
        function get postOperations():IPostOperations;
        
    }
    
}