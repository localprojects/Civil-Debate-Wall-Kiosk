package net.localprojects.ui {
	import fl.motion.Color;
	
	import net.localprojects.*;
	import net.localprojects.blocks.BlockLabel;
	
	
	public class WordButton extends BlockLabel {
		// id
		// ratio
		
		public var _normalDifference:Number;
		private var _threads:Array;
		
		private var interpolatedColor:uint;
		
		public function WordButton(text:String, normalDifference:Number, threads:Array, textSize:Number = 34, textColor:uint=0xffffff, backgroundColor:uint=0x000000, font:String=null, showBackground:Boolean=true)	{
			_normalDifference = normalDifference;
			_threads = threads;
			font = Assets.FONT_REGULAR;
			
			
			super(StringUtils.capitalize(text), textSize, textColor, backgroundColor, font, showBackground);
			
			// set background color
			
			interpolatedColor = Color.interpolateColor(Assets.COLOR_YES_LIGHT, Assets.COLOR_NO_LIGHT, _normalDifference);
			this.setBackgroundColor(interpolatedColor, true);
			
			this.setPadding(14, 15, 11, 15);
		}
		
	}
}