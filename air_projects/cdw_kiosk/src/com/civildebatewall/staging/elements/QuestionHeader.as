package com.civildebatewall.staging.elements {
	
	import com.civildebatewall.CDW;
	import com.civildebatewall.Assets;
	import com.civildebatewall.State;
	import com.civildebatewall.staging.futilProxies.BlockTextTweenable;
	import com.kitschpatrol.futil.blocks.BlockText;
	
	import flash.events.Event;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;
	
	
	//ChangeWatcher.watch(this, "firstName", propertyChangeHandler);	
	
	
	public class QuestionHeader extends BlockTextTweenable	{
		
		// Listen to state changes
		
		public function QuestionHeader() {
			super({text: 'Waiting for question from server',
						 textFont: Assets.FONT_BOLD,
						 textSizePixels: 39,		 
						 textColor: 0x000000,
						 paddingTop: 65,
						 paddingLeft: 100,
						 paddingRight: 100,
						 paddingBottom:76,
						 width: 1080,	
						 height: 312
			});
			

			ChangeWatcher.watch(CDW.data, "question", onQuestionChange);
		}
		
		
		protected function onQuestionChange(e:PropertyChangeEvent):void {
			trace("question changed!");
			this.text = e.property as String;
		}		
		
	}
}