package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class ViewCommentsButton extends BlockText	{
		public function ViewCommentsButton(params:Object=null) {
			super({
				textFont: Assets.FONT_REGULAR,
				textSizePixels: 18,
				backgroundRadius: 8,
				textAlignmentMode: TextAlign.CENTER,
				textColor: 0xffffff,
				paddingLeft: 24,
				buttonMode: true,
				paddingRight: 24,
				width: 614,
				height: 64,
				alignmentPoint: Alignment.CENTER
			});
			
			CivilDebateWall.state.addEventListener(State.ACTIVE_DEBATE_CHANGE, onActiveDebateChange);
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
		}
		
		private function onDown(e:MouseEvent):void {
			// TODO
		}
		
		private function onUp(e:MouseEvent):void {

			
			
			
			
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.threadView);
		}
		
	
		

		private function onActiveDebateChange(e:Event):void {
			backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorMedium;
			
			if (CivilDebateWall.state.activeThread.postCount > 1) {
				// Iteratively truncate the text of the first post to fit in the button
				var firstCommentText:String = CivilDebateWall.state.activeThread.posts[0].text;
				var commentLength:int = firstCommentText.length;
				
				text = wrapText(firstCommentText);
				
				while (textField.numLines > 1) {
					commentLength--;
					text = wrapText(StringUtil.truncate(firstCommentText, commentLength, Char.ELLIPSES));
				}
			}
			else {
				text = "No responses yet. Be the first!";				
			}
		}		
		
		private function wrapText(s:String):String {
		 return Char.LEFT_QUOTE + s + Char.RIGHT_QUOTE + " + " + CivilDebateWall.state.activeThread.postCount + " responses";
		}
		
	}
}