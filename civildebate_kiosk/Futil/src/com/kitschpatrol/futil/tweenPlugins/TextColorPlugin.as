package com.kitschpatrol.futil.tweenPlugins {
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.kitschpatrol.futil.BlockBase;
	import com.kitschpatrol.futil.TextBlock;
	import com.kitschpatrol.futil.tweenPlugins.BaseColorPlugin;
	
	public class TextColorPlugin extends BaseColorPlugin {
		
		public static const API:Number = 1.0;
		
		
		public function TextColorPlugin() {
			super();
			this.propName = "textColor";
			this.overwriteProps = ["textColor"];
		}
		
		
		
	}
	
}