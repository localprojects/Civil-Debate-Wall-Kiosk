package com.civildebatewall.kiosk.elements.question_text {
	
	public class QuestionHeaderHome extends QuestionHeaderBase {
		
		public function QuestionHeaderHome() {
			super();
			
			// this is the big home question
			setParams({
				width: 1080,
				height: 313,
				textSize: 39,
				leading: 29,
				paddingTop: 65,
				paddingRight: 100,
				paddingBottom: 65,
				paddingLeft: 100,
				lineWidth: 982,
				backgroundAlpha: 0.85
			});

			drawLines();
		}
		
	}
}