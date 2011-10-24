package faceCropTool.faceImage
{
	import flash.events.Event;
	
	public class FaceImageEvent extends Event
	{
		public function FaceImageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}