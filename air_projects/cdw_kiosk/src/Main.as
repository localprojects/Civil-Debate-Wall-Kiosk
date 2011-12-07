package {
	
	
	import com.civildebatewall.CivilDebateWall;

	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.AirFileTarget;
	import org.as3commons.logging.setup.target.MergedTarget;
	import org.as3commons.logging.setup.target.MonsterDebugger3TraceTarget;
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.as3commons.logging.setup.target.mergeTargets;
	
	[SWF(width="1080", height="1920", frameRate="60")]
	public class Main extends Sprite	{
		
		private static const logger:ILogger = getLogger(Main);
		
		public function Main() {
		//MonsterDebugger.initialize(this);
			
		// Normal trace
		//LOGGER_FACTORY.setup = new SimpleTargetSetup(new TraceTarget);	
		
			// in settings:
//			logToTrace: false,
//			logToFile: "",
//			logFilePath: "",
//			logToMonster: "" 
			
			
		// File trace
			var logFilePath:String = "/Users/Mika/Desktop/CDWLogs/";
			

				var monsterTarget:MonsterDebugger3TraceTarget = new MonsterDebugger3TraceTarget();
				var traceTarget:TraceTarget = new TraceTarget();
				var airFileTarget:AirFileTarget = new AirFileTarget(logFilePath + "TheWallKiosk.{date}.log");
				
				//airFileTarget = null;
				
				
				
			LOGGER_FACTORY.setup = new SimpleTargetSetup(mergeTargets(traceTarget, airFileTarget, monsterTarget)); 
	
			logger.info("Testing file logging");
		
			// catch command line args
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);									
		}
		
		private function onInvoke(e:InvokeEvent):void {
			var civilDebateWall:CivilDebateWall = new CivilDebateWall(e.arguments);
			addChild(civilDebateWall);
		}
	}
	
}

