package com.civildebatewall.wallsaver.sequences {

	import com.greensock.TimelineMax;
	
	public interface ISequence {
		function getTimelineIn():TimelineMax;
		function getTimelineOut():TimelineMax;
		function getTimeline():TimelineMax;		
	}
}