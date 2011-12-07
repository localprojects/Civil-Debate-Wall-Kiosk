package com.kitschpatrol.futil.utilitites {
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	public class PlatformUtil	{
		
		public static function get isMac():Boolean {
			return (Capabilities.os.toLocaleLowerCase().indexOf("mac") > -1);				
		}
		
		public static function get isWindows():Boolean {
			return (Capabilities.os.toLocaleLowerCase().indexOf("win") > -1);				
		}
		
		public static function get isLinux():Boolean {
			return (Capabilities.os.toLocaleLowerCase().indexOf("linux") > -1);				
		}
		
		// Based on http://forums.adobe.com/thread/459761
		public static function getHostName(callback:Function):void {
			if (NativeProcess.isSupported) {
				var file:File;
				var args:Vector.<String> = new Vector.<String>();
				
				if (PlatformUtil.isWindows) {
					file = new File("C:\\Windows\\System32\\hostname.exe");
				}
				else if (PlatformUtil.isMac) {
					file = new File("/usr/sbin/scutil");
					args.push("--get");
					args.push("ComputerName");
				}
				else if (PlatformUtil.isLinux) {
					//Executable in linux TODO
				}
				
				if (file != null) {
					var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
					nativeProcessStartupInfo.executable = file;
					nativeProcessStartupInfo.arguments = args;
					
					var process:NativeProcess = new NativeProcess();
					
					process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, function(event:ProgressEvent):void {
						// Discussion on this treatment of anonymous functions: http://www.ultrashock.com/forum/viewthread/121738/
						event.currentTarget.removeEventListener(event.type, arguments.callee);
						var output:String = event.target.standardOutput.readUTFBytes(event.target.standardOutput.bytesAvailable);
						output = StringUtil.stripLinebreaks(output);
						callback(output);
					});
					
					process.start(nativeProcessStartupInfo);
					process.closeInput();
				}
			}
		}
	}
}