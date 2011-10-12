package com.kitschpatrol.futil.utilitites {
	import com.kitschpatrol.futil.Math2;
	
	public class ArrayUtil {

		public static function removeItemFromArray(a:Array, theItem:*):void{
			for(var i:int=0; i < a.length;i++){
				if(a[i]==theItem){
					a.splice(i,1);
					i-=1;
				}
			}
		}
		
		public static function getRandomElement(a:Array):* {
			return a[Math2.randRange(0, a.length - 1)];
		}		
		
		
		public static function contains(needle:Object, haystack:Array):Boolean {
			return (haystack.indexOf(needle) > -1);
		}		
		
		
		// returns a copy
		public static function shuffle(a:Array):Array {
			var a2:Array = [];
			while (a.length > 0) {
				a2.push(a.splice(Math.round(Math.random() * (a.length - 1)), 1)[0]);
			}
			return a2;
		}		
		
		// adapted from weave
		public static function flatten(a:Array, a2:Array = null):Array	{
			if (a2 == null)
				a2 = [];
			if (a == null)
				return a2;
			
			for (var i:int = 0; i < a.length; i++)
				if (a[i] is Array)
					flatten(a[i], a2);
				else
					a2.push(a[i]);
			return a2;
		}
		
		

	}
}