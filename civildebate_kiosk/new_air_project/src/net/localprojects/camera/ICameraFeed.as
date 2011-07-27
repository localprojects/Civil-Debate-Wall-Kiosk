package net.localprojects.camera {
	import flash.events.IEventDispatcher;
	
	public interface ICameraFeed extends IEventDispatcher {
		function start():void;
		function stop():void;
		function pause():void;
		function play():void;		
	}
}