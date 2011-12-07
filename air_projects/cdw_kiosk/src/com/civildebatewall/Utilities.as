package com.civildebatewall {
	
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	public class Utilities {

		private static const logger:ILogger = getLogger(Utilities);
		
		// Unused (move to Futil?)
		public static function interpolateColorThroughWhite(start:uint, end:uint, step:Number):uint {
			if (step <= 0.5) {
				// towards white
				//return Color.interpolateColor(start, 0xffffff, step * 2);				
			}
			else {
				// from white
				//return Color.interpolateColor(0xffffff, end, (step * 2) - 1);		
			}
			
			return 0;
		}
		
		
		// HTTP requests, TODO make a better class for this
		// Discussion on this treatment of anonymous functions: http://www.ultrashock.com/forum/viewthread/121738/
		public static function getRequest(url:String, callback:Function):void {
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.GET;
			logger.debug("Loading HTTP GET " + request.url + "...");
			
			// Handlers
			loader.addEventListener(Event.COMPLETE, function(event:Event):void {
				event.currentTarget.removeEventListener(Event.COMPLETE, arguments.callee);
				event.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, arguments.callee);
				event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);

				logger.debug("...Loading HTTP GET complete: Loaded " + event.target.bytesLoaded + " bytes");
				if (CivilDebateWall.settings.logFullHTTP) logger.debug(StringUtil.stripSerialSpaces(StringUtil.stripLinebreaks(event.target.data)));
				callback(event.target.data);
			});
			
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(event:HTTPStatusEvent):void {
				event.currentTarget.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, arguments.callee);
				
				if (event.status == 200) {
					logger.debug("HTTP GET response status: " + event.status);				
				}
				else {
					logger.error("HTTP GET response status: " + event.status);
				}
			});
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {
				event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				logger.error("HTTP GET IO error: " + event.errorID);
			});
				
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityErrorEvent):void {
				event.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, arguments.callee);
				logger.error("HTTP GET Security Sandbox Error: " + event.errorID);
			});
			
			loader.load(request);
		}
		
		public static function postRequest(url:String, payload:Object, callback:Function):void {
			var loader:URLLoader = new URLLoader()
			var request:URLRequest = new URLRequest(url);
			var variables:URLVariables = objectToURLVariables(payload);
			
			request.method = URLRequestMethod.POST;
			request.data = variables;  
			request.requestHeaders.push(new URLRequestHeader("X-Auth-Token", CivilDebateWall.settings.secretKeyHash)); // Security header
			
			logger.debug("Loading HTTP POST " + request.url + " with variables " + variables.toString() + "...");			
			
			// Handlers
			loader.addEventListener(Event.COMPLETE, function(event:Event):void {
				event.currentTarget.removeEventListener(Event.COMPLETE, arguments.callee);
				event.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, arguments.callee);
				event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				
				logger.debug("...Loading HTTP POST complete: Loaded " + event.target.bytesLoaded + " bytes");
				if (CivilDebateWall.settings.logFullHTTP) logger.debug(StringUtil.stripSerialSpaces(StringUtil.stripLinebreaks(event.target.data)));
				callback(event.target.data);
			});
			
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(event:HTTPStatusEvent):void {
				event.currentTarget.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, arguments.callee);
				
				if (event.status == 200) {
					logger.debug("HTTP POST response status: " + event.status);				
				}
				else {
					logger.error("HTTP POST response status: " + event.status);
				}
			});
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {
				event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				logger.error("HTTP POST IO error: " + event.errorID);
			});
			
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityErrorEvent):void {
				event.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, arguments.callee);
				logger.error("HTTP POST Security Sandbox Error: " + event.errorID);
			});

			loader.load(request);	
		}
		
		// HTTP Request JSON Wrappers		
		// optionally pass extra args
		public static function getRequestJSON(url:String, callback:Function, extraArgs:Object = null):void {
			getRequest(url, function(r:Object):void {
				var jsonResponse:Object;
					
				try	{
					jsonResponse = JSON.decode(r.toString());
				} 
				catch (error:JSONParseError) {
					logger.error("JSON Parse Error: " + error.message);
					// TODO fail gracefully
				}
				
				if (extraArgs == null) {
					callback(jsonResponse)
				}
				else {
					callback(jsonResponse, extraArgs);
				}
			}); 	
		}			
		
		public static function postRequestJSON(url:String, payload:Object, callback:Function):void {			
			postRequest(url, payload, function(r:Object):void {
				var jsonResponse:Object;
				
				try	{
					jsonResponse = JSON.decode(r.toString());
				} 
				catch (error:JSONParseError) {
					logger.error("JSON Parse Error: " + error.message);
					// TODO fail gracefully
				}				
				
				callback(jsonResponse);
			});
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
		
		// Move to face detection package?
		public static function cropToFace(sourceBitmap:Bitmap, sourceFaceRectangle:Rectangle, targetFaceRectangle:Rectangle):Bitmap {
			// lots of stuff hard coded here... dimensions of target, location of face in target
			logger.info("Scaling to face...");			
			
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
			var steps:int = 0;
			var stepLimit:int = 1000;
			while (!scaledSourceBounds.containsRect(targetBounds)) {
				scaledSourceBounds.width += 1  * aspectRatio;
				scaledSourceBounds.x -= (scaledSourceCenter.x / originalWidth) * aspectRatio;
				
				scaledSourceBounds.height += 1;				
				scaledSourceBounds.y -= (scaledSourceCenter.y / originalHeight);								
				
				if (steps > stepLimit) {
					logger.error("Face crop stuck in scaling loop");
					break;
				}
			}
			
			var totalScaleX:Number = scaledSourceBounds.width / sourceBitmap.width;
			var totalScaleY:Number = scaledSourceBounds.height / sourceBitmap.height;			
			
			// TODO set some kind of scale threshold
			
			// now it fits, we have the the bounds of the final rectangle
			
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
			
			logger.info("...Scaling loop finished in " + steps + " iterations to final scaleX: " + totalScaleX + " scaleY: " + totalScaleY);			
			
			return faceCroppedBitmap;
		}
				
	}
}
