package com.kitschpatrol.futil { 
	
	// Via matt's library
		import flash.events.ErrorEvent;
		import flash.events.Event;
		import flash.events.EventDispatcher;
		import flash.events.IOErrorEvent;
		import flash.net.URLLoader;
		import flash.net.URLRequest;
		import flash.utils.Dictionary;
		
		/**
		 * The LipsumUtil class contains static utility functions for generating lorem ipsum text.
		 */
		public class LipsumUtil
		{
			private static var _dispatcher:EventDispatcher = new EventDispatcher();
			private static var _cache:Dictionary = new Dictionary();
			private static var _currentQuery:String = "";
			
			public static const END_POINT:String = "http://www.lipsum.com/feed/xml/"
			public static const TYPE_PARAGRAPHS:String = "paras";
			public static const TYPE_WORDS:String = "words";
			public static const TYPE_BYTES:String = "bytes";
			public static const TYPE_LISTS:String = "lists";
			
			/**
			 * Generated lorem ipsum content.
			 */
			public static var lipsum:String = "";
			
			private static function onServiceResponse( event:Event ):void 
			{
				var l:URLLoader = event.target as URLLoader;
				l.removeEventListener( Event.COMPLETE, onServiceResponse );
				l.removeEventListener( IOErrorEvent.IO_ERROR, onServiceResponse );
				
				if( event.type == Event.COMPLETE )
				{
					lipsum = _cache[_currentQuery] = parseResponse( new XML( l.data ) );
					dispatchEvent( new Event( Event.COMPLETE ) );
				}
				else
				{
					lipsum = "ERROR";
					dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "Error: Could not access lipsum service at: " + END_POINT + _currentQuery ) );
				}
			}
			
			private static function parseResponse( data:XML ):String
			{
				return data.lipsum.toString();
			}
			
			/**
			 * Queries the Lorem Ipsum service.
			 * @param	queryString The URL of the lipsum service.
			 */
			public static function queryLipsumService( queryString:String ):void
			{
				_currentQuery = queryString;
				var l:URLLoader = new URLLoader();
				l.addEventListener( Event.COMPLETE, onServiceResponse );
				l.addEventListener( IOErrorEvent.IO_ERROR, onServiceResponse );
				l.load( new URLRequest( END_POINT + _currentQuery ) );
			}
			
			/**
			 * Get's lorem ipsum content if available. If not, it will automatically query the lipsum service
			 * and thus you should wait for the response.
			 * @param	amount  The amount of conten to generate.
			 * @param	type The type of content to generate in the form of LipsumUtil.type.
			 * @param	startWithLoremIpsum Flag to start with "Lorem ipsum"
			 * @return  Generated lorem ipsum if cached. If not an empty string.
			 */
			public static function getLipsum( amount:int, type:String, startWithLoremIpsum:Boolean = true ):String
			{
				var start:String = ( startWithLoremIpsum ) ? "yes" : "no";
				var queryString:String = "?amount=" + amount.toString() + "&what=" + type + "&start=" + start;
				var result:String = ( _cache[queryString] != null ) ? _cache[queryString] : "";
				
				if( result.length == 0 )
				{
					queryLipsumService( queryString );
				}
				
				return result;
			}
			
			/**
			 * Registers an event listener.
			 * @param type Event type.
			 * @param listener Event listener.
			 * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.
			 * @param priority The priority level of the event listener.
			 * @param useWeakReference Determines whether the reference to the listener is strong or weak.
			 */
			public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
			{
				_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
			
			/**
			 * Removes an event listener.
			 * @param type Event type.
			 * @param listener Event listener.
			 */
			public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
			{
				_dispatcher.removeEventListener(type, listener, useCapture);
			}
			
			/**
			 * Dispatches an event to all the registered listeners. 
			 * @param event Event object.
			 */
			public static function dispatchEvent(event:Event):Boolean 
			{
				return _dispatcher.dispatchEvent(event);
			}
		}
	}