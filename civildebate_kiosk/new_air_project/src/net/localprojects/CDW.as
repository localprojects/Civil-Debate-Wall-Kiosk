package net.localprojects {

	import com.greensock.events.LoaderEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import net.localprojects.blocks.*;
	import net.localprojects.ui.*;	


	public class CDW extends Sprite {
		
		public static var ref:CDW;
		public static var database:Database;
		public static var dashboard:Dashboard;
		
		public function CDW() {
			ref = this;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void {
			// set up the stage
			stage.quality = StageQuality.BEST;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			
			// temporarily squish screen for laptop development (half size)
			stage.nativeWindow.width = 540;
			stage.nativeWindow.height = 960;
			
			// load the wall state
			database = new Database();
			database.addEventListener(LoaderEvent.COMPLETE, onDatabaseLoaded);			
			database.load();
			
			// set up gui overlay
			dashboard = new Dashboard(this.stage, 5, 5);
			dashboard.scaleX = 2;
			dashboard.scaleY = 2;
		}
		
		
		// single copy, never changes
		private var header:Header;
		private var divider:Divider;
		
		// single copy, changes
		private var question:Question;
		private var stance:Stance;
		private var leftQuote:QuotationMark;
		private var rightQuote:QuotationMark;		
		private var portrait:Portrait; // TODO fading
		private var bigButton:BigButton; // TODO class wrap?		
		private var statsButton:IconButton; // TODO class wrap?
		private var likeButton:CounterButton; // TODO class wrap?
		private var debateButton:IconButton; // TODO class wrap?
		private var viewDebateButton:BlockButton; // TODO class wrap?		
		private var debatePicker:DebatePicker;
		
		
		// multiples of these
		private var nametag:Nametag;		
		
		private var opinion:Opinion;
		
		private function onDatabaseLoaded(e:LoaderEvent):void {
			trace("database loaded");
			

			
			// draw basic layout, wrap this up later
			portrait = new Portrait();			
			portrait.setImage(database.users[database.debates[database.activeDebate].author._id.$oid].portrait);
			addChild(portrait);			
			
			header = new Header();
			header.x = 30;
			header.y = 30;			
			addChild(header);
			
			divider = new Divider();
			divider.x = 30;
			divider.y = 250;
			addChild(divider);
			
			question = new Question();
			question.x = 30;
			question.y = 140;
			question.setText(database.questions[database.activeQuestion].question);
			addChild(question);
			
			stance = new Stance();
			stance.x = 275;
			stance.y = 280;
			stance.setText(database.debates[database.activeDebate].stance);
			addChild(stance);			

			nametag = new Nametag();
			nametag.x = 275;
			nametag.y = 410;
			nametag.setText(database.debates[database.activeDebate].author.firstName);
			addChild(nametag);
			
			leftQuote = new QuotationMark();
			leftQuote.setStyle(QuotationMark.OPENING);
			leftQuote.x = 100;
			leftQuote.y = 545;
			leftQuote.setColor(Assets.COLOR_YES_LIGHT);
			addChild(leftQuote);
			
			rightQuote = new QuotationMark();
			rightQuote.setStyle(QuotationMark.CLOSING);
			rightQuote.x = 842;
			rightQuote.y = 1718;
			rightQuote.setColor(Assets.COLOR_YES_LIGHT);
			addChild(rightQuote);
			
			opinion = new Opinion();
			opinion.x = 100;
			opinion.y = 1095;			
			opinion.setText(database.debates[database.activeDebate].opinion);
			addChild(opinion);
			
			bigButton = new BigButton('Add Your Opinion');
			bigButton.x = 438;
			bigButton.y = 1470;
			addChild(bigButton);
			
			statsButton = new IconButton(120, 110, 'STATS', 20, Assets.COLOR_YES_DARK, Assets.statsIcon());
			statsButton.x = 100;
			statsButton.y = 1375;
			addChild(statsButton);
			
			likeButton = new CounterButton(120, 110, 'LIKE', 20, Assets.COLOR_YES_DARK, Assets.likeIcon());
			likeButton.x = 720;
			likeButton.y = 955;
			addChild(likeButton);
			
			debateButton = new IconButton(150, 130, 'Let\u0027s Debate', 15, Assets.COLOR_YES_DARK, null, true);
			debateButton.x = 842;
			debateButton.y = 807;
			addChild(debateButton);
			
			viewDebateButton = new BlockButton(370, 63, '8 People Debated This', 25, Assets.COLOR_YES_DARK, true);
			viewDebateButton.x = 590;
			viewDebateButton.y = 1375;
			addChild(viewDebateButton)
			
			debatePicker = new DebatePicker();
			debatePicker.x = 0; 
			debatePicker.y = 1748;
			debatePicker.update(); // syncs with DB
			addChild(debatePicker);			
			
			
		}
		


		
		
		
		

		
		
		
		


	}
}