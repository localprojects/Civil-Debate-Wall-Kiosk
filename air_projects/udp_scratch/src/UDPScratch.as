package
{
	import flash.display.Sprite;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.DatagramSocket;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	

	import com.demonsters.debugger.MonsterDebugger;

	
	
	// http://tv.adobe.com/watch/adc-presents/discover-the-udp-api-in-adobe-air-2/#
	
	public class UDPScratch extends Sprite	{
	
		
		
		// Outgoing Message Types
		private static const ARE_YOU_SERVER:String = 'a';
		
		// Incoming Message Types
		
		private var myScreenID:int = 1;
		
		// Will come from settings file
		private var networkMap:Object = {
			1: {ip: '127.0.0.1', port: 63644},
			2: {ip: '127.0.0.1', port: 63645},
			3: {ip: '127.0.0.1', port: 63646},
			4: {ip: '127.0.0.1', port: 63647},
			5: {ip: '127.0.0.1', port: 63648}			
		};
		
		
		private var udpSocket:DatagramSocket = new DatagramSocket();
		private var myPort:int;
		private var myIP:String;		
		
		
		public function UDPScratch() {
			
			MonsterDebugger.initialize(this);			
			
			
			// Connect
			MonsterDebugger.trace(this, 'My IP: ' + networkMap[myScreenID]['ip']);
			
			// Bind to your own address
			myIP = networkMap[myScreenID]['ip'];			
			myPort = networkMap[myScreenID]['port'];
			
			// Close the socket if it's already open
			if (udpSocket.bound) {
				MonsterDebugger.trace(this, 'Closing existing port');
				udpSocket.close();
				udpSocket = new DatagramSocket();				
			}
			
			udpSocket.bind(myPort, myIP);
			udpSocket.addEventListener(DatagramSocketDataEvent.DATA, onDataReceived);
			udpSocket.receive();
			
			MonsterDebugger.trace(this, "Bound to: " + udpSocket.localAddress + ":" + udpSocket.localPort);
			
			// Check for existing servers
			
		}

		
		private function onDataReceived(e:DatagramSocketDataEvent):void	{
			//Read the data from the datagram
			MonsterDebugger.trace(this, "Received from " + e.srcAddress + ":" + e.srcPort + "> " +	e.data.readUTFBytes(e.data.bytesAvailable));
			
			// TODO map everything
			
		}		
		
		
		private function send(machineID:int, message:String):void {
			//Create a message in a ByteArray
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes(message);
			
			var targetIP:String = networkMap[machineID]['ip'];
			var targetPort:int = networkMap[machineID]['port'];
			
			//Send a datagram to the target
			try	{				
				udpSocket.send(data, 0, 0,targetIP, targetPort); 
			}
			catch (error:Error)	{
				MonsterDebugger.trace(this, error.message);
			}
		}
		

	}
}