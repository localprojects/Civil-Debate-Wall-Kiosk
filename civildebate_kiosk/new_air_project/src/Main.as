package {
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import com.civildebatewall.*;
	import com.civildebatewall.blocks.*;
	import com.civildebatewall.camera.*;
	import com.civildebatewall.elements.*;
	import com.civildebatewall.keyboard.*;
	import com.civildebatewall.ui.*;
	
	[SWF(width="1080", height="1920", frameRate="60")]
	public class Main extends Sprite	{
		
		public function Main() {
			var civilDebateWall:CDW = new CDW();
			addChild(civilDebateWall);
		}
	}
}
