package net.localprojects {
	
	import com.bit101.components.PushButton;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import net.localprojects.pages.Page;	
	
	public class State extends EventDispatcher	{
		
		private var view:Page; // current view
		private var lastView:Page; // previous view
		private var photo:Bitmap; // user portrait
		private var phoneNumber:int;
		private var debates:Array;
		
		public static const VIEW_CHANGE:String = "viewChange";
		
		public function State() {
			super();
			
			// defaults
			view = null;
			lastView = null;			
			photo = null;
			phoneNumber = 0;
			
			
			// also
			// activity timer?
		}
		
		public function setPhoto(_photo:Bitmap):void {
			photo = _photo;
		}
		
		public function getLastView():Page {
			return lastView;
		}
		
		public function getView():Page {
			return view;
		}
		
		public function getPhoto():Bitmap {
			return photo;
		}
		
		public function setView(_view:Page):void {
			lastView = view;
			view = _view;
			this.dispatchEvent(new Event(VIEW_CHANGE));
		}
		
		
	}
}