package net.localprojects.blocks {
	import flash.display.DisplayObject;
	
	public class TripleBlock extends BlockBase {
		
		public var left:BlockBase;
		public var center:BlockBase;
		public var right:BlockBase;		
		
		public function TripleBlock()	{
			super();
		}
		
		override public function setText(s:String, instant:Boolean=false):void {
			center.setText(s, instant);
		}
		
		override public function setBackgroundColor(c:uint):void {
			center.setBackgroundColor(c);
		}
		
		public function setLeft(d:BlockBase):void {
			left = d;
			left.x = -1080;
			prepDisplayObject(d);
		}
		
		public function setRight(d:BlockBase):void {
			right = d;
			right.x = 1080;
			prepDisplayObject(d);
		}		
		
		public function setCenter(d:BlockBase):void {
			center = d;
			prepDisplayObject(d);
		}				
		
		private function prepDisplayObject(d:DisplayObject):void {
			addChild(d);
			d.visible = true;
		}
		
		// TODO override on tween finish, and then shuffle?
		
		
	}
}