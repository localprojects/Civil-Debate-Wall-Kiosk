/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.legacy {
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	
	import flash.display.Sprite;
	
	
	public class OldBlockBase extends Sprite {
		

		public function OldBlockBase() {
			super();
			active = false;
			visible = false;
		}				
		
		public function setText(s:String, instant:Boolean = false):void {
			// override me
		}		
		
		public function setBackgroundColor(c:uint, instant:Boolean = false):void {
			// override me
		}
		

		// BELOW IS FROM NEW BLOCK BASE ADAPTATION
		
		// Animation stuff for CDW... this breaks Futil's tween engine agnostic approach  
		// Multiple inheritance sure would be nice...
		// Defining stuff here is ugly, but keeps it out of the constructors
		public var defaultTweenVars:Object = {}; // temp turn off cache as bitmap...might fix twitching
		public var defaultTweenInVars:Object = ObjectUtil.mergeObjects(defaultTweenVars, {ease: Quart.easeOut, onInit: beforeTweenIn, onComplete: afterTweenIn});
		public var defaultTweenOutVars:Object = ObjectUtil.mergeObjects(defaultTweenVars, {ease: Quart.easeOut, onInit: beforeTweenOut, onComplete: afterTweenOut});
		private var defaultDuration:Number = 1;
		private var defaultInDuration:Number = defaultDuration;
		private var defaultOutDuration:Number = 0.75;
		public var active:Boolean;
		
		private var theTweenIn:TweenMax;
		private var theTweenOut:TweenMax;
		
		public function setDefaultTweenIn(duration:Number, params:Object):void {
			defaultInDuration = duration;
			defaultTweenInVars = ObjectUtil.mergeObjects(defaultTweenInVars, params);
		}
		
		public function setDefaultTweenOut(duration:Number, params:Object):void {
			defaultOutDuration = duration;
			defaultTweenOutVars = ObjectUtil.mergeObjects(defaultTweenOutVars, params);
		}				
		
		// A little tweening abstraction... sets overridable default parameters
		// manages visibility / invisibility
		protected function beforeTweenIn():void {
			this.visible = true;
			this.mouseEnabled = true;
			this.mouseChildren = true;			
		}
		
		protected function afterTweenIn():void {
			// override me
		}		
		
		protected function beforeTweenOut():void {
			// override me
			this.mouseEnabled = false;
			this.mouseChildren = false;			
		}
		
		protected function afterTweenOut():void {
			this.visible = false;
			
			// restore position so overriden out tweens restart from their canonical location
			defaultTweenOutVars.onComplete = null;
			
			TweenMax.to(this, 0, defaultTweenOutVars); // note that we have to preprocess again othwerise it will try to tween to the name shortcuts
			defaultTweenOutVars.onComplete = afterTweenOut;
		}		
		
		public function tween(duration:Number, params:Object):void {
			TweenMax.to(this, duration, ObjectUtil.mergeObjects(defaultTweenVars, params));
			active = true;
		}
		
		// Tweens to default location, or takes modifiers if called without arguments
		public function tweenIn(duration:Number = -1, params:Object = null):void {
			// THIS TRIES TO FIX THE MISSING BLOCK PROBLEM!!! // IT WORKS!s
			//TweenMax.killTweensOf(this); // stop tweening out if we're tweening out, keeps afterTweenOut from firing...
			if (theTweenOut != null) theTweenOut.kill(); // try to be kinder and gentler
			
			active = true;
			
			if (duration == -1) duration = defaultInDuration;
			if (params == null) params = defaultTweenInVars;
			else params = ObjectUtil.mergeObjects(defaultTweenInVars, params);
			
			theTweenIn = TweenMax.to(this, duration, params);
		}		
		
		public function tweenOut(duration:Number = -1, params:Object = null):void {
			if (duration == -1)	duration = defaultOutDuration;
			if (params == null)	params = defaultTweenOutVars;
			else params = ObjectUtil.mergeObjects(defaultTweenOutVars, params);
			
			theTweenOut = TweenMax.to(this, duration, params);
			active = true; // TODO WHY WAS THIS FALSE?
		}		
		
	}
}
