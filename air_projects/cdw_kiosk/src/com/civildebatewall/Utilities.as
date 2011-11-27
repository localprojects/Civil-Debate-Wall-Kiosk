package com.civildebatewall {
	
	import com.adobe.crypto.SHA1;
	import com.adobe.serialization.json.*;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.utilitites.DateUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import fl.motion.Color;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.*;
	import com.civildebatewall.kiosk.core.Kiosk;

	public class Utilities {
		
		public static function interpolateColorThroughWhite(start:uint, end:uint, step:Number):uint {
			if (step <= 0.5) {
				// towards white
				return Color.interpolateColor(start, 0xffffff, step * 2);				
			}
			else {
				// from white
				return Color.interpolateColor(0xffffff, end, (step * 2) - 1);		
			}
		}
				
		
		public static function getNewImageFile(ext:String):File {
			//Create a new unique filename based on date/time
			var fileName:String = "image"+ DateUtil.getNowTimestamp() + ext;
			
			//Create a reference to a new file on app folder
			//We use resolvepath to get a file object that points to the correct 
			//image folder - [USER]/[Documents]/[YOUR_APP_NAME]/images/
			//it also creates any directory that does not exists in the path
			
			var file:File = File.desktopDirectory.resolvePath(fileName);
			
			//verify that the file really does not exist
			if (file.exists) {
				//if exists , tries to get a new one using recursion
				return getNewImageFile(ext);
			}
			
			return file;
		}

		
		// === Line of specificity? Above do not belong in Futil, below does?
		

		//Format to save the image
		public static const FORMAT_JPEG:uint = 0x00;
		public static const FORMAT_PNG:uint = 0x01;
		
		//Extensions for the file
		private static const EXT_JPEG:String = ".jpg";
		private static const EXT_PNG:String = ".png";		
				
		
		// loads a bitmap, passes it to the callback
		// USE LOADER MAX AGAIN INSTEAD PASSING IN FILE URL?
		public static function loadImageFromDiskToTarget(path:String, target:Bitmap, onComplete:Function):void {
			var file:File = new File(path);
			var imageLoader:Loader = new Loader();
			var thisTarget:Bitmap = target;
			
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
				thisTarget = imageLoader.content as Bitmap;
				onComplete();
			});
			
			trace('loading image from ' + file.url);
			imageLoader.load(new URLRequest(file.url));
		}

		

		
		// Hmmm....
		public static function traceObject(o:Object):void {
			trace(JSON.encode(o));
		}
																			 
		
		// like post request, but automatically digests JSON
		public static function postRequestJSON(url:String, payload:Object, callback:Function):void {
			trace("posting json to " + url);
			postRequest(url, payload, function(r:Object):void { callback(JSON.decode(r.toString()))	}); 
		}		
		
		public static function postRequest(url:String, payload:Object, callback:Function):void {
			var loader:URLLoader = new URLLoader()
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = objectToURLVariables(payload);
			
			request.data = variables;  
			
			// Security header
			request.requestHeaders.push(new URLRequestHeader("X-Auth-Token", CivilDebateWall.settings.secretKeyHash));
			
			trace('sending variables: ' + variables.toString());
			
			// Handlers
			loader.addEventListener(Event.COMPLETE, function(e:Event):void { callback(e.target.data); });
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(e:HTTPStatusEvent):void { trace('HTTP Status: ' + e.status); });
			
			loader.load(request);	
		}
		
		public static function getRequest(url:String, callback:Function):void {
			var loader:URLLoader = new URLLoader()
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.GET;
			  
			// Handlers
			loader.addEventListener(Event.COMPLETE, function(e:Event):void { callback(e.target.data); });  
			loader.load(request);	
		}
		
		public static function getRequestJSON(url:String, callback:Function):void {
			getRequest(url, function(r:Object):void { callback(JSON.decode(r.toString()))	}); 	
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
		

		public static function shortenName(s:String):String {
			// Capitalized First word 
			return StringUtil.capitalize(StringUtil.trim(s.split(' ')[0]))			
		}
		
		public static function createFolderIfNecessary(path:String):void {
			var directory:File = new File(path);
			
			if (!directory.exists) {
				trace('Directory "' + path + '" does not exist. Creating it.');
				directory.createDirectory();
			}
		}
		
		// Move to face detection package?
		public static function cropToFace(sourceBitmap:Bitmap, sourceFaceRectangle:Rectangle, targetFaceRectangle:Rectangle):Bitmap {
			// lots of stuff hard coded here... dimensions of target, location of face in target
			
			// give up if the target face rectangle is too far away?
			var targetBounds:Rectangle = new Rectangle(0, 0, 1080, 1920);			

			
			var sourceBounds:Rectangle = sourceBitmap.bitmapData.rect;
			
			// Figure out scale required to fit face rect in target rect
			var rectWidthRatio:Number = targetFaceRectangle.width / sourceFaceRectangle.width;
			var rectHeightRatio:Number = targetFaceRectangle.height / sourceFaceRectangle.height;
			var rectScaleRatio:Number = Math.min(rectWidthRatio, rectHeightRatio);
			
			// Scale the source stuff so face sizes match
			var scaledSourceBounds:Rectangle = GeomUtil.scaleRect(sourceBounds, rectScaleRatio);			
			var scaledFaceRectangle:Rectangle = GeomUtil.scaleRect(sourceFaceRectangle, rectScaleRatio);
			
			// align face centers 
			var targetCenter:Point = GeomUtil.centerPoint(targetFaceRectangle);
			var scaledSourceCenter:Point = GeomUtil.centerPoint(scaledFaceRectangle);
			var sourceTranslation:Point = targetCenter.subtract(scaledSourceCenter);
			
			scaledSourceBounds.x = sourceTranslation.x; 
			scaledSourceBounds.y = sourceTranslation.y;			
			
			// TODO nudge left and right before growing unnecessarily			
			
			// grow around face point until it fits the target bitmap...
			var aspectRatio:Number = scaledSourceBounds.width / scaledSourceBounds.height;
			var originalWidth:Number = scaledSourceBounds.width;
			var originalHeight:Number = scaledSourceBounds.height;
			
			// TODO abort safety
			while (!scaledSourceBounds.containsRect(targetBounds)) {
				trace("Scaling... " + scaledSourceBounds);
				trace("To fit within: " + targetBounds);
				scaledSourceBounds.width += 1  * aspectRatio;
				scaledSourceBounds.x -= (scaledSourceCenter.x / originalWidth) * aspectRatio;
				
				scaledSourceBounds.height += 1;				
				scaledSourceBounds.y -= (scaledSourceCenter.y / originalHeight);								
			}
			
			var totalScaleX:Number = scaledSourceBounds.width / sourceBitmap.width;
			var totalScaleY:Number = scaledSourceBounds.height / sourceBitmap.height;			
			
			trace("Scaled: " + totalScaleX + " x " + totalScaleY);
			
			// TODO set some kind of scale threshold
			
			// now it fits, we have the the bounds of the final rectangle
			trace("This fits: " + scaledSourceBounds);
			
			// draw the face cropped image it into a bitmap
			var portraitBitmap:Bitmap = new Bitmap(new BitmapData(1080, 1920), PixelSnapping.NEVER, true);
			
			// turn the rectangle representation of the new position and scale into a matrix
			var drawMatrix:Matrix = new Matrix();
			drawMatrix.scale(totalScaleX, totalScaleY);
			drawMatrix.tx = Math.floor(scaledSourceBounds.x);
			drawMatrix.ty = Math.floor(scaledSourceBounds.y);			
			
			// draw it into a bitmao
			var faceCroppedBitmap:Bitmap = new Bitmap(new BitmapData(1080, 1920), PixelSnapping.NEVER, true);
			faceCroppedBitmap.bitmapData.draw(sourceBitmap, drawMatrix, null, null, null, true);
			return faceCroppedBitmap;
		}
				
		
	}
}
