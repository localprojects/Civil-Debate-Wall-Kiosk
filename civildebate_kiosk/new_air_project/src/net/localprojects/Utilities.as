package net.localprojects {
	import flash.display.*;
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	
	public class Utilities {
		public function Utilities()	{
		}
		
		public static function setRegistrationPoint(s:Sprite, regx:Number, regy:Number, showRegistration:Boolean):void {
			//translate movieclip 
			s.transform.matrix = new Matrix(1, 0, 0, 1, -regx, -regy);
			
			//registration point.
			if (showRegistration)
			{
				var mark:Sprite = new Sprite();
				mark.graphics.lineStyle(1, 0x000000);
				mark.graphics.moveTo(-5, -5);
				mark.graphics.lineTo(5, 5);
				mark.graphics.moveTo(-5, 5);
				mark.graphics.lineTo(5, -5);
				s.parent.addChild(mark);
			}
		}
		
		
		//Format to save the image
		public static const FORMAT_JPEG:uint = 0x00;
		public static const FORMAT_PNG:uint = 0x01;
		
		//Extensions for the file
		private static const EXT_JPEG:String = ".jpg";
		private static const EXT_PNG:String = ".png";		
		
		
		public static function getNewImageFile(ext:String):File {
			//Create a new unique filename based on date/time
			var fileName:String = "image"+getNowTimestamp()+ext;
			
			//Create a reference to a new file on app folder
			//We use resolvepath to get a file object that points to the correct 
			//image folder - [USER]/[Documents]/[YOUR_APP_NAME]/images/
			//it also creates any directory that does not exists in the path
			
			var file:File = File.desktopDirectory.resolvePath(fileName);
			
			trace("saving ");
			trace(file.nativePath);
			
			
			//verify that the file really does not exist
			if (file.exists){
				//if exists , tries to get a new one using recursion
				return getNewImageFile(ext);
			}
			
			return file;
		}	
		
		//Returns a string in the format
		//200831415144243
		private static function getNowTimestamp():String{
			var d:Date = new Date();
			var tstamp:String = d.getFullYear().toString()+d.getMonth()+d.getDate()+d.getHours()+d.getMinutes()+d.getSeconds()+d.getMilliseconds();
			return 	tstamp;			
		}		
		
		
		
		
		public static function saveImageToDisk(bitmap:Bitmap, path:String, name:String):String {
			var file:File = new File(path + name);
			
			trace("Saving image to " + file.nativePath);
				
			//Bytearray of the final image
			var imgByteArray:ByteArray;
				
			//extension to save the file
			var ext:String;
				
			// temporarily always use jpeg
			var format:uint = FORMAT_JPEG;
			
			
			switch (format) {
				case FORMAT_JPEG:
					ext = ".jpg";
					var jpgenc:JPEGEncoder = new JPEGEncoder(80);
					imgByteArray = jpgenc.encode(bitmap.bitmapData);
					break;
				case FORMAT_PNG:
					ext = ".png";
					var pngenc:PNGEncoder = new PNGEncoder();
					imgByteArray = pngenc.encode(bitmap.bitmapData);
					break;
			}
				
			
				//Use a FileStream to save the bytearray as bytes to the new file
				var fs:FileStream = new FileStream();
				try {
					//open file in write mode
					fs.open(file, FileMode.WRITE);
					//write bytes from the byte array
					fs.writeBytes(imgByteArray);
					//close the file
					fs.close();
				} catch(e:Error) {
					trace(e.message);
				}
				
				return name;
			}
		
		
		// a la processing
		public static function color(r:int, g:int, b:int):uint {
			return r << 16 | g << 8 | b;
		}

		
		
		public static function arrayContains(needle:Object, haystack:Array):Boolean {
			return (haystack.indexOf(needle) > -1);
		}
			
		public static function centerWithin(a:DisplayObject, b:DisplayObject):void {
			a.x = (b.width / 2) - (a.width / 2);
			a.y = (b.height / 2) - (a.height / 2);			
		}
		
		// returns a point at the center of a rectangle
		public static function centerPoint(rect:Rectangle):Point {
			return new Point(rect.x + (rect.width / 2), rect.y + (rect.height / 2));
		}
		
		public static function randRange(low:int, high:int):int {
			return Math.floor(Math.random() * (high - low + 1) + low);			
		}		
		
		public static function getClassName(o:Object):String {
			var fullClassName:String = getQualifiedClassName(o);
			return fullClassName.slice(fullClassName.lastIndexOf("::") + 2);			
		}
		
		public static function averageArray(a:Array):Number {
			var sum:Number = 0;
			
			for (var i:int = 0; i < a.length; i++) {
				sum += a[i];
			}
			
			return sum / a.length;
		}
		
		
		// adapted from http://stackoverflow.com/questions/5350907/merging-objects-in-as3
		// if both objects have the same field, object 2 overrides object 1 
		public static function mergeObjects(o1:Object, o2:Object):Object {
			var o:Object = {};
			
			for(var p1:String in o1)	{
				o[p1] = o1[p1];								
			}
			
			for(var p2:String in o2)	{
				// overwrite with o2
				o[p2] = o2[p2];				
			}
			
			return o;
		}
		
		
		// scales down a bitmap data object so it fits with the width and height specified
		public static function scaleToFit(b:BitmapData, maxWidth:int, maxHeight:int):BitmapData {
			var widthRatio:Number = maxWidth / b.width;
			var heightRatio:Number = maxHeight / b.height;
			var scaleRatio:Number = Math.min(widthRatio, heightRatio);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleRatio, scaleRatio);
			
			var o:BitmapData = new BitmapData(b.width * scaleRatio, b.height * scaleRatio);
			o.draw(b, matrix);
			return o;
		}
		
		// scales down a bitmap data object so it fills the width and height specified, even if it has to crop		
		public static function scaleToFill(b:BitmapData, newWidth:int, newHeight:int):BitmapData {
			// scale
			var widthRatio:Number = newWidth / b.width;
			var heightRatio:Number = newHeight / b.height;
			var scaleRatio:Number = Math.max(widthRatio, heightRatio);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleRatio, scaleRatio);
			
			// crop and center
			matrix.tx = ((b.width * scaleRatio) - newWidth) / -2;
			matrix.ty = ((b.height * scaleRatio) - newHeight) / -2;			
			
			var o:BitmapData = new BitmapData(newWidth, newHeight);
			o.draw(b, matrix);
			return o;
		}			
		
		public static function degToRad(degrees:Number):Number {
			return degrees * Math.PI / 180; 
		}
		
		public static function radToDeg(radians:Number):Number {
			return radians * 180 / Math.PI; 
		}
		
		public static function randomElement(a:Array):* {
			return a[randRange(0, a.length)];
		}
		
		// very crude implementation, but works in our case
		public static function plural(word:String, count:Number):String {
			if (count != 1) {
				return word + 's';
			}
			else {
				return word;
			}
		}
		
		
		
		
		
		
		

		import flash.net.*;
		
		

		
		public static function postRequest(url:String, payload:Object, callback:Function):void {
			var loader:URLLoader = new URLLoader()
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = objectToURLVariables(payload);
			
			request.data = variables;  
			
			// Handlers
			loader.addEventListener(Event.COMPLETE, function(e:Event):void { callback(e.target.data); });  
			loader.load(request);	
		}
		
		// via http://www.jadbox.com/2009/01/object-to-urlvariables/
		// only supports single level of depth
		public static function objectToURLVariables(parameters:Object):URLVariables {
			var paramsToSend:URLVariables = new URLVariables();
			for (var i:String in parameters) {
				if (i!=null) {
					if (parameters[i] is Array) paramsToSend[i] = parameters[i];
					else paramsToSend[i] = parameters[i].toString();
				}
			}
			return paramsToSend;
		}		
				
		
		
		
		public static function dummyText(characters:int):String {
				var sourceText:Array = ['Lorem', 'ipsum', 'dolor', 'sit', 'amet', 'ceteros', 'torquatos', 'et', 'sea', 'Ea', 'utroque', 'explicari', 'concludaturque', 'nec', 'Nam', 'te', 'stet', 'assentior', 'reformidans', 'Ei', 'posse', 'volumus', 'duo', 'Ea', 'est', 'simul', 'dolore', 'nusquam', 'ei', 'tacimates', 'mediocrem', 'vim', 'Suas', 'forensibus', 'vis', 'cu', 'prompta', 'diceret', 'adipiscing', 'sed', 'te', 'integre', 'malorum', 'docendi', 'ei', 'eam', 'Cu', 'ius', 'odio', 'soleat', 'prodesset', 'ut', 'ius', 'iisque', 'legendos', 'Admodum', 'tractatos', 'qui', 'ad', 'Quo', 'ne', 'appetere', 'pericula', 'intellegam', 'Ne', 'eos', 'veri', 'ignota', 'deserunt', 'idque', 'insolens', 'antiopam', 'his', 'at', 'Facilis', 'deseruisse', 'id', 'eos', 'Ei', 'vel', 'oratio', 'iisque', 'vim', 'probo', 'abhorreant', 'et', 'Ne', 'habeo', 'vidisse', 'rationibus', 'vim', 'ei', 'quo', 'solet', 'tacimates', 'dissentiet', 'Pro', 'ea', 'vitae', 'commodo', 'eripuit', 'Ut', 'ipsum', 'principes', 'similique', 'mel', 'id', 'cum', 'sapientem', 'pertinacia', 'liberavisse', 'Ex', 'iusto', 'conclusionemque', 'has', 'veritus', 'oporteat', 'no', 'his', 'Gubergren', 'adipiscing', 'cu', 'nec', 'Cu', 'cum', 'prima', 'recusabo', 'impetus', 'aliquid', 'interpretaris', 'an', 'his', 'Pro', 'no', 'dicat', 'nulla', 'placerat', 'suas', 'adipiscing', 'ad', 'sed', 'No', 'suscipit', 'perfecto', 'accusata', 'his', 'pri', 'hinc', 'habeo', 'adhuc', 'in', 'Ea', 'mea', 'menandri', 'adipiscing', 'inimicus', 'voluptatum', 'persequeris', 'an', 'vix', 'sea', 'ut', 'agam', 'inermis', 'Adipisci', 'praesent', 'vim', 'eu', 'no', 'has', 'laudem', 'dolorum', 'Summo', 'mandamus', 'eu', 'sit', 'no', 'vidisse', 'insolens', 'duo', 'Est', 'no', 'omnis', 'viris', 'cu', 'sed', 'veri', 'oportere', 'philosophia', 'Te', 'ceteros', 'gubergren', 'posidonium', 'sea', 'Aperiri', 'docendi', 'vis', 'no', 'at', 'eos', 'clita', 'veritus', 'Qui', 'dicta', 'dissentias', 'et', 'mea', 'ei', 'novum', 'oratio', 'forensibus', 'est', 'dictas', 'quaestio', 'at', 'Mundi', 'philosophia', 'his', 'in', 'Qui', 'error', 'accusata', 'constituam', 'ne', 'at', 'bonorum', 'scriptorem', 'disputationi', 'eam', 'Ius', 'et', 'utinam', 'apeirian', 'dissentiunt', 'augue', 'graeci', 'te', 'est', 'voluptatum', 'scribentur', 'ei', 'est', 'Cu', 'has', 'recusabo', 'convenire', 'tincidunt', 'An', 'vel', 'mundi', 'euismod', 'expetenda', 'ut', 'probo', 'moderatius', 'pro', 'Nam', 'ne', 'oporteat', 'interesset', 'facer', 'appellantur', 'concludaturque', 'et', 'mel', 'Iuvaret', 'praesent', 'te', 'sit', 'ei', 'dico', 'democritum', 'vix', 'Sale', 'delicata', 'vis', 'ne', 'cu', 'noster', 'similique', 'quo', 'Persius', 'habemus', 'tractatos', 'sed', 'et', 'duo', 'paulo', 'diceret', 'probatus', 'et', 'Atqui', 'denique', 'insolens', 'et', 'vix', 'duo', 'mutat', 'nominavi', 'at', 'eu', 'postea', 'dissentias', 'vel', 'Duis', 'dicant', 'corrumpit', 'id', 'mea', 'cum', 'graeco', 'salutatus', 'ne', 'His', 'tale', 'fugit', 'adipisci', 'ut', 'eos', 'aeque', 'homero', 'soleat', 'ei', 'Ea', 'vis', 'prima', 'legendos', 'et', 'nec', 'semper', 'persecuti', 'Adhuc', 'ignota', 'an', 'cum', 'Id', 'his', 'etiam', 'partem', 'iracundia', 'mea', 'ad', 'iuvaret', 'discere', 'ea', 'mei', 'eligendi', 'molestie', 'petentium', 'Temporibus', 'intellegebat', 'eu', 'usu', 'et', 'eros', 'elit', 'conceptam', 'sea', 'Ea', 'eos', 'vidit', 'erant', 'eos', 'et', 'omnis', 'inani', 'legere', 'Eu', 'quo', 'novum', 'torquatos', 'efficiendi', 'eam', 'at', 'splendide', 'intellegebat', 'consequuntur', 'ornatus', 'conceptam', 'dissentias', 'vim', 'id', 'Pro', 'ne', 'iriure', 'detraxit', 'deserunt', 'te', 'pro', 'suscipit', 'officiis', 'atomorum', 'cetero', 'accumsan', 'est', 'no', 'Ne', 'puto', 'detracto', 'vis', 'munere', 'impetus', 'eos', 'at', 'Ad', 'pro', 'sapientem', 'reprimique', 'ipsum', 'vivendum', 'gubergren', 'qui', 'eu', 'Ea', 'iudico', 'aliquando', 'constituto', 'his', 'mucius', 'denique', 'no', 'has', 'ad', 'mei', 'dicta', 'impetus', 'His', 'in', 'fabulas', 'voluptua', 'oporteat', 'Eum', 'te', 'tation', 'scripta', 'sint', 'forensibus', 'no', 'nam', 'Erat', 'recusabo', 'temporibus', 'mea', 'no', 'Iusto', 'offendit', 'ut', 'vim', 'eum', 'ne', 'vidisse', 'incorrupte', 'Nec', 'errem', 'elitr', 'eirmod', 'ei', 'paulo', 'debitis', 'referrentur', 'ad', 'pro', 'Quo', 'ullum', 'velit', 'viris', 'in', 'Eam', 'tota', 'lobortis', 'ut', 'ei', 'nam', 'modo', 'novum', 'conclusionemque', 'Facer', 'libris', 'molestie', 'id', 'mei', 'Antiopam', 'conceptam', 'cu', 'vim', 'vim', 'modo', 'equidem', 'expetendis', 'in', 'Pro', 'ei', 'libris', 'aperiri', 'Duo', 'constituam', 'inciderint', 'ne', 'senserit', 'constituto', 'mel', 'te', 'Cum', 'tollit', 'definitionem', 'ad', 'Nam', 'albucius', 'disputando', 'ad', 'Summo', 'dissentias', 'efficiantur', 'quo', 'ei', 'ne', 'vel', 'veritus', 'interesset', 'Vim', 'ex', 'ponderum', 'perfecto', 'principes', 'Est', 'et', 'qualisque', 'pertinacia', 'usu', 'delenit', 'denique', 'praesent', 'at', 'Utamur', 'labores', 'neglegentur', 'an', 'his', 'Cum', 'ea', 'scripta', 'bonorum', 'maluisset', 'no', 'malis', 'nonumes', 'detracto', 'mel', 'Dicant', 'adipisci', 'has', 'at', 'No', 'viris', 'nostrud', 'pro', 'prompta', 'virtute', 'scripserit', 'nec', 'te', 'cu', 'duo', 'munere', 'melius', 'deleniti', 'Consequat', 'moderatius', 'ea', 'mei', 'summo', 'referrentur', 'eos', 'at', 'per', 'eu', 'facer', 'animal', 'Ne', 'tota', 'impedit', 'sententiae', 'per', 'vim', 'minim', 'repudiare', 'voluptaria', 'te', 'Eos', 'at', 'dicam', 'melius', 'intellegat', 'sit', 'sale', 'libris', 'cetero', 'id', 'Eu', 'nulla', 'detraxit', 'sit', 'Cum', 'ea', 'hinc', 'cibo', 'animal', 'Audire', 'luptatum', 'constituto', 'ex', 'mea', 'est', 'ea', 'tritani', 'assueverit', 'Dicant', 'voluptaria', 'te', 'has', 'eum', 'apeirian', 'consetetur', 'repudiandae', 'ne', 'Agam', 'concludaturque', 'sed', 'ei', 'nam', 'no', 'mutat', 'assum', 'tollit', 'Cu', 'mei', 'voluptua', 'delicata', 'hendrerit', 'Summo', 'regione', 'rationibus', 'ad', 'quo', 'graeco', 'probatus', 'singulis', 'ei', 'mea', 'His', 'mundi', 'nemore', 'forensibus', 'ea', 'Cum', 'an', 'veniam', 'pericula', 'Ad', 'nullam', 'indoctum', 'conceptam', 'est', 'Et', 'mea', 'erat', 'error', 'feugiat', 'Natum', 'movet', 'iudicabit', 'eu', 'vis', 'eum', 'no', 'nostrud', 'gloriatur', 'assueverit', 'Vix', 'in', 'oporteat', 'petentium', 'torquatos', 'per', 'at', 'justo', 'everti', 'Ut', 'nisl', 'sumo', 'tritani', 'pro', 'at', 'nam', 'clita', 'molestiae', 'concludaturque', 'pro', 'nominati', 'eleifend', 'efficiantur', 'at', 'Duo', 'congue', 'oblique', 'molestiae', 'et', 'duo', 'solum', 'nulla', 'aliquam', 'no', 'His', 'et', 'brute', 'commune', 'atomorum', 'eu', 'vis', 'mutat', 'graeci', 'philosophia', 'sea', 'ne', 'vidit', 'quidam', 'Cu', 'his', 'appetere', 'complectitur', 'Esse', 'mundi', 'menandri', 'vel', 'ex', 'Vis', 'ut', 'tritani', 'assentior', 'No', 'facete', 'civibus', 'argumentum', 'sed', 'in', 'quodsi', 'conclusionemque', 'duo', 'duo', 'adipiscing', 'scripserit', 'ut', 'Te', 'usu', 'oratio', 'blandit', 'deterruisset', 'Sumo', 'aliquam', 'partiendo', 'qui', 'an', 'simul', 'adipisci', 'scripserit', 'qui', 'ex', 'cum', 'id', 'veri', 'luptatum', 'No', 'alterum', 'tincidunt', 'sed', 'nam', 'id', 'ponderum', 'mandamus', 'Cu', 'ridens', 'temporibus', 'sea', 'mei', 'virtute', 'menandri', 'an', 'Deleniti', 'splendide', 'eu', 'mea', 'pro', 'aliquip', 'forensibus', 'interesset', 'te', 'Et', 'vel', 'ponderum', 'splendide', 'voluptatum', 'dissentias', 'vituperatoribus', 'cu', 'vel', 'Ea', 'nam', 'paulo', 'nullam', 'Ut', 'vel', 'graece', 'blandit', 'patrioque', 'Graece', 'verear', 'pertinax', 'vim', 'at', 'duo', 'sale', 'populo', 'epicurei', 'at', 'cu', 'delectus', 'accusata', 'duo', 'Ad', 'quo', 'simul', 'veritus', 'signiferumque', 'te', 'altera', 'eleifend', 'definiebas', 'sea', 'ad', 'nemore', 'reprimique', 'contentiones', 'nec', 'Vis', 'no', 'puto', 'accumsan', 'Fabulas', 'scaevola', 'iracundia', 'te', 'vim', 'Graeci', 'audiam', 'audire', 'in', 'vim', 'id', 'sea', 'fugit', 'ludus', 'ne', 'nec', 'fuisset', 'pericula', 'Altera', 'moderatius', 'pri', 'ne', 'Vel', 'utinam', 'postulant', 'et', 'Mea', 'labitur', 'vituperata', 'at', 'at', 'pri', 'autem', 'saepe', 'putant', 'prima', 'simul', 'saepe', 'ea', 'pro', 'Corpora', 'phaedrum', 'theophrastus', 'pri', 'et', 'sit', 'te', 'legendos', 'erroribus', 'Pri', 'ne', 'ferri', 'zril', 'populo', 'Te', 'denique', 'albucius', 'laboramus', 'eam', 'Duo', 'probo', 'maluisset', 'ne', 'ex', 'his', 'vide', 'velit', 'vitae', 'Elit', 'detracto', 'ei', 'sea', 'mandamus', 'praesent', 'est', 'te', 'prompta', 'menandri', 'ea', 'eam', 'Habeo', 'regione', 'te', 'has', 'ea', 'mei', 'tibique', 'accusamus', 'sea', 'in', 'placerat', 'consectetuer', 'Nec', 'latine', 'nusquam', 'incorrupte', 'ea', 'Vel', 'id', 'eirmod', 'atomorum', 'veniam', 'option', 'sea', 'no', 'Alii', 'eleifend', 'an', 'his', 'Sit', 'te', 'abhorreant', 'moderatius', 'Quo', 'no', 'suas', 'dicta', 'urbanitas', 'Ad', 'usu', 'praesent', 'vituperata', 'efficiendi', 'eam', 'an', 'impedit', 'hendrerit', 'reformidans', 'eu', 'cum', 'mundi', 'veritus', 'adolescens', 'Ut', 'pri', 'harum', 'iudicabit', 'theophrastus', 'Convenire', 'interpretaris', 'his', 'at', 'dicat', 'malorum', 'assentior', 'eu', 'per', 'elit', 'omnis', 'in', 'eum', 'Epicuri', 'percipit'];			
				var text:String = '';
				
				// Build the string
				while (text.length < (characters + 50)) {
					if (text.length == 0) {
						text += randomElement(sourceText);
					}
					else {
						text += ' ' + randomElement(sourceText);
					}
				}
				
				// Trim the extra
				text = text.substr(0, characters);

				return text;
		}

	}
}
