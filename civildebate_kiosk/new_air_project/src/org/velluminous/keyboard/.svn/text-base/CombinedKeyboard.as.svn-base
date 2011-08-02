/**
 * Alphanumeric keyboard that allows one to switch between qwerty and numeric 
 */
package org.velluminous.keyboard
{
	import com.localprojects.control.Puck;
	import com.localprojects.control.SoundManager;
	import com.localprojects.data.*;
	import com.localprojects.util.Validation;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.velluminous.messaging.Warning;
	
	public class CombinedKeyboard extends Sprite
	{
		/**
		 * Alphabetic keyboard 
		 */
		private var ak:AlphabeticKeyboard;

		/**
		 * Numeric keyboard
		 */
		private var nk:NumericKeyboard;

		/**
		 * Textfield displays key input
		 */
		private var tf:TextField;

		/**
		 * width
		 */
		private var w:Number = Constants.INFO_UNDERLAY_WIDTH * 1.4;

		/**
		 * height 
		 */
		private var h:Number = Constants.INFO_UNDERLAY_HEIGHT* 1.2;

		/**
		 * Underlying string for input text
		 */
		private var str:String;

		/**
		 * Is the delete key down?
		 */
		private var del_down:Boolean = false;

		/**
		 * Elapsed milliseconds at time of press
		 */
		private var millisAtPress:Number = 0;

		/**
		 * Instructional text
		 */
		private var instructions:TextField;

		/**
		 * Send Button
		 */
		private var sendbutton:KeyButton;

		/**
		 * Email service
		 */
		private var email_service:HTTPService;

		/**
		 * Lock puck service
		 */
		private var lock_service:HTTPService;

		/**
		 * Unlock puck service
		 */
		private var unlock_service:HTTPService;

		/**
		 * Email Warning
		 */
		private var warning:Warning;

		/**
		 * Email Success
		 */
		private var success:Warning;

		/**
		 * Email is sending
		 */
		private var sending:Warning;

		/**
		 * Email error
		 */
		private var error:Warning;

		/**
		 * Locking the puck...
		 */
		private var locking:Warning;

		/**
		 * Puck lock success
		 */
		private var locked:Warning;

		/**
		 * Puck lock error 
		 */
		private var lockerror:Warning;

		/**
		 * Puck is unlocking...
		 */
		private var unlocking:Warning;

		/**
		 * Puck unlock success
		 */
		private var unlocked:Warning;

		/**
		 * Puck unlock error
		 */
		private var unlockerror:Warning;

		/**
		 * Constructor
		 */
		public function CombinedKeyboard()
		{
			super();
			str = new String();
			createChildren();
		}
		
		/**
		 * Create children
		 */
		private function createChildren():void
		{
			ak = new AlphabeticKeyboard();
			nk = new NumericKeyboard();
			instructions = new TextField();
			tf = new TextField();
			
			var format:TextFormat = new TextFormat();
          	format.font = Constants.FONT_FAMILY;
          	format.color = 0x000000;
          	format.size = 28;
          	format.letterSpacing = Constants.FONT_LETTERSPACING;
          	
          	format.leading = 18 - 11;
			var format2:TextFormat = new TextFormat();
          	format2.font = Constants.FONT_FAMILY;
          	format2.color = 0xffffff;
          	format2.size = Constants.INSTRUCTION_SIZE;
          	format2.leading = Constants.FONT_LEADING;
          	format2.letterSpacing = Constants.FONT_LETTERSPACING;

			instructions.embedFonts = true;
			instructions.antiAliasType = AntiAliasType.ADVANCED;
	        instructions.defaultTextFormat     = format2;			
			instructions.text = "Type the email address where your listings will be sent.";
			instructions.border = false;
			instructions.background = false;
			instructions.autoSize = TextFieldAutoSize.CENTER;
			instructions.x = (( this.w - instructions.width ) / 2) - 25; 
			
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
	        tf.defaultTextFormat     = format;			
			tf.text = "";
			tf.border = true;
			tf.background = true;
			tf.borderColor = 0x999999;
			tf.backgroundColor = 0xffffff;
			tf.width = Constants.INFO_UNDERLAY_WIDTH - 10;
			tf.height = 60;
			tf.selectable = false;
			
			tf.y = instructions.y + instructions.height + 45;
			tf.x = 50;
			
			ak.x = ( w - ak.width ) / 2;
			nk.x = ( w - nk.width ) / 2;
			
			ak.y = tf.y + tf.height + 40;
			nk.y = ak.y;
			
			addChild( instructions );
			addChild( tf );
			addChild( ak );	
			
			ak.addEventListener( KeyButtonEvent.PRESS, handleKeyPress );
			nk.addEventListener( KeyButtonEvent.PRESS, handleKeyPress );
			
			ak.addEventListener( KeyButtonEvent.RELEASE, handleKeyRelease );
			nk.addEventListener( KeyButtonEvent.RELEASE, handleKeyRelease );
			
			this.sendbutton = new KeyButton( "Send", 140, 60 );
			addChild( sendbutton );
			sendbutton.x = tf.x + tf.width + 20;
			sendbutton.y = tf.y;
			sendbutton.addEventListener( KeyButtonEvent.PRESS, handleSendPress );

			this.warning = new Warning( "Sorry, that's not a valid email.", 0xffffff, 0xff3333, this.instructions.width, this.instructions.height );
			addChild( this.warning );
			this.warning.y = this.instructions.y;
			this.warning.x = this.instructions.x;

			this.sending = new Warning( "Sending...", 0xffffff, 0x000000, this.instructions.width, this.instructions.height );
			addChild( this.sending );
			this.sending.y = this.instructions.y;
			this.sending.x = this.instructions.x;

			this.success = new Warning( "Your email has been sent.", 0xffffff, 0x000000, this.instructions.width, this.instructions.height );
			addChild( this.success );
			this.success.y = this.instructions.y;
			this.success.x = this.instructions.x;

			this.error = new Warning( "There was an error sending your email.", 0xffffff, 0xff3333, this.instructions.width, this.instructions.height );
			addChild( this.error );
			this.error.y = this.instructions.y;
			this.error.x = this.instructions.x;

			this.locking = new Warning( "Locking...", 0xffffff, 0x000000, this.instructions.width, this.instructions.height );
			addChild( this.locking );
			this.locking.y = this.instructions.y;
			this.locking.x = this.instructions.x;
			
			this.locked = new Warning( "This disc has been locked.", 0xffffff, 0x000000, this.instructions.width, this.instructions.height );
			addChild( this.locked );
			this.locked.y = this.instructions.y;
			this.locked.x = this.instructions.x;
			
			this.lockerror = new Warning( "There was an error locking the disc.", 0xffffff, 0x000000, this.instructions.width, this.instructions.height );
			addChild( this.lockerror );
			this.lockerror.y = this.instructions.y;
			this.lockerror.x = this.instructions.x;


			this.unlocking = new Warning( "Unlocking...", 0xffffff, 0x000000, this.instructions.width, this.instructions.height );
			addChild( this.unlocking );
			this.unlocking.y = this.instructions.y;
			this.unlocking.x = this.instructions.x;
			
			this.unlocked = new Warning( "This disc has been unlocked.", 0xffffff, 0x000000, this.instructions.width, this.instructions.height );
			addChild( this.unlocked );
			this.unlocked.y = this.instructions.y;
			this.unlocked.x = this.instructions.x;
			
			this.unlockerror = new Warning( "There was an error unlocking the disc.", 0xffffff, 0x000000, this.instructions.width, this.instructions.height );
			addChild( this.unlockerror );
			this.unlockerror.y = this.instructions.y;
			this.unlockerror.x = this.instructions.x;

		}
		
		/**
		 * Handle Send
		 */
		private function handleSendPress( e:KeyButtonEvent ):void
		{
			//trace( "[" + this.str + "] [" +  DataManager.getInstance().lockpuckpassword + "]" );
			if ( this.str.toLowerCase() == DataManager.getInstance().lockpuckpassword.toLowerCase() )
			{
				var p:Puck = StateManager.getInstance().read( "current_puck" ) as Puck;
				this.tf.text = "";	
				this.str = "";	
				if ( !p.locked )
					lockpuck();
				else
					unlockpuck();
				return;
			}
			var isValid:Boolean = Validation.isValidEmail( this.str );
			if ( isValid )
			{
				// wire up here
				this.sending.reveal();
				this.tf.text = "";
								
				var user_id:Number = StateManager.getInstance().read( "current_user_id" ) as Number;
				
				if ( this.email_service == null )
					email_service = new HTTPService();
					
				/*
				// this works too
				email_service.url = "http://" + DataManager.getInstance().databaseIP + DataManager.getInstance().phpPath + "email.php?user_id=" + user_id + "&email=" + this.str;
				email_service.method = "GET";
				email_service.resultFormat = "e4x";
				email_service.send();
				*/
				email_service.requestTimeout = 10;
				email_service.url = "http://" + DataManager.getInstance().databaseIP + DataManager.getInstance().phpPath + "email.php";
				email_service.method = "POST";
				email_service.resultFormat = "e4x";
				email_service.addEventListener("result", handleEmailResult);
				var parameters:Object = new Object();
				parameters.user_id = user_id;
				parameters.email = this.str;
				var date:Date = new Date();	
				parameters.cachebuster = date.getTime();							
				email_service.send(parameters);
				this.str = "";				
				
				var fake_time:Timer = new Timer(4000,1);
				fake_time.addEventListener(TimerEvent.TIMER,this.fakeSuccess);
				fake_time.start();
			}
			else
			{
				SoundManager.getInstance().playsound( SoundManager.ERROR_BONK );
				this.warning.reveal();								
			}
			trace( "send | " + isValid );	
		}
		
		
		private function fakeSuccess(event:Event):void {		
									
			trace("CombinedKeyboard.fakeSuccess");									
			this.success.reveal();
			SoundManager.getInstance().playsound( SoundManager.MAIL_SENT );
				
		}
		
		/**
		 * Lock the puck
		 */
		private function lockpuck():void
		{
			this.locking.reveal();
			var user_id:Number = StateManager.getInstance().read( "current_user_id" ) as Number;
			
			if ( this.lock_service == null )
				lock_service = new HTTPService();
			lock_service.url = "http://" + DataManager.getInstance().databaseIP + DataManager.getInstance().phpPath + "lock.php";
			lock_service.method = "POST";
			lock_service.resultFormat = "e4x";
			lock_service.addEventListener("result", handleLockResult);
			var parameters:Object = new Object();
			parameters.user_id = user_id;
			parameters.locked = 1;
			lock_service.send(parameters);
		}
		
		/**
		 * handle response from the lock service
		 */
		private function handleLockResult(event:ResultEvent):void
		{
			lock_service.removeEventListener(ResultEvent.RESULT, handleLockResult);
			var result:XML = event.result as XML;
			
			if ( result.text() == "success" )
			{
				var p:Puck = StateManager.getInstance().read( "current_puck" ) as Puck;
				p.locked = true;
				SoundManager.getInstance().playsound( SoundManager.MAIL_SENT );
				this.locked.reveal();
			}
			else
			{
				SoundManager.getInstance().playsound( SoundManager.ERROR_BONK );
				this.lockerror.reveal();								
			}
		}
		
		
		/**
		 * unlock the puck
		 */
		private function unlockpuck():void
		{
			this.unlocking.reveal();
			var user_id:Number = StateManager.getInstance().read( "current_user_id" ) as Number;
				
			if ( this.unlock_service == null )
				unlock_service = new HTTPService();
			unlock_service.url = "http://" + DataManager.getInstance().databaseIP + DataManager.getInstance().phpPath + "lock.php";
			unlock_service.method = "POST";
			unlock_service.resultFormat = "e4x";
			unlock_service.addEventListener("result", handleUnlockResult);
			var parameters:Object = new Object();
			parameters.user_id = user_id;
			parameters.locked = 0;
			unlock_service.send(parameters);
		}
		
		/**
		 * handle the response from the unlock service
		 */
		private function handleUnlockResult(event:ResultEvent):void
		{
			unlock_service.removeEventListener(ResultEvent.RESULT, handleUnlockResult);
			var result:XML = event.result as XML;
			
			if ( result.text() == "success" )
			{
				var p:Puck = StateManager.getInstance().read( "current_puck" ) as Puck;
				p.locked = false;
				SoundManager.getInstance().playsound( SoundManager.MAIL_SENT );
				this.unlocked.reveal();
			}
			else
			{
				SoundManager.getInstance().playsound( SoundManager.ERROR_BONK );
				this.unlockerror.reveal();								
			}
		}
		
		
		/**
		 * handle the response from the email service
		 */
		private function handleEmailResult(event:ResultEvent):void
		{
			email_service.removeEventListener(ResultEvent.RESULT, handleEmailResult);
			var result:XML = event.result as XML;
			
			// no point, will always fail because of long timeouts (but will work)
			/*
			if ( result.text() == "success" )
			{
				SoundManager.getInstance().playsound( SoundManager.MAIL_SENT );
				this.success.reveal();
			}
			else
			{
				SoundManager.getInstance().playsound( SoundManager.ERROR_BONK );
				this.error.reveal();
				trace("---- EMAIL FAILED ----");								
			}
			*/
		}

		
		/**
		 * handle keypress
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
			else
			{
				
			}
		}
		
		/**
		 * Handle press-and-hold delete
		 */
		private function handleEnter( e:Event ):void
		{
			var t:Number = getTimer();
			if ( t - this.millisAtPress > 1000 )
				deleteChar();
		}
		
		/**
		 * Handle key release
		 */
		private function handleKeyRelease( e:KeyButtonEvent ):void
		{
			var data:String = e.data;
			
			switch ( data )
			{
				case ".?123":
				this.removeChild( ak );
				this.addChild( nk );
				break;
				
				case "ABC":
				this.removeChild( nk );
				this.addChild( ak );
				break;
				
				case "space":
				str += " ";
				break;
				
				case "DEL":
				break;
				
				default:
				str += ( data.toLowerCase() );
				
			}
			tf.text = str;
			
			trace( data );
			if ( this.del_down )
			{
				this.del_down = false;
				this.deleteChar();
				this.removeEventListener( Event.ENTER_FRAME, handleEnter );
			}
		}

		/**
		 * clear the input field
		 */
		public function reset():void
		{
			this.tf.text = this.str = "";
			this.warning.reset();
			this.success.reset();
		}

		/**
		 * 
		 */
		private function deleteChar():void
		{
			trace("deletechar");
			str = str.substring( 0, str.length - 1 );
			tf.text = str;
		}
		
	}
}