/**
 * Contains SMS keyboard and send button.
 */
package org.velluminous.keyboard
{
	import com.localprojects.control.SoundManager;
	import com.localprojects.data.*;
	import com.localprojects.util.Validation;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.velluminous.messaging.Warning;

	public class SMSContainer extends Sprite
	{
		/**
		 * SMS keyboard 
		 */
		private var sms:SMSKeyboard;

		/**
		 * width
		 */
		private var w:Number;

		/**
		 * height
		 */
		private var h:Number;		

		/**
		 * underlying input string
		 */
		private var str:String = "";

		/**
		 * input textfield
		 */
		private var tf:TextField;

		/**
		 * is delete key pressed? 
		 */
		private var del_down:Boolean = false;

		/**
		 * elapsed milliseconds at the time of press
		 */
		private var millisAtPress:Number = 0;

		/**
		 * instructions
		 */
		private var instructions:TextField;

		/**
		 * send button
		 */
		private var sendbutton:KeyButton;

		/**
		 * validation warning 
		 */
		private var warning:Warning;

		/**
		 * sms success
		 */
		private var success:Warning;

		/**
		 * sms waiting for response
		 */
		private var sending:Warning;

		/**
		 * sms error
		 */
		private var error:Warning;

		/**
		 * sms service 
		 */
		private var sms_service:HTTPService;

		/**
		 * Loads sponsorship image.
		 */ 
		private var loader:Loader;

		/**
		 * Has the image been loaded? 
		 */ 
		private var loaded:Boolean = false;

		/**
		 * Textfield.
		 */ 
		private var sponsorfield:TextField;

		/**
		 *	Width of sponsor image. 
		 */ 
		private var img_w:Number = 100;

		/**
		 * Height of sponsor image.
		 */ 
		private var img_h:Number = 60;

		/**
		 * Contains sponsorship image, if any.
		 */ 
		private var sponsorshiplogo:Sprite;

		
		/**
		 * Constructor
		 */
		public function SMSContainer( w:Number, h:Number )
		{
			super();
			this.w = w;
			this.h = h;
			createChildren();	
		}

		/**
		 * reset text
		 */
		public function reset():void
		{
			this.tf.text = this.str = "";
			this.warning.reset();
			this.success.reset();
		}

		/**
		 * create children
		 */
		private function createChildren():void
		{
			sms = new SMSKeyboard();
			sms.x = 90; //this.w * 2/3 ;
			sms.y = 132;//( this.h - sms.height ) / 2 + 20;
			addChild( sms );
			
			instructions = new TextField();
			tf = new TextField();
			
			var format:TextFormat = new TextFormat();
          	format.font = Constants.FONT_FAMILY;
          	format.color = 0x000000;
          	format.size = 24;
          	format.letterSpacing = Constants.FONT_LETTERSPACING;
          	format.leading = Constants.FONT_LEADING;

			var format2:TextFormat = new TextFormat();
          	format2.font = Constants.FONT_FAMILY;
          	format2.color = 0xffffff;
          	format2.size = Constants.INSTRUCTION_SIZE;
          	format2.leading = Constants.FONT_LEADING;
          	format2.letterSpacing = Constants.FONT_LETTERSPACING;
          	
			instructions.embedFonts = true;
			instructions.antiAliasType = AntiAliasType.ADVANCED;
	        instructions.defaultTextFormat     = format2;			
			instructions.text = "Type the phone number where your listings will be sent.\nNote: your carrier may charge a fee for this SMS.\n\nFor international visitors, please type a \"+\" followed by\nyour country code before entering your number.";
			instructions.border = false;
			instructions.background = false;
			instructions.autoSize = TextFieldAutoSize.LEFT;
			instructions.x = sms.width + 130;
			instructions.y = 175; 
			
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
	        tf.defaultTextFormat     = format;			
			tf.text = "";
			tf.border = true;
			tf.background = true;
			tf.borderColor = 0x999999;
			tf.backgroundColor = 0xffffff;
			tf.width = 240;
			tf.height = 60;
			tf.selectable = false;
			
			tf.x = sms.width + 130;
			tf.y = instructions.y + instructions.height + 35;
			sms.y = 180;

			sponsorfield = new TextField();
			sponsorfield.embedFonts = true;
			sponsorfield.antiAliasType = AntiAliasType.ADVANCED;
	        sponsorfield.defaultTextFormat     = format2;			
			sponsorfield.border = false;
			sponsorfield.background = false;
			sponsorfield.autoSize = TextFieldAutoSize.LEFT;
			sponsorfield.width = 520;
			sponsorfield.wordWrap = true;
			sponsorfield.multiline = true;
			sponsorfield.x = sms.width + 130;
			sponsorfield.y = tf.y + tf.height + 40; 
			//sponsorfield.text = DataManager.getInstance().smsSponsorText;	// not using at the moment, but keep added for layout			
			
			addChild( instructions );
			addChild( sponsorfield );
			addChild( tf );
			drawLogo();
			
			sms.addEventListener( KeyButtonEvent.PRESS, handleKeyPress );
			sms.addEventListener( KeyButtonEvent.RELEASE, handleKeyRelease );
			
			this.sendbutton = new KeyButton( "Send", 120, 60 );
			addChild( sendbutton );
			sendbutton.x = tf.x + tf.width + 20;
			sendbutton.y = tf.y;
			sendbutton.addEventListener( KeyButtonEvent.PRESS, handleSendPress );
			
			this.warning = new Warning( "Sorry, that is an invalid number. Please try again.\nIf you are an international visitor, make sure you enter a \"+\"\nfollowed by your country code.", 0xffffff, 0xff3333, this.instructions.width, this.instructions.height );
			addChild( this.warning );
			this.warning.y = this.instructions.y;
			this.warning.x = this.instructions.x;

			this.sending = new Warning( "Sending...", 0xffffff, 0x000000, this.instructions.width, this.instructions.height );
			addChild( this.sending );
			this.sending.y = this.instructions.y;
			this.sending.x = this.instructions.x;

			var successText:String = "Your SMS has been sent.\n\n" + DataManager.getInstance().smsSponsorText;			
			this.success = new Warning( successText, 0xffffff, 0x000000, this.instructions.width, this.instructions.height );
			addChild( this.success );
			this.success.y = this.instructions.y;
			this.success.x = this.instructions.x;

			this.error = new Warning( "There was an error sending your SMS.", 0xffffff, 0xff3333, this.instructions.width, this.instructions.height );
			addChild( this.error );
			this.error.y = this.instructions.y;
			this.error.x = this.instructions.x;
		}
		
		/**
		 * handle send press. validate and post data to service.
		 */
		private function handleSendPress( e:KeyButtonEvent ):void
		{
			var validatedNumber:String = Validation.isValidPhone( this.str );
			if ( validatedNumber != null )
			{
				trace("Number is valid");
				this.sending.reveal();				
				//SoundManager.getInstance().playsound( SoundManager.MAIL_SENT );
				this.tf.text = "";				
				this.str = "";				
				
				var user_id:Number = StateManager.getInstance().read( "current_user_id" ) as Number;				
				
				if ( this.sms_service == null )
				{
					sms_service = new HTTPService();
				}
				sms_service.requestTimeout = 10;
				sms_service.method = "post";
				sms_service.resultFormat = "e4x";
				sms_service.addEventListener("result", handleSMSResult);
				sms_service.addEventListener("fault", handleSMSFault);
				sms_service.url = "http://" + DataManager.getInstance().databaseIP + DataManager.getInstance().phpPath + "sms.php";
				
				var parameters:Object = new Object();
				parameters.user_id = user_id;
				parameters.sms = validatedNumber;
				var date:Date = new Date();	
				parameters.cachebuster = date.getTime();			
				
				sms_service.send(parameters);				
				
			}
			else
			{
				SoundManager.getInstance().playsound( SoundManager.ERROR_BONK );
				this.warning.reveal();								
			}
			//trace( "send | " + isValid );	
		}
		
		/**
		 * handle response from sms service.
		 */
		public function handleSMSResult( event:ResultEvent ) : void 
		{
			var result:XML = event.result as XML;
			
			if ( result && result.toString() == "" )
			{
				this.success.reveal();
				SoundManager.getInstance().playsound( SoundManager.MAIL_SENT );
			}
			else
			{
				SoundManager.getInstance().playsound( SoundManager.ERROR_BONK );
				this.error.reveal();
			}
			trace( "result:" + result );
			
			sms_service.removeEventListener(ResultEvent.RESULT, handleSMSResult);
			sms_service.removeEventListener(FaultEvent.FAULT, handleSMSFault);
			this.sms_service.disconnect();
		}

		/**
		 * handle error
		 */
		public function handleSMSFault(event:FaultEvent):void {
			trace("SMSFault");
			SoundManager.getInstance().playsound( SoundManager.ERROR_BONK );
			this.error.reveal();
		}

		/**
		 * handle key press
		 */
		private function handleKeyPress( e:KeyButtonEvent ):void
		{
			var data:String = e.data;
			trace( "handlekeypress: " + data );
			if ( data == "DEL" )
			{
				this.del_down = true;
				this.millisAtPress = getTimer();
				this.addEventListener( Event.ENTER_FRAME, handleEnter );
			}				
		}
		
		/**
		 * handle press-and-hold delete
		 */
		private function handleEnter( e:Event ):void
		{
			var t:Number = getTimer();
			if ( t - this.millisAtPress > 1000 )
				deleteChar();
		}
		
		/**
		 * handle key release
		 */
		private function handleKeyRelease( e:KeyButtonEvent ):void
		{
			var data:String = e.data;
			switch ( data )
			{
				case "DEL":
				
				break;
				
				default:
				str += ( data.toLowerCase() );
				
			}
			tf.text = parseforphonies(str);
			trace( data );
			if ( this.del_down )
			{
				this.del_down = false;
				this.deleteChar();
				this.removeEventListener( Event.ENTER_FRAME, handleEnter );
			}
		}

		/**
		 * delete character
		 */
		private function deleteChar():void
		{
			trace("deletechar");
			str = str.substring( 0, str.length - 1 );
			
			
			tf.text = parseforphonies( str );
		}

		/**
		 * not used at moment. if the next version of this software offers iphone style phone number formatting,
		 * this could happen here.
		 */
		private function parseforphonies( s:String ):String
		{
			var ret:String = "";
			
			/*
			if ( s.length > 1 && s.length < 11 )
			{
				if ( s.charAt(0) == '1' )
				{
					ret = "1";
					
				}
				else
				{
					
				}
			} 
			else
			{
				ret = s;
			}
			*/
			ret = s;
			return ret;
		}
		
		/**
		 * Draws sponsorship logo, if any.
		 */ 
		private function drawLogo():void
		{
			this.sponsorshiplogo = new Sprite();
			this.sponsorshiplogo.x = this.sponsorfield.x;
			this.sponsorshiplogo.y = this.sponsorfield.y + this.sponsorfield.height + 20;
			this.addChild( this.sponsorshiplogo );
			this.sponsorshiplogo.graphics.clear();
			this.sponsorshiplogo.graphics.lineStyle( 0, 0x000000, 0 );
			//this.sponsorshiplogo.graphics.beginFill( 0xffffff, 0.75 );
			this.sponsorshiplogo.graphics.drawRect( 0, 0, img_w, img_h );
			this.sponsorshiplogo.graphics.endFill(); 
			loadImage();
		}
		
		/**
		 * Loads image. 
		 */ 
		public function loadImage():void
		{
			if ( this.loaded ) return;
			if ( this.loader == null )
			{
				this.loader = new Loader();
			}
			var basepath:String = DataManager.getInstance().featureimageBasePath;
			var logopath:String = basepath + DataManager.getInstance().smsSponsorImage;						
			this.loader.load( new URLRequest( logopath ) );
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}		
		
		
		/**
		 * Handles image load errors.
		 */ 
		private function ioErrorHandler(event:IOErrorEvent):void {
    		trace("ioErrorHandler: " + event);
  		}


		/**
		 * Adds image to screen, when loaded.
		 */ 
		private function onLoaded( e:Event ):void
		{
			this.loaded = true;
//			this.loader.width = this.img_w;
//			this.loader.height = this.img_h;
			this.sponsorshiplogo.addChild( this.loader );
		}
		
		

	}
}