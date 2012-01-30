package {		
	
	import com.civildebatewall.CivilDebateWall;
	
	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;
	
	import spark.core.SpriteVisualElement;
	
	public class Main extends SpriteVisualElement	{

		public function Main() {		
			// set up SpriteVisualElement
			percentWidth = 100;
			percentHeight = 100;
			
			// catch command line args
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
			//this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onInvoke(e:InvokeEvent):void {
			var civilDebateWall:CivilDebateWall = new CivilDebateWall(e.arguments);
			addChild(civilDebateWall);
		}
	}
	
}

