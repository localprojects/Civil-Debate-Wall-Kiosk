package com.civildebatewall.web.api.impl {
    
    import flash.net.URLRequest;
    
    import net.nobien.net.LoadItem;
    import net.nobien.net.LoadItemFactory;
    import net.nobien.net.TextLoadItem;

    public class CustomLoadItemFactory extends LoadItemFactory {
        
        public function CustomLoadItemFactory() {
            
        }
        
        override public function createLoadItem(id:String, request:URLRequest, weight:Number=1, context:Object=null):LoadItem {
            var item:LoadItem = super.createLoadItem(id, request, weight, context);
            if(item != null) return item;
            // Here, if the factory can't determine we're defaulting to a text item
            // This is primarily for JSON resources that don't have file extensions
            return new TextLoadItem(id, request, weight);
        }
        
    }
    
}