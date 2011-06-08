package net.localprojects {
	
	import flash.display.Bitmap;

	public final class Assets	{
		
		// or run "python embedgen.py "kitten" >> pbcopy"
		[Embed(source = "../assets/cameraSilhouette.png")] private static const cameraSilhouetteClass:Class;
		public static const cameraSilhouette:Bitmap = new cameraSilhouetteClass() as Bitmap;

	}
}