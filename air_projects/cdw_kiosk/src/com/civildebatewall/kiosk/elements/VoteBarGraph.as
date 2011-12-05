package com.civildebatewall.kiosk.elements {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.blocks.BlockBase;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	public class VoteBarGraph extends BlockBase {

		private var _barPercent:Number;
		
		private var bar:Shape;
		private var arrowWidth:Number = 24;
		private var midPoint:Number = 0;
		private var yesLabel:VoteBarGraphLabel;
		private var noLabel:VoteBarGraphLabel;		
		
		public function VoteBarGraph()	{
			super({
				maxSizeBehavior: MAX_SIZE_CLIPS,
				width: 1022,
				height: 141, 
				backgroundColor: Assets.COLOR_NO_LIGHT			
			});
			
			
						
			bar = new Shape();
			addChild(bar);

			yesLabel = new VoteBarGraphLabel(Assets.getBarGraphYesLabel());
			noLabel = new VoteBarGraphLabel(Assets.getBarGraphNoLabel());
						
			addChild(yesLabel);
			addChild(noLabel);
						
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		private function onDataUpdate(e:Event):void {
			barPercent = CivilDebateWall.data.stats.yesPercent * 100;
		}
		
		public function get barPercent():Number {
			return _barPercent;
		}
		
		public function set barPercent(n:Number):void {
			_barPercent = n; // limit to 0 - 100
			
			var w:Number = Math2.mapClamp(_barPercent, 0, 100, -arrowWidth, width);  // limit to 0 - 100
			midPoint = w + (arrowWidth / 2);

			// redraw the bar
			bar.graphics.clear();
			
			bar.graphics.beginFill(Assets.COLOR_YES_LIGHT);
			bar.graphics.moveTo(-arrowWidth, 0);
			bar.graphics.lineTo(w, 0);
			bar.graphics.lineTo(w + arrowWidth, height / 2);
			bar.graphics.lineTo(w, height);
			bar.graphics.lineTo(-arrowWidth, height );
			bar.graphics.lineTo(-arrowWidth, 0);
			bar.graphics.endFill();
			
			// set label size
			yesLabel.scaleX = Math2.map(_barPercent, 0, 100, yesLabel.minScale, yesLabel.maxScale);
			yesLabel.scaleY = yesLabel.scaleX;
			
			noLabel.scaleX = Math2.map(100 - _barPercent, 0, 100, noLabel.minScale, noLabel.maxScale);
			noLabel.scaleY = noLabel.scaleX;			
			
			// set label positions
			yesLabel.x = midPoint - 25 - yesLabel.width;
			yesLabel.y = (height - yesLabel.height) / 2;
			
			noLabel.x = midPoint + 34;
			noLabel.y = (height - noLabel.height) / 2;
			
			// set limits, don't send the labels off the graph at extremes
			if (yesLabel.x < 20) {
				yesLabel.x = 20;
				noLabel.x = yesLabel.x + yesLabel.width + 25 + 34;
			}
			else if ((noLabel.x + noLabel.width) > (width - 20)) {
				noLabel.x = width - 20 - noLabel.width;
				yesLabel.x = noLabel.x - 25 - 34 - yesLabel.width;
			}
		
			// set label values
			yesLabel.votes = CivilDebateWall.data.stats.postsYes;
			noLabel.votes = CivilDebateWall.data.stats.postsNo;
		}
	}
}