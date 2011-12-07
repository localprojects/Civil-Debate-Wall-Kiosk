package com.kitschpatrol.futil.utilitites {
	
	
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	public class ObjectUtil	{
		
		public static function objectLength(o:Object):uint {
			var len:uint = 0;
			for (var item:* in o)
				if (item != "mx_internal_uid")
					len++;
			return len;	
		}
		
		
		public static function getClassName(o:Object):String {
			var fullClassName:String = getQualifiedClassName(o);
			return fullClassName.slice(fullClassName.lastIndexOf("::") + 2);			
		}
		
		
		// via http://www.actionscript.org/forums/showthread.php3?t=158117
		// TODO only works for dynamic objects, need to split for reflection
		// broken?
		public static function traceObject(obj:*, level:int = 0):void {
			trace(toString(obj, level));
		}
		
		// broken?
		public static function toString(obj:*, level:int = 0):String {
			var out:String = "";
			var tabs:String = "";
			
			for (var i:int = 0; i < level; i++)	tabs += "\t";
			
			for (var prop:String in obj) {
				out += tabs + "[" + prop + "] -> " + obj[ prop ] + "\n";
				out += toString(obj[ prop ], level + 1) + "\n";
			}			
			
			return out;
		}
				
		
		public static function setParams(target:*, params:*, strict:Boolean = true):void {
			// set multiple settings in one pass
			for (var key:String in params) {
				if (target.hasOwnProperty(key)) {
					target[key] = params[key];
				}
				else {
					if (strict)	throw new Error("No such property: " + key + " on " + target);
				}
			}
		}
		
		
		// adapted from http://stackoverflow.com/questions/5350907/merging-objects-in-as3
		// if both objects have the same field, object 2 overrides object 1
		public static function mergeObjects(o1:Object, o2:Object):Object {
			var o:Object = {};
			
			for(var p1:String in o1)	{
				o[p1] = o1[p1];								
			}
			
			for(var p2:String in o2)	{
				// overwrite with o2
				o[p2] = o2[p2];				
			}
			
			return o;
		}
		
		public static function cloneObject(o1:Object):Object {
			var bytes:ByteArray = new ByteArray( );
			bytes.writeObject(o1);
			bytes.position = 0;
			return bytes.readObject( );
		}		
		
	}
}