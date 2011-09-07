package com.civildebatewall.web.api.impl {
    
    import com.adobe.serialization.json.JSON;
    import com.civildebatewall.web.api.CivilDebateWallApiEvent;
    import com.civildebatewall.web.api.IUserOperations;
    import com.civildebatewall.web.api.User;
    
    import flash.utils.ByteArray;
    
    public class UserTemplate extends AbstractOperations implements IUserOperations {
        
        private var endpoint:String;
        
        public function UserTemplate(cdw:CDWTemplate) {
            super(cdw);
            endpoint = cdw.apiEndpoint + "users"
        }
        
        public function getUser(id:String):void {
            this.get(endpoint + "/" + id, null, CivilDebateWallApiEvent.GET_USER, JsonParser.userFromJson);
        }
        
        public function updateUser(id:String, params:Object):void {
            this.post(endpoint + "/" + id, params, CivilDebateWallApiEvent.UPDATE_USER, JsonParser.userFromJson);
        }
        
        public function addPhotoToUser(userId:String, photo:ByteArray):void {
            throw new Error("Method not yet implemented");
        }
        
    }
    
}