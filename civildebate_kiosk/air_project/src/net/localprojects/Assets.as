package net.localprojects {
	
	import flash.display.Bitmap;

	public final class Assets	{
		
		// or run "python embedgen.py "kitten" >> pbcopy"
		[Embed(source = "../assets/cameraSilhouette.png")] private static const cameraSilhouetteClass:Class;
		public static const cameraSilhouette:Bitmap = new cameraSilhouetteClass() as Bitmap;

		[Embed(source = "../assets/zuckerberg.jpg")] private static const zuckerbergClass:Class;
		public static const zuckerberg:Bitmap = new zuckerbergClass() as Bitmap;
		
		[Embed(source = "../assets/obama.jpg")] private static const obamaClass:Class;
		public static const obama:Bitmap = new obamaClass() as Bitmap;
		
	}
}