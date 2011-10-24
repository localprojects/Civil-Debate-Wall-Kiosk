package {
	
	import com.civildebatewall.CDW;
	
	import flash.display.Sprite;
	//import com.demonsters.debugger.MonsterDebugger;	
	
	[SWF(width="1080", height="1920", frameRate="60")]
	public class Main extends Sprite	{
		
		public function Main() {
			//MonsterDebugger.initialize(this);
			//MonsterDebugger.trace(this, "Hello World!");			
			
			var civilDebateWall:CDW = new CDW();
			addChild(civilDebateWall);
		}
	}
	
}
