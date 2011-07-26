package net.localprojects {

	import com.greensock.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.events.TweenEvent;
	
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
		
		
		// multiples of these
		private var nametag:Nametag;
		private var opinion:Opinion;
		
		
		
		private function onDatabaseLoaded(e:LoaderEvent):void {
			trace("database loaded");

			
			
			// draw basic layout, wrap this up later
			portrait = new Portrait();			
			portrait.setImage(database.users[database.debates[database.activeDebate].author._id.$oid].portrait);
			portrait.visible = false;
			addChild(portrait);			
			
			header = new Header();
			header.setTarget(30, 30);
			header.visible = false;			
			addChild(header);
			
			
			divider = new Divider();
			divider.setTarget(30, 250);
			divider.visible = false;			
			addChild(divider);
						
			
			
			
			question = new Question();
			question.setTarget(30, 140);
			question.setText(database.questions[database.activeQuestion].question);
			question.visible = false;			
			addChild(question);
						
			
			
			
			stance = new Stance();
			stance.setTarget(275, 280);
			stance.setText(database.debates[database.activeDebate].stance);
			stance.visible = false;
			addChild(stance);			

			nametag = new Nametag();
			nametag.setTarget(275, 410);
			nametag.setText(database.debates[database.activeDebate].author.firstName);
			nametag.visible = false;
			addChild(nametag);
			
			leftQuote = new QuotationMark();
			leftQuote.setStyle(QuotationMark.OPENING);
			leftQuote.setTarget(100, 545);
			leftQuote.setColor(Assets.COLOR_YES_LIGHT);
			leftQuote.visible = false;
			addChild(leftQuote);
			
			rightQuote = new QuotationMark();
			rightQuote.setStyle(QuotationMark.CLOSING);
			rightQuote.setTarget(842, 1643);
			rightQuote.setColor(Assets.COLOR_YES_LIGHT);
			rightQuote.visible = false;
			addChild(rightQuote);
			
			opinion = new Opinion();
			opinion.setTarget(100, 1095);
			opinion.setText(database.debates[database.activeDebate].opinion);
			opinion.visible = false;
			addChild(opinion);
			
			bigButton = new BigButton('Add Your Opinion');
			bigButton.setTarget(438, 1470);
			bigButton.visible = false;
			addChild(bigButton);
			
			statsButton = new IconButton(120, 110, 'STATS', 20, Assets.COLOR_YES_DARK, Assets.statsIcon());
			statsButton.setTarget(100, 1375);
			statsButton.visible = false;
			addChild(statsButton);
			
			likeButton = new CounterButton(120, 110, 'LIKE', 20, Assets.COLOR_YES_DARK, Assets.likeIcon());
			likeButton.setTarget(720, 955);
			likeButton.visible = false;
			addChild(likeButton);
			
			debateButton = new IconButton(150, 130, 'Let\u0027s Debate', 15, Assets.COLOR_YES_DARK, null, true);
			debateButton.setTarget(842, 807);
			debateButton.visible = false;
			addChild(debateButton);
			
			viewDebateButton = new BlockButton(370, 63, '8 People Debated This', 25, Assets.COLOR_YES_DARK, true);
			viewDebateButton.setTarget(590, 1375);
			viewDebateButton.visible = false;
			addChild(viewDebateButton)
			
			debatePicker = new DebatePicker();
			debatePicker.setTarget(0, 1748);
			debatePicker.update(); // syncs with DB
			debatePicker.visible = false;
			addChild(debatePicker);
			
			debateOverlay = new DebateOverlay();
			debateOverlay.setTarget(30, 813);
			debateOverlay.visible = false;
			addChild(debateOverlay);
			
			
			// set view
			//homeView();
			
		}
		
		
		
		
		



		
		// load the views
		private function visify(e:Block):void {
			trace(e);
			e.visible = true;
		}
		
		private function invisify(e:Block):void {
			trace(e);
			e.visible = false;
		}
		

		// TweenMax.fromTo?		

		
		public function homeView():void {
			
			
			viewDebateButton.addEventListener(MouseEvent.CLICK, onViewDebateButtonClick);	
			
			// on
			TweenMax.to(portrait, 1, {onInit: visify, onInitParams: [portrait], x: portrait.targetX, y: portrait.targetY});
			TweenMax.to(header, 1, {onInit: visify, onInitParams: [header], x: header.targetX, y: header.targetY});
			TweenMax.to(divider, 1, {onInit: visify, onInitParams: [divider], x: divider.targetX, y: divider.targetY});
			TweenMax.to(question, 1, {onInit: visify, onInitParams: [question], x: question.targetX, y: question.targetY});
			TweenMax.to(stance, 1, {onInit: visify, onInitParams: [stance], x: stance.targetX, y: stance.targetY});
			TweenMax.to(nametag, 1, {onInit: visify, onInitParams: [nametag], x: nametag.targetX, y: nametag.targetY});
			TweenMax.to(leftQuote, 1, {onInit: visify, onInitParams: [leftQuote], x: leftQuote.targetX, y: leftQuote.targetY});
			TweenMax.to(rightQuote, 1, {onInit: visify, onInitParams: [rightQuote], x: rightQuote.targetX, y: rightQuote.targetY});
			TweenMax.to(opinion, 1, {onInit: visify, onInitParams: [opinion], x: opinion.targetX, y: opinion.targetY});
			TweenMax.to(bigButton, 1, {onInit: visify, onInitParams: [bigButton], x: bigButton.targetX, y: bigButton.targetY});
			TweenMax.to(statsButton, 1, {onInit: visify, onInitParams: [statsButton], x: statsButton.targetX, y: statsButton.targetY});
			TweenMax.to(likeButton, 1, {onInit: visify, onInitParams: [likeButton], x: likeButton.targetX, y: likeButton.targetY});
			TweenMax.to(debateButton, 1, {onInit: visify, onInitParams: [debateButton], x: debateButton.targetX, y: debateButton.targetY, scaleX: 1, scaleY: 1});
			TweenMax.to(viewDebateButton, 1, {onInit: visify, onInitParams: [viewDebateButton], x: viewDebateButton.targetX, y: viewDebateButton.targetY});
			TweenMax.to(debatePicker, 1, {onInit: visify, onInitParams: [debatePicker], x: debatePicker.targetX, y: debatePicker.targetY});
			
			// off
			TweenMax.to(debateOverlay, 1, {onComplete: invisify, onCompleteParams: [debateOverlay], x: debateOverlay.targetX, y: 1920});	
		}
		
		private function onViewDebateButtonClick(e:MouseEvent):void {
			debateOverlayView();
		}		
		
		private function onCloseDebateButtonClick(e:MouseEvent):void {
			homeView();
		}				
		
		public function debateOverlayView():void {
			
			
			// TODO pass click function into button object instead, so we can null or change the action easily...
			viewDebateButton.removeEventListener(MouseEvent.CLICK, onViewDebateButtonClick);
			viewDebateButton.addEventListener(MouseEvent.CLICK, onCloseDebateButtonClick);			
			
			
			// on
			TweenMax.to(portrait, 1, {onInit: visify, onInitParams: [portrait], x: portrait.targetX, y: portrait.targetY});
			TweenMax.to(header, 1, {onInit: visify, onInitParams: [header], x: header.targetX, y: header.targetY});
			TweenMax.to(divider, 1, {onInit: visify, onInitParams: [divider], x: divider.targetX, y: divider.targetY});
			TweenMax.to(question, 1, {onInit: visify, onInitParams: [question], x: question.targetX, y: question.targetY});
			TweenMax.to(stance, 1, {onInit: visify, onInitParams: [stance], x: stance.targetX, y: stance.targetY});
			TweenMax.to(nametag, 1, {onInit: visify, onInitParams: [nametag], x: 590, y: 690});
			TweenMax.to(leftQuote, 1, {onInit: visify, onInitParams: [leftQuote], x: -leftQuote.width, y: leftQuote.targetY});
			TweenMax.to(rightQuote, 1, {onInit: visify, onInitParams: [rightQuote], x: stage.stageWidth, y: rightQuote.targetY});
			TweenMax.to(opinion, 1, {onInit: visify, onInitParams: [opinion], x: opinion.targetX, y: 410});
			TweenMax.to(bigButton, 1, {onInit: visify, onInitParams: [bigButton], x: bigButton.targetX, y: bigButton.targetY});
			TweenMax.to(statsButton, 1, {onInit: visify, onInitParams: [statsButton], x: statsButton.targetX, y: statsButton.targetY});
			TweenMax.to(likeButton, 1, {onInit: visify, onInitParams: [likeButton], x: likeButton.targetX, y: likeButton.targetY});
			TweenMax.to(debateButton, 1, {onInit: visify, onInitParams: [debateButton], x: debateButton.targetX, y: 660, scaleX: 0.75, scaleY: 0.75});
			TweenMax.to(viewDebateButton, 1, {onInit: visify, onInitParams: [viewDebateButton], x: viewDebateButton.targetX, y: 1650});
			TweenMax.to(debatePicker, 1, {onInit: visify, onInitParams: [debatePicker], x: debatePicker.targetX, y: debatePicker.targetY});
			
			TweenMax.to(debateOverlay, 1, {onInit: visify, onInitParams: [debateOverlay], x: debateOverlay.targetX, y: debateOverlay.targetY});			
		}
		
		
		public function pickStanceView():void {
			

			// on
			TweenMax.to(portrait, 1, {onInit: visify, onInitParams: [portrait], x: portrait.targetX, y: portrait.targetY});
			TweenMax.to(header, 1, {onInit: visify, onInitParams: [header], x: header.targetX, y: header.targetY});
			TweenMax.to(divider, 1, {onInit: visify, onInitParams: [divider], x: divider.targetX, y: divider.targetY});
			TweenMax.to(question, 1, {onInit: visify, onInitParams: [question], x: question.targetX, y: question.targetY});
			TweenMax.to(stance, 1, {onInit: visify, onInitParams: [stance], x: stance.targetX, y: stance.targetY});
			TweenMax.to(nametag, 1, {onInit: visify, onInitParams: [nametag], x: 590, y: 690});
			TweenMax.to(leftQuote, 1, {onInit: visify, onInitParams: [leftQuote], x: -leftQuote.width, y: leftQuote.targetY});
			TweenMax.to(rightQuote, 1, {onInit: visify, onInitParams: [rightQuote], x: stage.stageWidth, y: rightQuote.targetY});
			TweenMax.to(opinion, 1, {onInit: visify, onInitParams: [opinion], x: opinion.targetX, y: 410});
			TweenMax.to(bigButton, 1, {onInit: visify, onInitParams: [bigButton], x: bigButton.targetX, y: bigButton.targetY});
			TweenMax.to(statsButton, 1, {onInit: visify, onInitParams: [statsButton], x: statsButton.targetX, y: statsButton.targetY});
			TweenMax.to(likeButton, 1, {onInit: visify, onInitParams: [likeButton], x: likeButton.targetX, y: likeButton.targetY});
			TweenMax.to(debateButton, 1, {onInit: visify, onInitParams: [debateButton], x: debateButton.targetX, y: 660, scaleX: 0.75, scaleY: 0.75});
			TweenMax.to(viewDebateButton, 1, {onInit: visify, onInitParams: [viewDebateButton], x: viewDebateButton.targetX, y: 1650});
			TweenMax.to(debatePicker, 1, {onInit: visify, onInitParams: [debatePicker], x: debatePicker.targetX, y: debatePicker.targetY});
			
			TweenMax.to(debateOverlay, 1, {onInit: visify, onInitParams: [debateOverlay], x: debateOverlay.targetX, y: debateOverlay.targetY});			
		}		
		
		
		
		
		
		


		
		
		
		

		
		
		
		


	}
}