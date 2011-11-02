package com.kitschpatrol.futil.tweenPlugins {
	import com.greensock.plugins.TweenPlugin;
		
	public class FutilBlockPlugin extends TweenPlugin {

		// TODO update this
		TweenPlugin.activate([AlignmentPointPlugin, BackgroundColorPlugin, BaseColorPlugin, BlockBitmapPlugin, NamedXPlugin, NamedYPlugin, TextColorPlugin, TextContentPlugin]);		
		
		public function FutilBlockPlugin()	{
			// Wrapped to simplify instantiation of all of the Block tween plugins we might want
			super();
		}
	}
}