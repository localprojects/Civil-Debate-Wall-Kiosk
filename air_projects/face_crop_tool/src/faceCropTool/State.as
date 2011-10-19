package faceCropTool {
	import flash.filesystem.File;
	import flash.geom.Rectangle;

	public class State	{
		
		public static const SHOW_ORIGINAL:String = "showOriginal";		
		public static const SHOW_CROPPED:String = "showCropped";		
		
		public static var viewMode:String;
		public static var images:Array;
		public static var sourceDirectory:File;
		public static var targetDirectory:File;	
		public static var cachePath:String;
		public static var faceCropRect:Rectangle;
	}
}