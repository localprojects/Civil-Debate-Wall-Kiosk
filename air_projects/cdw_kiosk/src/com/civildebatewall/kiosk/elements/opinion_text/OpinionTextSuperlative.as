package com.civildebatewall.kiosk.elements.opinion_text {
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	
	import flash.events.Event;
	
	public class OpinionTextSuperlative extends OpinionTextBase	{
		
		public function OpinionTextSuperlative() {
			super();
			width = 444;
			maxHeight = 600; // TODO ?
			
			// size changes
			nameTag.maxWidth = width;			
			nameTag.height = 39;
			nameTag.paddingLeft = 18;
			nameTag.paddingRight = 18;
			nameTag.textSize = 15;
			nameTag.leading = nameTag.height;
			
			opinion.maxWidth = width;
			opinion.paddingTop = 13;
			opinion.paddingBottom = 17;	
			opinion.paddingLeft = 18;
			opinion.paddingRight = 18;			
			opinion.leading = 10;
			opinion.textSize = 15;
		}		
	}
}