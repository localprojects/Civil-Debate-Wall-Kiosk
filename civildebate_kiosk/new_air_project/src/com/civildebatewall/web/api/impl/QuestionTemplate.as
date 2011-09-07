package com.civildebatewall.web.api.impl {
    
    import com.civildebatewall.web.api.Category;
    import com.civildebatewall.web.api.CivilDebateWallApiEvent;
    import com.civildebatewall.web.api.IQuestionOperations;
    import com.civildebatewall.web.api.Question;
    
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLVariables;
    
    public class QuestionTemplate extends AbstractOperations implements IQuestionOperations {
        
        private var endpoint:String;
        
        public function QuestionTemplate(cdw:CDWTemplate) {
            super(cdw);
            endpoint = cdw.apiEndpoint + "questions";
        }
        
        public function createThread(questionId:String, parmas:Object):void {
            this.post(endpoint + "/" + questionId, params, CivilDebateWallApiEvent.CREATE_THREAD, JsonParser.threadFromJson); 
        }
        
        public function getQuestion(id:String):void {
            this.get(endpoint + "/" + id, null, CivilDebateWallApiEvent.GET_QUESTION, JsonParser.questionFromJson);
        }
        
        public function getCategories():void {
            this.get(endpoint + "/categories" + id, null, CivilDebateWallApiEvent.GET_CATEGORIES, JsonParser.categoryListFromJson);
        }
        
        public function getCurrentQuestion():void {
            this.get(endpoint + "/current" + id, null, CivilDebateWallApiEvent.GET_QUESTION, JsonParser.questionFromJson);
        }
        
        public function getThreads(id:String):void {
            this.get(endpoint + "/" + id + "/threads", null, CivilDebateWallApiEvent.GET_THREADS, JsonParser.threadListFromJson);
        }
        
        public function updateQuestion(id:String, params:Object):void {
            this.post(endpoint + "/" + question.id, question, CivilDebateWallApiEvent.UPDATE_QUESTION, JsonParser.questionFromJson);
        }
        
    }
    
}