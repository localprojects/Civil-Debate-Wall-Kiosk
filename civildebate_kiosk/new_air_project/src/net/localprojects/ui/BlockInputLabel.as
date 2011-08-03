package net.localprojects.ui {
	import com.bit101.components.Text;
	
	import flash.display.*;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.blocks.*;
	import net.localprojects.elements.*;
	
	
	public class BlockInputLabel extends BlockLabel {
		
		private var mindWidth:Number; // how wide should the feel be if there's nothing in it?
		
		
		public function BlockInputLabel(text:String, textSize:Number, textColor:uint, backgroundColor:uint, bold:Boolean = false, showBackground:Boolean = true) {
			super(text, textSize, textColor, backgroundColor, bold, showBackground);
			postInit();
		}
		
		private function postInit():void {
			textField.type = TextFieldType.INPUT;
			textField.setSelection(0,0);
			//textField.focusRect = false;
		}
		
		// TODO prevent drag selections without clobbering the cursor?
		
		

		
		override protected function afterTweenIn():void {
			stage.focus = textField;
		}
		
		
		// TODO getters and setters
		
		public function getTextField():TextField {
			return textField;
		}
		
		
	}
}