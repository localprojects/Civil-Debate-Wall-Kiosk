package {
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import net.localprojects.*;
	import net.localprojects.blocks.*;
	import net.localprojects.camera.*;
	import net.localprojects.elements.*;
	import net.localprojects.keyboard.*;
	import net.localprojects.ui.*;
	
	[SWF(width="1080", height="1920", frameRate="60")]
	public class Main extends Sprite	{
		
		public function Main() {
			var civilDebateWall:CDW = new CDW();
			addChild(civilDebateWall);
		}
	}
}
