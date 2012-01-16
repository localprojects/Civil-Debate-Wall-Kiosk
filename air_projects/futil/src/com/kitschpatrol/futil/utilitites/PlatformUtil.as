//-------------------------------------------------------------------------------
// Copyright (c) 2012 Eric Mika
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
// 	
// 	The above copyright notice and this permission notice shall be included in 
// 	all copies or substantial portions of the Software.
// 		
// 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// 	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// 	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// 	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT 
// 	OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
// 	THE	USE OR OTHER DEALINGS IN THE SOFTWARE.
//-------------------------------------------------------------------------------

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
