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
			
			// via http://forums.adobe.com/thread/459761
			public static function getHostName(callback:Function):void {
				if(NativeProcess.isSupported) {
					var OS:String = Capabilities.os.toLocaleLowerCase();
					var file:File;
					
					if (PlatformUtil.isWindows) {
						file = new File("C:\\Windows\\System32\\hostname.exe");
					}
					else if (PlatformUtil.isMac) {
						//Executable in mac
					}
					else if (PlatformUtil.isLinux) {
						//Executable in linux
					}
					
					if (file != null) {
						var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
						nativeProcessStartupInfo.executable = file;
						
						var process:NativeProcess = new NativeProcess();
						process.addEventListener(NativeProcessExitEvent.EXIT, function():void { trace("error"); });
						process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, function(event:ProgressEvent):void {
							var output:String = event.target.standardOutput.readUTFBytes(event.target.standardOutput.bytesAvailable);
							output = StringUtil.stripLinebreaks(output);
							callback(output);
							process.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, this);
						});
						process.start(nativeProcessStartupInfo);
						process.closeInput();
					}
				}
			}
	}
}