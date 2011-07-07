package net.localprojects.elements {
	
	// elements are reusable chunks of view that aren't necessarily UI but are components of blocks
	
	import com.greensock.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;

	
	import net.localprojects.*;
	
	public class Face extends Sprite {
		
		protected var authorName:String;
		protected var statement:String;
		protected var tintColor:uint;
		protected var portrait:Bitmap = new Bitmap(new BitmapData(1, 1));
		protected var faceTarget:Point;
		protected var triangleMask:Sprite;
		protected var statementWrapper:Sprite = new Sprite();		
		protected var nameText:TextField = new TextField();
		protected var statementText:TextField = new TextField();		
		protected var nameTextColor:uint;
		protected var statementTextColor:uint;
		
		public function Face() {
			super();
			init();
		}
		
		private function init():void {
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, 1010, 1221);
			graphics.endFill();

		
			// draw the statement
			statementWrapper.graphics.beginFill(0xffffff);
			statementWrapper.graphics.drawRect(0, 0, 1010, 218);
			statementWrapper.graphics.endFill();
			
			// add name text
			var textFormat:TextFormat = new TextFormat();
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.size = 28;
			
			
			nameText.defaultTextFormat = textFormat;
			nameText.embedFonts = true;
			nameText.selectable = false;
			nameText.multiline = true;
			nameText.cacheAsBitmap = false;
			nameText.mouseEnabled = false;			
			nameText.gridFitType = GridFitType.NONE;
			nameText.antiAliasType = AntiAliasType.NORMAL;
			nameText.textColor = nameTextColor;
			nameText.width = 872;
			nameText.wordWrap = true;
			nameText.text = "Placeholder Says:".toUpperCase();
			nameText.x = 56;
			nameText.y = 45;
			
			// add statement text
			textFormat = new TextFormat();
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.size = 24;
			
			statementText.defaultTextFormat = textFormat;
			statementText.embedFonts = true;
			statementText.selectable = false;
			statementText.multiline = true;
			statementText.cacheAsBitmap = false;
			statementText.mouseEnabled = false;			
			statementText.gridFitType = GridFitType.NONE;
			statementText.antiAliasType = AntiAliasType.NORMAL;
			statementText.textColor = statementTextColor;
			statementText.width = 790;
			statementText.wordWrap = true;
			statementText.text = "Placeholder Statement";			
			statementText.x = 56;
			statementText.y = 90;
					
			
			statementWrapper.addChild(nameText);
			statementWrapper.addChild(statementText);
			
			addChild(portrait);
			addChild(statementWrapper);
			 	
			addChild(triangleMask);
			mask = triangleMask;				
		}
		
		public function setStatement(userStatement:String):void {
			statement = userStatement;
			statementText.text = statement;
		}
		
		public function setName(name:String):void {
			authorName = name;
			nameText.text = authorName+ " says:";
		}
		
		public function setPortrait(bitmap:Bitmap, facePosition:Rectangle):void {
			// figure out the positioning
			// TODO grow the portrait until it fits
			//portrait = new Bitmap(bitmap.bitmapData.clone());
			
			portrait.bitmapData.unlock();
			portrait.bitmapData = bitmap.bitmapData.clone();
			portrait.bitmapData.lock();
			
			
			// a backup plan in case the face isn't detected
			if (facePosition == null) {
				// assume the face is in the middle top third of the bitmap
				// TODO correct this to match silhouette
				facePosition = new Rectangle(bitmap.width * .25, bitmap.height * 0.2, bitmap.width * .5, bitmap.height * .55);
			}
			
			var faceCenter:Point = Utilities.centerPoint(facePosition);
			
			portrait.x = faceTarget.x - faceCenter.x;
			portrait.y = faceTarget.y - faceCenter.y;
			
			// color shift the portrait
			var colorAmount:Number = 1;
			var saturationAmount:Number = 0.5;
			var brightnessAmount:Number = 2;
			var contrastAmount:Number = 1;
				
			// use tween max for colorization because it's handy, not because we need to tween
			TweenMax.to(portrait, 0, {colorMatrixFilter:{colorize: tintColor, amount: colorAmount, contrast: contrastAmount, brightness: brightnessAmount, saturation: saturationAmount}});
		}
		
	}
}