package {
	import flash.display.Sprite;
	import net.localprojects.CivilDebateWall;
	
	[SWF(width="1080", height="1920", frameRate="60")]
	public class Main extends Sprite	{
		
		public function Main() {
			var civilDebateWall:CivilDebateWall = new CivilDebateWall();
			addChild(civilDebateWall);
		}
	}
}
