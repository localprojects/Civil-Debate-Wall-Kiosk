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

package {		
	
	import com.civildebatewall.CivilDebateWall;
	
	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;
	
	import spark.core.SpriteVisualElement;
	
	public class Main extends SpriteVisualElement	{

		public function Main() {		
			// set up SpriteVisualElement
			percentWidth = 100;
			percentHeight = 100;
			
			// catch command line args
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
			//this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onInvoke(e:InvokeEvent):void {
			var civilDebateWall:CivilDebateWall = new CivilDebateWall(e.arguments);
			addChild(civilDebateWall);
		}
	}
	
}

