package net.localprojects {
	import com.bit101.components.*;
	import flash.display.DisplayObjectContainer;
	
	public class Dashboard extends Window	{
		
		private var logBox:TextArea;		
		
		public function Dashboard(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Dashboard")	{
			super(parent, xpos, ypos, title);
			this.width = 400;
			this.height = 300;
			this.hasMinimizeButton = true;
			logBox = new TextArea(this, 5, 5, "Dashboard ready");
			logBox.width = this.width - 10;
		}
		
		// logs a single line of text to the window
		public function log(s:String):void {
			logBox.text = s + "\n" + logBox.text;
		}		
	}
}