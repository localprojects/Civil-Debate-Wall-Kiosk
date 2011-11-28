package com.kitschpatrol.flashspan
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.kitschpatrol.flashspan.events.CustomMessageEvent;
	import com.kitschpatrol.flashspan.events.FlashSpanEvent;
	import com.kitschpatrol.flashspan.events.FrameSyncEvent;
	import com.kitschpatrol.flashspan.events.TimeSyncEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.DatagramSocket;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	
	
	public class FlashSpan extends EventDispatcher {
		public var settings:Settings;
		
		// regular packets should be
		// (one character header)(body)
		
		// certified packet format, gets a confirmation that the packet was received
		// (certifed header)(packet header)(body),(certified packets sent count)
		
		// certified response format
		// (certified response header)(certified packets sent count)		
		
		// Todo move into connection class? TODO some kind of "monitor connection" setting
		private var udpSocket:DatagramSocket = new DatagramSocket();
		private var packetsInWaiting:Vector.<CertifiedPacket> = new Vector.<CertifiedPacket>(0);		
		
		private var connectionCheckTimer:Timer; // not used
		
		// server stuff
		private var isServer:Boolean = false;
		private var isSyncing:Boolean = false;
		private var syncTimer:Timer;
		private var serverTime:int = 0;
		private var serverTimeReceived:int = 0;		
		
		// Message types
		internal static const CERTIFIED_HEADER:String = "c";
		private static const CERTIFIED_RESPONSE_HEADER:String = "r";
		private static const PING_HEADER:String = "p";
		
		private static const START_SYNC_HEADER:String = "s";
		private static const START_TIME_SYNC_HEADER:String = "n";		
		private static const STOP_REQUEST_HEADER:String = "t";
		private static const STOP_COMPLETE_HEADER:String = "o";
		private static const FRAME_SYNC_HEADER:String = "y";
		private static const TIME_SYNC_HEADER:String = "m";		
		private static const QUIT_HEADER:String = "q";
		private static const CUSTOM_MESSAGE_HEADER:String = "e";
		
		public var frameCount:uint = 0;
		private var seededRandom:Random;
		
		public function FlashSpan(screenID:int = -1, settingsPath:String = "flash_span_settings.xml") {
			super(null);
			
			// set up debugger
			MonsterDebugger.initialize(this);
			MonsterDebugger.trace(this, "Flash Span Constructed");

			// load the settings
			settings = new Settings();
			settings.load(settingsPath);		
			
			// seed it... TODO pass in seed from settings?
			seededRandom = new Random(1);	
			
			// if screen ID is -1, use the IP identification technique
			if (screenID == -1) {
				MonsterDebugger.trace(this, "Setting screen ID from IP");
				settings.setMyID(getIDfromIP());
			}
			else {
				MonsterDebugger.trace(this, "Setting screen ID from constructor");				
				settings.setMyID(screenID);
			}
			
			// for now, screen 0 is always server			
			isServer = (settings.thisScreen.id == 0);
			
			// Close the socket if it's already open
			if (udpSocket.bound) {
				MonsterDebugger.trace(this, "Closing existing port");
				udpSocket.close();
				udpSocket = new DatagramSocket();				
			}
			
			MonsterDebugger.trace(this, "Binding to: " + settings.thisScreen.ip + ":" + settings.thisScreen.port);			
			
			udpSocket.bind(settings.thisScreen.port, settings.thisScreen.ip);
			udpSocket.addEventListener(DatagramSocketDataEvent.DATA, onDataReceived);
			udpSocket.receive();
			
			MonsterDebugger.trace(this, "Bound to: " + udpSocket.localAddress + ":" + udpSocket.localPort);
			
			// Check for existing servers
				
			// Start checking for who is connected
			// not needed?
//			settings.thisScreen.connected = true; // obviously we're connected
//			connectionCheckTimer = new Timer(500); // check every 500ms?
//			connectionCheckTimer.addEventListener(TimerEvent.TIMER, connectionCheck);
//			connectionCheckTimer.start();
		}
		
		
		// For Time Sync Mode
		public function getTime():int {
			// add local time elapsed since last server time update to server time
			return serverTime + (getTimer() - serverTimeReceived);
		}		
		
		
		// heartbeat
		private function connectionCheck(e:TimerEvent):void {
			MonsterDebugger.trace(this, "Pinging for connection");
			MonsterDebugger.trace(this, settings);			
			broadcastPing();
		}
				
		
		private function onFrameSyncTimer(e:TimerEvent):void {
			// broadcast sync
			broadcastMessage(FRAME_SYNC_HEADER);
			dispatchFrameSyncEvent();
		}
		
		
		private var millis:int;
		private function onTimeSyncTimer(e:TimerEvent):void {
			// broadcast sync
			millis = getTimer();
			
			// broadcast, factoring latency for each client
			for each (var screen:NetworkedScreen in settings.screens) {
				if (screen != settings.thisScreen) {
					sendCertified(screen, TIME_SYNC_HEADER + (millis - (screen.latency / 2)));
				}
			}			
			
			// dispatch event locally for server
			dispatchTimeSyncEvent(millis);
		}
		
		
		public function start():void {
			if (isServer) {			
				// start syncing
				if (settings.syncMode == Settings.SYNC_FRAMES) {
					startFrameSync();	
				}
				else if (settings.syncMode == Settings.SYNC_TIME) {
					startTimeSync();
				}
				else {
					throw new Error("Invalid screen sync mode. Check your settings.xml file.");				
				}
			}
			else {
				// clients should send request to server
				sendCertified(settings.screens[0], START_SYNC_HEADER);				
			}
		}

		
		private function startFrameSync():void {
			syncTimer = new Timer(1000 / 50); // TODO best approach to this?
			syncTimer.addEventListener(TimerEvent.TIMER, onFrameSyncTimer);				
			syncTimer.start();
		}
		
		
		private function startTimeSync():void {
			syncTimer = new Timer(250); // figure this out
			syncTimer.addEventListener(TimerEvent.TIMER, onTimeSyncTimer);				
			syncTimer.start();
		}		
		
		
		public function quitAll():void {
			// broadcast
			broadcastMessage(QUIT_HEADER);
			
			// quit self
			quit();
		}
		
		
		private function quit():void {
			NativeApplication.nativeApplication.exit();
		}
		
		
		public function stop():void {
			if (isSyncing) {
				if (isServer) {
					// Stop broadcasting sync messages
					syncTimer.reset();
					syncTimer.stop();
					
					// remove event listeners
					if (settings.syncMode == Settings.SYNC_FRAMES) {
						syncTimer.removeEventListener(TimerEvent.TIMER, onFrameSyncTimer);	
					}
					else if (settings.syncMode == Settings.SYNC_TIME) {
						syncTimer.removeEventListener(TimerEvent.TIMER, onTimeSyncTimer);
					}
					
					
					// broadcast stop to clients
					broadcastMessage(STOP_COMPLETE_HEADER);
					
					// dispatch stop event locally
					dispatchStopEvent();
				}
				else {
					// send to server
					sendCertified(settings.screens[0], STOP_REQUEST_HEADER);
				}
			}
		}		
		
		
		
		// Event dispatch wrappers
		private function dispatchFrameSyncEvent():void {
			// send out event locally
			if (!isSyncing) {
				dispatchStartEvent();
			}

			this.dispatchEvent(new FrameSyncEvent(FrameSyncEvent.SYNC, frameCount));
			frameCount++;			
		}
		
		private function dispatchTimeSyncEvent(time:int):void {
			// send out event locally
			if (!isSyncing) {
				dispatchStartEvent();
			}
			
			// Record the time
			serverTime = time;
			serverTimeReceived = getTimer();
			
			// Why even listen to this? Client should use .getTime() instead.
			this.dispatchEvent(new TimeSyncEvent(TimeSyncEvent.SYNC, time));
		}
		
		
		private function dispatchStopEvent():void {
			isSyncing = false;
			this.dispatchEvent(new Event(FlashSpanEvent.STOP));
		}
		
		
		private function dispatchStartEvent():void {
			isSyncing = true;
			this.dispatchEvent(new Event(FlashSpanEvent.START));			
		}		
		
		public function random():Number {
			// nicely seeded random
			return seededRandom.random();
		}
		

		private function onDataReceived(e:DatagramSocketDataEvent):void	{
			var incoming:String = e.data.readUTFBytes(e.data.bytesAvailable);
			
			//MonsterDebugger.trace(this, "Received from " + e.srcAddress + ":" + e.srcPort + "> " +	incoming);
			
			if (incoming.length > 0) {
				var header:String = incoming.substr(0, 1); // first character
				var body:String = "";
			
				// Handle certified packets, these require a response to the sender. Otherwise they're normal packets.
				if (header == CERTIFIED_HEADER) {
					// extract the actual packet header
					var lastCommaIndex:int = incoming.lastIndexOf(",");	
					header =  incoming.substr(1, 1); // second character
					body = incoming.substring(2, lastCommaIndex);
					var packetID:String = incoming.substr(lastCommaIndex + 1);
					
					// send the response
					send(settings.getScreenByIP(e.srcAddress, e.srcPort), CERTIFIED_RESPONSE_HEADER + packetID);
				}
				else {
					// not a certified packet
					body = incoming.substr(1); // second character onward is the body
				}
			
				//MonsterDebugger.trace(this, "Header: " + header);
				//MonsterDebugger.trace(this, "Body: " + body);
				
				switch (header) {
					case PING_HEADER:
						// nothing to do, pong is sent automatically through certified header
						break;
					
					case CERTIFIED_RESPONSE_HEADER:						
						// Calculate packet time, disarm timer, etc.
						var index:int = findPacketInWaitingIndex(parseInt(body));
						packetsInWaiting[index].destination.latency = getTimer() - packetsInWaiting[index].timeSent;
						
						// disable the alarm!
						packetsInWaiting[index].disarmTimeout();
						
						// mark respondent as connected
						packetsInWaiting[index].destination.connected = true;
						
						// remove the packet in waiting
						packetsInWaiting.splice(index, 1);
						break;
					
					// for server
					case START_SYNC_HEADER:
						start();			
						
					case STOP_REQUEST_HEADER:
						stop();
						break;
					
					case STOP_COMPLETE_HEADER:
						// Dispatch stop event
						dispatchStopEvent();
						break;
					
					case QUIT_HEADER:
						quit();
						break;					
					
					// for broadcast
					case FRAME_SYNC_HEADER:
						dispatchFrameSyncEvent()
						break;
					
					case TIME_SYNC_HEADER:
						// Extract time from body!
						dispatchTimeSyncEvent(parseInt(body));
						break;		
					
					case CUSTOM_MESSAGE_HEADER:
						var commaIndex:int = body.indexOf(",");
						var customHeader:String = body.substring(0, commaIndex);
						var customBody:String = body.substring(commaIndex + 1);	
						
						dispatchCustomMessageEvent(customHeader, customBody);
						break;
						
					default:
						MonsterDebugger.trace(this, "Unknown header.");
						break;
				}
			}
		}
		
		
		protected function onTimeout(packet:CertifiedPacket):void {
			MonsterDebugger.trace(this, "Send timed out!");
			MonsterDebugger.trace(this, packet);
			
			// mark non-respondent as disconnected
			packet.destination.connected = false;			
			
			// remove the packet
			packetsInWaiting.splice(packetsInWaiting.indexOf(packet), 1);
			
			// TODO something else? Try again?
		}
		
		
		// Sends a packet		
		private function send(screen:NetworkedScreen, message:String):void {
			//Create a message in a ByteArray
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes(message);
			
			//Send a datagram to the target
			try	{				
				udpSocket.send(data, 0, 0, screen.ip, screen.port); 
			}
			catch (error:Error)	{
				MonsterDebugger.trace(this, error.message);
			}
		}
		

		// Basic transmission functions
		
		// Sends a packet and requests a conformation from recipient		
		private function sendCertified(screen:NetworkedScreen, message:String, timeout:int = 500):void {
			// adds a certification wrapper
			var certifiedPacket:CertifiedPacket = new CertifiedPacket(message, screen, timeout, onTimeout);
			packetsInWaiting.push(certifiedPacket);
			send(screen, certifiedPacket.toMessage());
		}
		
		
		// sends a message to everyone except for the sender
		private function broadcastMessage(message:String):void {
			for each (var screen:NetworkedScreen in settings.screens) {
				if (screen != settings.thisScreen) {
					send(screen, message);
				}
			}
		}
		
		// sends a custom message to everyone, including self
		public function broadcastCustomMessage(header:String, message:String = ''):void {
			for each (var screen:NetworkedScreen in settings.screens) {
				send(screen, CUSTOM_MESSAGE_HEADER + header + "," + message); 
			}
		}
		
		private function dispatchCustomMessageEvent(header:String, message:String):void {
			this.dispatchEvent(new CustomMessageEvent(CustomMessageEvent.MESSAGE_RECEIVED, header, message));
		}
		
		private function broadcastCertifiedMessage(message:String):void {
			for each (var screen:NetworkedScreen in settings.screens) {
				if (screen != settings.thisScreen) {
					sendCertified(screen, message);
				}
			}
		}
		
		
		// Convenience transmission functions
		
		// Wrapped up for convenience
		// messages are sent with a single bah
		public function ping(screen:NetworkedScreen):void {
			sendCertified(screen, PING_HEADER);
		}
		
		
		public function broadcastPing():void {
			broadcastCertifiedMessage(PING_HEADER);
		}		
		
		
		
		
		
		
		// Utilities...
		private function findPacketInWaitingIndex(packetID:int):int {
			for (var i:int = 0; i < packetsInWaiting.length; i++) {
				if (packetsInWaiting[i].packetID == packetID) return i;
			}
			return -1;
		}	
		

		public function getIDfromIP():int {
			// picks the id from settings that matches my IP
			// untested!
			
			var activeIPs:Array = listActiveIPs();
			
			for (var i:int = 0; i < settings.screens.length; i++) {
				if (activeIPs.indexOf(settings.screens[i].ip) > -1) {
					return settings.screens[i].id;
				}
			}
			
			// call it off if we can't find anything
			throw new Error("Could not find screen ID from machine IP!\n" + 
							"Make sure this computer's static ethernet IP is in one of the <screen> elements in the settings.xml file.\n" +
							"Alternately, set the screen ID manually by  calling settings.setMyID(id:int)\n");
		}
		
		
		public function listActiveIPs():Array {
			var networkInterfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			var ips:Array = [];
			
			for (var i:int = 0; i < networkInterfaces.length; i++) {
				if (networkInterfaces[i].active) {
					// look through ips
					for (var j:int = 0; j < networkInterfaces[i].addresses.length; j++) {
						ips.push(networkInterfaces[i].addresses[j].address);
					}					
				}
			}
			
			return ips;
		}		
		
		
		// TODO put this into FlashSpan, returns screen index, or -1 if it's in the gutter or off the screen
		public function pointIsOnScreen(p:Point):int {
			for (var i:int = 0; i < settings.screenCount; i++) {
				if (settings.screens[i].containsPoint(p)) return i;
			}
			return -1;
		}
		
		// TODO put this in flashspan, too
		public function pointIsNearScreen(p:Point):int {
			var onScreen:int = pointIsOnScreen(p);
			
			if (onScreen > -1) {
				return onScreen;
			}
			else {
				var minDistance:Number = Number.MAX_VALUE;
				var minDistanceIndex:int = -1;
				
				for (var i:int = 0; i < settings.screenCount; i++) {
					var screenCenter:Point = new Point(settings.screens[i].x + (settings.screens[i].width / 2), settings.screens[i].y + (settings.screens[i].height / 2));
					var distance:Number = Point.distance(p, screenCenter);
					
					if (distance < minDistance) {
						minDistance = distance;
						minDistanceIndex = i;
					}
				}
				
				return minDistanceIndex;
			}
			
			// should never get here
			return -1;
		}				

	}
}