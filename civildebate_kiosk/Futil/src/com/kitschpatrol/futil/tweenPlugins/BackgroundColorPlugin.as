package com.kitschpatrol.futil.tweenPlugins {
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.kitschpatrol.futil.BlockBase;
	import com.kitschpatrol.futil.tweenPlugins.BaseColorPlugin;

	public class BackgroundColorPlugin extends BaseColorPlugin {
		
		public static const API:Number = 1.0;
		
		public function BackgroundColorPlugin() {
			super();
			this.propName = "backgroundColor";
		}
	}
	
}