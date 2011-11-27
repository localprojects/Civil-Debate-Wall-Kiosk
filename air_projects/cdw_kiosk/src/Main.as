package {
	
	import com.civildebatewall.CivilDebateWall;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.InvokeEvent;

	//import com.demonsters.debugger.MonsterDebugger;	
	
	[SWF(width="1080", height="1920", frameRate="60")]
	public class Main extends Sprite	{
		
		public function Main() {
			//MonsterDebugger.initialize(this);
			//MonsterDebugger.trace(this, "Hello World!");			
			
			// catch command line args
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);									
		}
		
		private function onInvoke(e:InvokeEvent):void {
			
			var civilDebateWall:CivilDebateWall = new CivilDebateWall(e.arguments);
			addChild(civilDebateWall);
		}
	}
	
}
