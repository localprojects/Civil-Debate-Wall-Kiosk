package net.localprojects {

	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.events.TweenEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import net.localprojects.blocks.*;
	import net.localprojects.elements.BlockLabel;
	import net.localprojects.elements.BlockParagraph;
	import net.localprojects.ui.*;


	public class CDW extends Sprite {
		
		public static var ref:CDW;
		public static var database:Database;
		public static var dashboard:Dashboard;
		public static var settings:Object;
		
		
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
			
			// load settings from a local JSON file
			settings = Settings.load();
			
			// load the wall state
			database = new Database();
			database.addEventListener(LoaderEvent.COMPLETE, onDatabaseLoaded);			
			database.load();
			
			// background
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			// set up gui overlay
			dashboard = new Dashboard(this.stage, 5, 5);
			dashboard.scaleX = 2;
			dashboard.scaleY = 2;
		}
		
		
		// single copy, never changes
		private var header:Header;
		private var divider:Divider;
		private var answerPrompt:BlockLabel;
		private var smsDisclaimer:BlockParagraph;
		
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
		private var debateOverlay:DebateOverlay;
		private var yesButton:BlockButton;
		private var noButton:BlockButton;
		
		
		
		// multiples of these
		private var nametag:Nametag;
		private var opinion:Opinion;
		
		
		private function onDatabaseLoaded(e:LoaderEvent):void {
			trace("database loaded");
			
			// draw basic layout, wrap this up later
			portrait = new Portrait();
			portrait.setDefaultTweenIn(1, {alpha: 1});
			portrait.setDefaultTweenOut(1, {alpha: 0});			
			addChild(portrait);
			
			header = new Header();
			header.setDefaultTweenIn(1, {x: 30, y: 30});
			header.setDefaultTweenOut(1, {x: 30, y: -header.height});
			addChild(header);
			
			divider = new Divider();
			divider.setDefaultTweenIn(1, {x: 30, y: 250});
			divider.setDefaultTweenOut(1, {x: -divider.width, y: 250});			
			addChild(divider);
			
			question = new Question();
			question.setDefaultTweenIn(1, {x: 30, y: 140});
			question.setDefaultTweenOut(1, {x: -question.width, y: 140});
			question.setText(database.questions[database.activeQuestion].question); // TODO abstract out these ridiculous traverals...			
			addChild(question);
						
			stance = new Stance();
			stance.setDefaultTweenIn(1, {x: 275, y: 280});
			stance.setDefaultTweenOut(1, {x: -stance.width, y: 280});			
			stance.setText(database.debates[database.activeDebate].stance);
			addChild(stance);			

			nametag = new Nametag();
			nametag.setDefaultTweenIn(1, {x: 275, y: 410});
			nametag.setDefaultTweenOut(1, {x: stage.stageWidth, y: 410});			
			nametag.setText(database.debates[database.activeDebate].author.firstName);
			addChild(nametag);
			
			leftQuote = new QuotationMark();
			leftQuote.setDefaultTweenIn(1, {x: 100, y: 545});
			leftQuote.setDefaultTweenOut(1, {x: -leftQuote.width, y: 545});	
			leftQuote.setStyle(QuotationMark.OPENING);
			leftQuote.setColor(Assets.COLOR_YES_LIGHT);
			addChild(leftQuote);
			
			rightQuote = new QuotationMark();
			rightQuote.setDefaultTweenIn(1, {x: 842, y: 1643});
			rightQuote.setDefaultTweenOut(1, {x: stage.stageWidth, y: 1643});				
			rightQuote.setStyle(QuotationMark.CLOSING);
			rightQuote.setColor(Assets.COLOR_YES_LIGHT);
			addChild(rightQuote);
			
			opinion = new Opinion();
			opinion.setDefaultTweenIn(1, {x: 100, y: 1095});
			opinion.setDefaultTweenOut(1, {x: -opinion.width, y: 1095});			
			opinion.setText(database.debates[database.activeDebate].opinion);
			addChild(opinion);
			
			bigButton = new BigButton('Add Your Opinion');
			bigButton.setDefaultTweenIn(1, {x: 438, y: 1470});
			bigButton.setDefaultTweenOut(1, {x: 438, y: 1470}); // TODO need to subclass and override tweenout and in methods because of weird animation???
			addChild(bigButton);
			
			statsButton = new IconButton(120, 110, 'STATS', 20, Assets.COLOR_YES_DARK, Assets.statsIcon());
			statsButton.setDefaultTweenIn(1, {x: 100, y: 1375});
			statsButton.setDefaultTweenOut(1, {x: -statsButton.width, y: 1375});			
			addChild(statsButton);
			
			likeButton = new CounterButton(120, 110, 'LIKE', 20, Assets.COLOR_YES_DARK, Assets.likeIcon());
			likeButton.setDefaultTweenIn(1, {x: 720, y: 955});
			likeButton.setDefaultTweenOut(1, {x: stage.stageWidth, y: 955});			
			addChild(likeButton);
			
			debateButton = new IconButton(150, 130, 'Let\u0027s Debate', 15, Assets.COLOR_YES_DARK, null, true);
			debateButton.setDefaultTweenIn(1, {x: 842, y: 807});
			debateButton.setDefaultTweenOut(1, {x: stage.stageWidth, y: 807});
			addChild(debateButton);
			
			viewDebateButton = new BlockButton(370, 63, '8 People Debated This', 25, Assets.COLOR_YES_DARK, true);
			viewDebateButton.setDefaultTweenIn(1, {x: 590, y: 1375});
			viewDebateButton.setDefaultTweenOut(1, {x: stage.stageWidth, y: 1375});			
			addChild(viewDebateButton)

			debateOverlay = new DebateOverlay();
			debateOverlay.setDefaultTweenIn(1, {x: 30, y: 813});
			debateOverlay.setDefaultTweenOut(1, {x: 30, y: stage.stageHeight});			
			addChild(debateOverlay);			
			
			debatePicker = new DebatePicker();
			debatePicker.setDefaultTweenIn(1, {x: 0, y: 1748});
			debatePicker.setDefaultTweenOut(1, {x: 0, y: stage.stageHeight});			
			debatePicker.update(); // syncs with state
			addChild(debatePicker);
			
			
			answerPrompt = new BlockLabel('Your Answer / Please Select One:', 20, 0xffffff, Assets.COLOR_INSTRUCTION_BACKGROUND, false, true);
			answerPrompt.setDefaultTweenIn(1, {x: 650, y: 1245});
			answerPrompt.setDefaultTweenOut(1, {x: stage.stageWidth, y: 1245});					
			addChild(answerPrompt);
			
			yesButton = new BlockButton(215, 100, 'YES!', 50, Assets.COLOR_YES_LIGHT, false);
			yesButton.setDefaultTweenIn(1, {x: 447, y: 1340});
			yesButton.setDefaultTweenOut(1, {x: 447, y: stage.stageHeight});
			addChild(yesButton);
			
			noButton = new BlockButton(185, 100, 'NO!', 50, Assets.COLOR_NO_LIGHT, false);			
			noButton.setDefaultTweenIn(1.2, {x: 677, y: 1340});
			noButton.setDefaultTweenOut(1.2, {x: 677, y: stage.stageHeight});
			addChild(noButton);
			
			var smsDisclaimerText:String = 'You will receive an SMS notifying you of any future opponents \nwho would like to enter into a debate with you based on your opinion. \nYou can opt out at any time by replying STOP.';
			smsDisclaimer = new BlockParagraph(872, smsDisclaimerText, 25, Assets.COLOR_INSTRUCTION_BACKGROUND, false);
			smsDisclaimer.setDefaultTweenIn(1, {x: 100, y: 1625});
			smsDisclaimer.setDefaultTweenOut(1, {x: 100, y: stage.stageHeight});
			addChild(smsDisclaimer);
			
			// set view
			homeView();
			
		}

		
		
		
		// marks all FIRST LEVEL blocks as inactive
		private function markAllInactive():void {
			for (var i:int = 0; i < this.numChildren; i++) {
				if ((this.getChildAt(i) is BlockBase) && (this.getChildAt(i).visible)) {
					(this.getChildAt(i) as BlockBase).active = false;
				}
			}
		}
		
		private function tweenOutInactive():void {
			for (var i:int = 0; i < this.numChildren; i++) {
				if ((this.getChildAt(i) is BlockBase) && !(this.getChildAt(i) as BlockBase).active) {
					(this.getChildAt(i) as BlockBase).tweenOut();
				}
			}			
		}
		
		public function homeView(...args):void {
			markAllInactive();
			
			// mutations
			portrait.setImage(database.users[database.debates[database.activeDebate].author._id.$oid].portrait);
			
			// set behaviors
			viewDebateButton.setOnClick(debateOverlayView);	
			bigButton.setOnClick(pickStanceView);			
			
			// active blocks
			portrait.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			stance.tweenIn();
			nametag.tweenIn();
			leftQuote.tweenIn();
			rightQuote.tweenIn();
			opinion.tweenIn();
			bigButton.tweenIn();
			statsButton.tweenIn();
			likeButton.tweenIn();
			debateButton.tweenIn();
			viewDebateButton.tweenIn();
			debatePicker.tweenIn();
			
			// override any tween outs here (flagging them as active means they won't get tweened out automatically)
			debateOverlay.tweenOut(1, {y: -debateOverlay.height}); // should overidden animations get re-positioned to their canonical 'out' location?

			// clean up the old based on what's not active
			tweenOutInactive();
		}

		
		public function debateOverlayView(...args):void {
			markAllInactive();			
			
			// mutations
			portrait.setImage(database.users[database.debates[database.activeDebate].author._id.$oid].portrait);
			
			// set behaviors
			viewDebateButton.setOnClick(homeView);
			
			// on
			portrait.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			stance.tweenIn();
			nametag.tweenIn(1, {x: 590, y: 690});
			opinion.tweenIn(1, {y: 410});
			bigButton.tweenIn();
			statsButton.tweenIn(1, {x: -statsButton.width});
			likeButton.tweenIn(1, {x: stage.stageWidth});
			debateButton.tweenIn(1, {y: 660, scaleX: 0.75, scaleY: 0.75});
			viewDebateButton.tweenIn(1, {y: 1650});
			debatePicker.tweenIn();
			
			debateOverlay.tweenIn();

			tweenOutInactive();			
		}
		
		
		public function pickStanceView(...args):void {
			markAllInactive();				
			
			// mutations
			portrait.setImage(Assets.portraitPlaceholder);
			
			// set behaviors
			// TK
			
			// on
			portrait.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			bigButton.tweenIn();
			answerPrompt.tweenIn();
			yesButton.tweenIn();
			noButton.tweenIn();
			smsDisclaimer.tweenIn();
			
			
			tweenOutInactive();				
		}		
		
		
		
		
		
		


		
		
		
		

		
		
		
		


	}
}