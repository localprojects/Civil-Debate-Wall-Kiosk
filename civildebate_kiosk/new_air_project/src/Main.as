package {
	import flash.display.Sprite;
	import net.localprojects.CDW;
	
	[SWF(width="1080", height="1920", frameRate="60")]
	public class Main extends Sprite	{
		
		public function Main() {
			var civilDebateWall:CDW = new CDW();
			addChild(civilDebateWall);
		}
	}
}
