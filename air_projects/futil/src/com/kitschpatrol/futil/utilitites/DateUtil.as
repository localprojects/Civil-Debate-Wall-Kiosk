//-------------------------------------------------------------------------------
// Copyright (c) 2012 Eric Mika
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
// 	
// 	The above copyright notice and this permission notice shall be included in 
// 	all copies or substantial portions of the Software.
// 		
// 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// 	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// 	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// 	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT 
// 	OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
// 	THE	USE OR OTHER DEALINGS IN THE SOFTWARE.
//-------------------------------------------------------------------------------

package com.kitschpatrol.futil.utilitites {
	
	public class DateUtil {
		
		public static const monthNamesShort:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Sep", "Oct", "Nov", "Dec"];
		public static const monthNamesLong:Array = ["January", "February", "March", "April", "May", "June", "July", "September", "October", "November", "December"];
		public static const dayNamesShort:Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
		public static const dayNamesLong:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];		
		
		public static function parseJsonDate(s:String):Date {
			return DateUtil.parseW3CDTF(s.replace(" ", "T") + "Z");			
		}
		
		
		//Returns a string in the format YYYYMMDDHHMMSSMMMM, e.g. 200831415144243 
		public static function getNowTimestamp():String {
			var d:Date = new Date();
			return d.getFullYear().toString() + d.getMonth() + d.getDate() + d.getHours() + d.getMinutes() + d.getSeconds() + d.getMilliseconds();			
		}		
		

		
		// From Adobe's (Flex?) DateUtil.as
		
		public static function getShortMonthName(d:Date):String {
			return monthNamesShort[d.getMonth()];
		}
		
		
		// takes a three letter month and returns its index (0 indexed)
		public static function getShortMonthIndex(m:String):int {
			return monthNamesShort.indexOf(m);
		}
		
		
		public static function getFullMonthName(d:Date):String {
			return monthNamesLong[d.getMonth()];   
		}
		
		
		// takes a full month name and returns its index (0 indexed)		
		public static function getFullMonthIndex(m:String):int {
			return monthNamesLong.indexOf(m);
		}
		
		// Returns three letter day of week
		public static function getShortDayName(d:Date):String {
			return dayNamesShort[d.getDay()];      
		}
		
		// Takes a short day
		public static function getShortDayIndex(d:String):int {
			return dayNamesShort.indexOf(d);
		}
		
		public static function getFullDayName(d:Date):String {
			return dayNamesLong[d.getDay()];       
		}               
		
		
		public static function getFullDayIndex(d:String):int {
			return dayNamesLong.indexOf(d);
		}
		
		
		// Two digit year,  e.g. 85      
		public static function getShortYear(d:Date):String {
			var dStr:String = String(d.getFullYear());
			
			if (dStr.length < 3) {
				return dStr;
			}
			
			return (dStr.substr(dStr.length - 2));
		}
		
		
		// d1 > d2 returns -1
		// d1 == d2 returns 0
		// d1 < d2 = 1
		public static function compareDates(d1:Date, d2:Date):int {
			var d1ms:Number = d1.getTime();
			var d2ms:Number = d2.getTime();
			
			if (d1ms > d2ms)	{
				return -1;
			}
			else if (d1ms < d2ms) {
				return 1;
			}
			else {
				return 0;
			}
		}
		
		
		// Returns hour, 0 to 12 regardless of AM or PM
		public static function getShortHour(d:Date):int {
			var h:int = d.hours;
			
			if (h == 0 || h == 12) {
				return 12;
			}
			else if (h > 12)	{
				return h - 12;
			}
			else {
				return h;
			}
		}
		
		public static function getAMPM(d:Date):String {
			return (d.hours > 11) ? "PM" : "AM";
		}
		
		
		// This function is useful for parsing RSS .91, .92, and 2.0 dates.
		// Also supports supports four-digit years (not supported in RFC822)
		// And two-digit years (referring to the 20th century)		
		// See http://asg.web.cmu.edu/rfc/rfc822.html
		public static function parseRFC822(str:String):Date	{
			var finalDate:Date;
			try	{
				var dateParts:Array = str.split(" ");
				var day:String = null;
				
				if (dateParts[0].search(/\d/) == -1) {
					day = dateParts.shift().replace(/\W/, "");
				}
				
				var date:Number = Number(dateParts.shift());
				var month:Number = Number(DateUtil.getShortMonthIndex(dateParts.shift()));
				var year:Number = Number(dateParts.shift());
				var timeParts:Array = dateParts.shift().split(":");
				var hour:Number = int(timeParts.shift());
				var minute:Number = int(timeParts.shift());
				var second:Number = (timeParts.length > 0) ? int(timeParts.shift()): 0;
				var milliseconds:Number = Date.UTC(year, month, date, hour, minute, second, 0);
				var timezone:String = dateParts.shift();
				var offset:Number = 0;
				
				if (timezone.search(/\d/) == -1) {
					switch(timezone) {
						case "UT":
							offset = 0;
							break;
						case "UTC":
							offset = 0;
							break;
						case "GMT":
							offset = 0;
							break;
						case "EST":
							offset = (-5 * 3600000);
							break;
						case "EDT":
							offset = (-4 * 3600000);
							break;
						case "CST":
							offset = (-6 * 3600000);
							break;
						case "CDT":
							offset = (-5 * 3600000);
							break;
						case "MST":
							offset = (-7 * 3600000);
							break;
						case "MDT":
							offset = (-6 * 3600000);
							break;
						case "PST":
							offset = (-8 * 3600000);
							break;
						case "PDT":
							offset = (-7 * 3600000);
							break;
						case "Z":
							offset = 0;
							break;
						case "A":
							offset = (-1 * 3600000);
							break;
						case "M":
							offset = (-12 * 3600000);
							break;
						case "N":
							offset = (1 * 3600000);
							break;
						case "Y":
							offset = (12 * 3600000);
							break;
						default:
							offset = 0;
					}
				}
				else {
					var multiplier:Number = 1;
					var oHours:Number = 0;
					var oMinutes:Number = 0;
					if (timezone.length != 4) {
						if (timezone.charAt(0) == "-") {
							multiplier = -1;
						}
						timezone = timezone.substr(1, 4);
					}
					oHours = Number(timezone.substr(0, 2));
					oMinutes = Number(timezone.substr(2, 2));
					offset = (((oHours * 3600000) + (oMinutes * 60000)) * multiplier);
				}
				
				finalDate = new Date(milliseconds - offset);
				
				if (finalDate.toString() == "Invalid Date")	{
					throw new Error("This date does not conform to RFC822.");
				}
			}
			catch (e:Error)
			{
				var eStr:String = "Unable to parse the string [" +str+ "] into a date. ";
				eStr += "The internal error was: " + e.toString();
				throw new Error(eStr);
			}
			return finalDate;
		}
		
		// Returns a date string formatted according to RFC822.
		// @see http://asg.web.cmu.edu/rfc/rfc822.html      
		public static function toRFC822(d:Date):String {
			var date:Number = d.getUTCDate();
			var hours:Number = d.getUTCHours();
			var minutes:Number = d.getUTCMinutes();
			var seconds:Number = d.getUTCSeconds();
			var sb:String = new String();
			sb += dayNamesShort[d.getUTCDay()];
			sb += ", ";
			
			if (date < 10) {
				sb += "0";
			}
			sb += date;
			sb += " ";
			//sb += DateUtil.SHORT_MONTH[d.getUTCMonth()];
			sb += monthNamesShort[d.getUTCMonth()];
			sb += " ";
			sb += d.getUTCFullYear();
			sb += " ";
			if (hours < 10)
			{                       
				sb += "0";
			}
			sb += hours;
			sb += ":";
			if (minutes < 10)
			{                       
				sb += "0";
			}
			sb += minutes;
			sb += ":";
			if (seconds < 10) {                       
				sb += "0";
			}
			sb += seconds;
			sb += " GMT";
			return sb;
		}
		
		
		// Parses dates that conform to the W3C Date-time Format into Date objects.
		// This function is useful for parsing RSS 1.0 and Atom 1.0 dates.
		// See http://www.w3.org/TR/NOTE-datetime
		public static function parseW3CDTF(str:String):Date	{
			var finalDate:Date;
			try	{
				var dateStr:String = str.substring(0, str.indexOf("T"));
				var timeStr:String = str.substring(str.indexOf("T")+1, str.length);
				var dateArr:Array = dateStr.split("-");
				var year:Number = Number(dateArr.shift());
				var month:Number = Number(dateArr.shift());
				var date:Number = Number(dateArr.shift());
				
				var multiplier:Number;
				var offsetHours:Number;
				var offsetMinutes:Number;
				var offsetStr:String;
				
				if (timeStr.indexOf("Z") != -1) {
					multiplier = 1;
					offsetHours = 0;
					offsetMinutes = 0;
					timeStr = timeStr.replace("Z", "");
				}
				else if (timeStr.indexOf("+") != -1) {
					multiplier = 1;
					offsetStr = timeStr.substring(timeStr.indexOf("+")+1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":")+1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("+"));
				}
				else {
					// offset is -					
					multiplier = -1;
					offsetStr = timeStr.substring(timeStr.indexOf("-")+1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":")+1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("-"));
				}
				var timeArr:Array = timeStr.split(":");
				var hour:Number = Number(timeArr.shift());
				var minutes:Number = Number(timeArr.shift());
				var secondsArr:Array = (timeArr.length > 0) ? String(timeArr.shift()).split(".") : null;
				var seconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				//var milliseconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				
				var milliseconds:Number = (secondsArr != null && secondsArr.length > 0) ? 1000*parseFloat("0." + secondsArr.shift()) : 0; 
				var utc:Number = Date.UTC(year, month-1, date, hour, minutes, seconds, milliseconds);
				var offset:Number = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
				finalDate = new Date(utc - offset);
				
				if (finalDate.toString() == "Invalid Date") {
					throw new Error("This date does not conform to W3CDTF.");
				}
			}
			catch (e:Error)	{
				var eStr:String = "Unable to parse the string [" +str+ "] into a date. ";
				eStr += "The internal error was: " + e.toString();
				throw new Error(eStr);
			}
			return finalDate;
		}
		
		
		// Returns a date string formatted according to W3CDTF.
		// See http://www.w3.org/TR/NOTE-datetime
		// includeMilliseconds puts milliseconds value in the formatted string
		public static function toW3CDTF(d:Date, includeMilliseconds:Boolean=false):String {
			var date:Number = d.getUTCDate();
			var month:Number = d.getUTCMonth();
			var hours:Number = d.getUTCHours();
			var minutes:Number = d.getUTCMinutes();
			var seconds:Number = d.getUTCSeconds();
			var milliseconds:Number = d.getUTCMilliseconds();
			var sb:String = new String();
			
			sb += d.getUTCFullYear();
			sb += "-";
			
			//thanks to "dom" who sent in a fix for the line below
			if (month + 1 < 10) {
				sb += "0";
			}
			sb += month + 1;
			sb += "-";
			if (date < 10) {
				sb += "0";
			}
			sb += date;
			sb += "T";
			if (hours < 10)	{
				sb += "0";
			}
			sb += hours;
			sb += ":";
			if (minutes < 10) {
				sb += "0";
			}
			sb += minutes;
			sb += ":";
			if (seconds < 10) {
				sb += "0";
			}
			sb += seconds;
			if (includeMilliseconds && milliseconds > 0) {
				sb += ".";
				sb += milliseconds;
			}
			sb += "-00:00";
			return sb;
		}
		
		
		// Converts a date into just after midnight.
		public static function makeMorning(d:Date):Date {
			var d:Date = new Date(d.time);
			d.hours = 0;
			d.minutes = 0;
			d.seconds = 0;
			d.milliseconds = 0;
			return d;
		}
		
		
		// Converts a date into just befor midnight.
		public static function makeNight(d:Date):Date {
			var d:Date = new Date(d.time);
			d.hours = 23;
			d.minutes = 59;
			d.seconds = 59;
			d.milliseconds = 999;                               
			return d;
		}
		
		
		// Sort of converts a date into UTC.
		public static function getUTCDate(d:Date):Date {
			var nd:Date = new Date();
			var offset:Number = d.getTimezoneOffset() * 60 * 1000; 
			nd.setTime(d.getTime() + offset);
			return nd;
		}		
		
	}
}
