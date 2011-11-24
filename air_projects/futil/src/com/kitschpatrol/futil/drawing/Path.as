// From senocular... MIT license

package com.kitschpatrol.futil.drawing {
	
	import flash.geom.Point;
	
	/**
	 * The Path class saves a collection of line drawing commands to represent a path.
	 * Using the path class you can draw all of or a segment of that path in a movie clip
	 * or get locations and orientations along the path to have objects follow it.
	 *
	 * Note: People using Flash MX 2004 will have to use a custom flash.geom.Point class
	 * 
	 * @usage
	 * <pre><code>import com.senocular.drawing.Path;
	 * // create a path instance that draws in _root
	 * var myPath:Path = new Path();
	 * // draw a square in the path
	 * myPath.moveTo(50, 50);
	 * myPath.lineTo(100, 50);
	 * myPath.lineTo(100, 100);
	 * myPath.lineTo(50, 100);
	 * myPath.lineTo(50, 50);
	 * // draw the path in _root
	 * graphics.lineStyle(0, 0, 100);
	 * myPath.draw(graphics);
	 * </code></pre>
	 * @author Trevor McCauley, senocular.com
	 * @version 2.2.0
	 */
	public class Path {
		private var _lengthValid:Boolean = true;
		protected var _length:Number = 0;
		protected var _moveToHasLength:Boolean = false;
		protected var _position:Point;
		protected var _segments:Array;
		
		// Constructor
		/**
		 * Constructor. Creates a new path instance
		 */
		public function Path(){
			init();
		}
		
		// Public Properties
		/**
		 * The approximate length of the total path in pixels. 
		 * @see moveToHasLength
		 */
		public function get length():Number {
			if (!_lengthValid) {
				_lengthValid = true;
				_length = 0;
				var seg:PathSegment;
				var i:int = _segments.length;
				while (i--){
					seg = _segments[i];
					if (_moveToHasLength || !(seg is PathMoveSegment)){
						_length += seg.length;
					}
				}
			}
			return _length;
		}
		/**
		 * Determines whether or not moveTo commands are treated
		 * as line segments therefore adding to the total length of the path
		 * @see length
		 */
		public function get moveToHasLength():Boolean {
			return _moveToHasLength;
		}
		public function set moveToHasLength(b:Boolean):void {
			_lengthValid = false;
			_moveToHasLength = b;
		}
		/**
		 * The current position of the drawing pen based on the last drawing command used.
		 * If you want to move the pen position without invoking a moveTo command, set
		 * this property to a new point at the desired location
		 * @see moveTo
		 * @see lineTo
		 * @see curveTo
		 */
		public function get position():Point {
			return _position.clone();
		}
		public function set position(p:Point):void {
			_position = p.clone();
			_segments.push(new PathSegment(_position));
		}
		
		// Public Methods
		/**
		 * Moves the current drawing position to (x, y).
		 * @param x An integer indicating the horizontal location to move the drawing position
		 * @param y An integer indicating the vertical location to move the drawing position
		 * @see lineTo
		 * @see curveTo
		 * @return Nothing
		 */
		public function moveTo(x:Number, y:Number):void {
			if (_moveToHasLength){
				_lengthValid = false;
			}
			var end:Point = new Point(x, y);
			_segments.push(new PathMoveSegment(_position, end));
			_position = end;
		}
		
		public function moveToPoint(point:Point):void {
			moveTo(point.x, point.y);
		}
		
		/**
		 * Creates a line in the path from the current drawing position
		 * to (x, y); the current drawing position is then set to (x, y).
		 * @param x An integer indicating the horizontal position of the end anchor point of the line
		 * @param y An integer indicating the vertical position of the end anchor point of the line
		 * @see moveTo
		 * @see curveTo
		 * @return Nothing
		 */
		public function lineTo(x:Number, y:Number):void {
			_lengthValid = false;
			var end:Point = new Point(x, y);
			_segments.push(new PathLineSegment(_position, end));
			_position = end;
		}
		
		
		public function lineToPoint(point:Point):void {
			lineTo(point.x, point.y);
		}
		
		/**
		 * Creates a curve in the path from the current drawing position to
		 * (x, y) using the control point specified by (cx, cy). The current  drawing position is then set
		 * to (x, y).
		 * @param cx An integer that specifies the horizontal position of the control point of the curve
		 * @param cy An integer that specifies the vertical position of the control point of the curve
		 * @param x An integer that specifies the horizontal position of the end anchor point of the curve
		 * @param y An integer that specifies the vertical position of the end anchor point of the curve
		 * @see moveTo
		 * @see lineTo
		 * @return Nothing
		 */
		public function curveTo(cx:Number, cy:Number, x:Number, y:Number):void {
			_lengthValid = false;
			var end:Point = new Point(x, y);
			_segments.push(new PathCurveSegment(_position, new Point(cx, cy), end));
			_position = end;
		}
		
		public function curveToPoint(cPoint:Point, point:Point):void {
			curveTo(cPoint.x, cPoint.y, point.x, point.y);
		}
		
		/**
		 * Creates a circle segment in the path from the current drawing position to
		 * (x, y) using a third intermediary point (cx, cy) which lies on the circular path
		 * between the current drawing position and (x, y). The current  drawing position is then set
		 * to (x, y).
		 * @param cx An integer that specifies the horizontal position of the control point of the circle segment
		 * @param cy An integer that specifies the vertical position of the control point of the circle segment
		 * @param x An integer that specifies the horizontal position of the end anchor point of the circle segment
		 * @param y An integer that specifies the vertical position of the end anchor point of the circle segment
		 * @see moveTo
		 * @see lineTo
		 * @see curveTo
		 * @return Nothing
		 */
		public function circleTo(cx:Number, cy:Number, x:Number, y:Number):void {
			_lengthValid = false;
			var end:Point = new Point(x, y);
			_segments.push(new PathCircleSegment(_position, new Point(cx, cy), end));
			_position = end;
		}
		/**
		 * Clears all drawing commands in the path
		 * @see moveTo
		 * @see lineTo
		 * @see curveTo
		 * @return nothing
		 */
		public function clear():void {
			init();
		}
		/**
		 * Draws the saved path into the target object passed.
		 * @param target The object receiving a copy of the drawing commands saved to the path instance
		 * @param startt A float between 0 and 1 where 0 is the start of the path and 1 is the end of
		 * the path to start drawing in the target
		 * @param endt A float between 0 and 1 where 0 is the start of the path and 1 is the end of
		 * the path to stop drawing in the target
		 * @see moveTo
		 * @see lineTo
		 * @see curveTo
		 * @return Nothing
		 */
		public function draw(target:*, startt:Number = 0, endt:Number = 1):void {
			startt = cleant(startt, 0);
			endt = cleant(endt, 1);
			if (endt < startt){
				draw(target, startt, 1);
				draw(target, 0, endt);
				return;
			}
			var segments:Array = getSegmentsToDraw(startt, endt);
			if (segments.length){
				target.moveTo(segments[0]._start.x, segments[0]._start.y);
				var n:int = segments.length;
				var i:int;
				for (i=0; i<n; i++){
					segments[i].draw(target);
				}
			}
		}
		/**
		 * Gets the location of a point on the path at a specific location along the path
		 * @param t A float between 0 and 1 where 0 is the start of the path and 1 is the end of
		 * the path to find a point
		 * @return point along the path at the t location along the path
		 * @see angleAt
		 */
		public function pointAt(t:Number):Point {
			t = cleant(t);
			if (t == 0){
				return _segments[0].pointAt(t);
			}else if (t == 1){
				var last:int = _segments.length - 1;
				return _segments[last].pointAt(t);
			}
			var tLength:Number = t*length;
			var curLength:Number = 0;
			var lastLength:Number = 0;
			var seg:PathSegment;
			var n:int = _segments.length;
			var i:int;
			for (i=0; i<n; i++){
				seg = _segments[i];
				if ((_moveToHasLength || seg._command != "moveTo") && seg.length){
					curLength += seg.length;
				}else{
					continue;
				}
				if (tLength <= curLength){
					return seg.pointAt((tLength - lastLength)/seg.length);
				}
				lastLength = curLength;
			}
			return new Point(0, 0);
		}
		/**
		 * Gets the angle in radians of a point on the path at a specific location along the path
		 * @param t A float between 0 and 1 where 0 is the start of the path and 1 is the end of
		 * the path to find an angle
		 * @return angle along the path at the t location along the path
		 * @see pointAt
		 */
		public function angleAt(t:Number):Number {
			t = cleant(t);
			var tLength:Number = t*length;
			var curLength:Number = 0;
			var lastLength:Number = 0;
			var seg:PathSegment;
			var n:int = _segments.length;
			var i:int;
			for (i=0; i<n; i++){
				seg = _segments[i];
				if ((_moveToHasLength || seg._command != "moveTo") && seg.length){
					curLength += seg.length;
				}else{
					continue;
				}
				if (tLength <= curLength){
					return seg.angleAt((tLength - lastLength)/seg.length);
				}
				lastLength = curLength;
			}
			return 0;
		}
		
		// Private Methods
		private function init():void {
			_lengthValid = false;
			_segments = new Array();
			_position = new Point(0,0);
		}
		private function cleant(t:Number, base:Number = 0):Number {
			if (isNaN(t)) t = base;
			else if (t < 0 || t > 1){
				t %= 1;
				if (t == 0) t = base;
				else if (t < 0) t += 1;
			}
			return t;
		}
		private function getSegmentsToDraw(startt:Number, endt:Number):Array {
			if (startt == 0 && endt == 1) return _segments;
			
			var startLength:Number = startt*length;
			var endLength:Number = endt*length;
			var curLength:Number = 0;
			var lastLength:Number = 0;
			var starti:int = -1;
			var endi:int = -1;
			var segStartt:Number = 0;
			var segEndt:Number = 1;
			var newSegments:Array = new Array();
			var seg:PathSegment;
			var n:int = _segments.length;
			var i:int;
			
			for (i=0; i<n; i++){
				seg = _segments[i];
				if ((_moveToHasLength || seg._command != "moveTo") && seg.length){
					curLength += seg.length;
				}else{
					continue;
				}
				if (startLength < curLength && starti == -1){
					starti = i;
					segStartt = (startt == 0) ? 0 : (startLength - lastLength)/seg.length;
				}
				if (endLength <= curLength){
					endi = i;
					segEndt = (endt == 1) ? 1 : (endLength - lastLength)/seg.length;
					break;
				}
				lastLength = curLength;
			}
			if (endt == 1) endi = n-1;
			if (starti < 0 || endi < 0){
				return newSegments;
			}
			newSegments = _segments.slice(starti, endi + 1);
			if (starti == endi){
				if (segStartt != 0 || segEndt != 1){
					newSegments[0] = newSegments[0].segment(segStartt, segEndt);
				}
			}else{
				if (segStartt != 0){
					newSegments[0] = newSegments[0].segment(segStartt, 1);
				}
				if (segEndt != 1){
					var last:int = newSegments.length - 1;
					newSegments[last] = newSegments[last].segment(0, segEndt);
				}
			}
			return newSegments;
		}
	}
}

import flash.geom.Point;

class PathSegment {
	internal var _command:String = "moveTo";
	internal var _start:Point;
	internal var _end:Point;
	internal var _constructor:Class;
	protected var _length:Number;
	
	internal static var curveAccuracy:int = 5;
	
	// Constructor
	public function PathSegment(startPt:Point) {
		_start = startPt.clone();
		_end = _start;
		_constructor = prototype.constructor;
	}
	// Internal Properties
	internal function get command():String {
		return _command;
	}
	internal function get start():Point {
		return _start.clone();
	}
	internal function get end():Point {
		return _end.clone();
	}
	internal function get length():Number {
		return 0;
	}
	
	// Internal Methods
	internal function toString():String {
		return "["+command+"]";
	}
	internal function draw(target:*):void {
		target[command](_end.x, _end.y);
	}
	internal function trim(t:Number, fromStart:Boolean = false):PathSegment {
		return this;
	}
	internal function pointAt(t:Number, startPt:Point = null, endPt:Point = null):Point {
		return _start.clone();
	}
	internal function angleAt(t:Number, startPt:Point = null, endPt:Point = null):Number {
		return 0;
	}
}

class PathLineSegment extends PathSegment {
	
	// Constructor
	public function PathLineSegment(startPt:Point, endPt:Point){
		super(startPt);
		_end = endPt.clone();
		_command = "lineTo";
		_constructor = prototype.constructor;
	}
	
	// Internal Properties
	internal override function get length():Number {
		if (isNaN(_length)){
			_length = lineLength();
		}
		return _length;
	}
	// Internal Methods
	internal function segment(t1:Number, t2:Number):PathSegment {
		if (t2 == 1){
			if (t1 == 0) return this;
			return trim(t1, true);
		}
		var seg:PathSegment = trim(t2);
		if (t1 != 0){
			seg = seg.trim(t1/t2, true);
		}
		return seg;
	}
	internal override function trim(t:Number, fromStart:Boolean = false):PathSegment {
		var startPt:Point;
		var endPt:Point;
		if (fromStart){
			endPt = _start;
			startPt = _end;
			t = 1 - t;
		}else{
			startPt = _start;
			endPt = _end;
		}
		var newstart:Point = startPt;
		var newend:Point = startPt;
		var dx:Number = endPt.x - startPt.x;
		var dy:Number = endPt.y - startPt.y;
		if (fromStart){
			newstart = new Point(startPt.x + dx*t, startPt.y + dy*t);
		}else{
			newend = new Point(startPt.x + dx*t, startPt.y + dy*t);
		}
		return new _constructor(newstart, newend);
	}
	internal override function pointAt(t:Number, startPt:Point = null, endPt:Point = null):Point {
		if (!startPt) startPt = _start;
		if (!endPt) endPt = _end;
		var dx:Number = endPt.x - startPt.x;
		var dy:Number = endPt.y - startPt.y;
		return new Point(startPt.x + dx*t, startPt.y + dy*t);
	}
	internal override function angleAt(t:Number, startPt:Point = null, endPt:Point = null):Number {
		if (!startPt) startPt = _start;
		if (!endPt) endPt = _end;
		return Math.atan2(endPt.y - startPt.y, endPt.x - startPt.x);
	}
	
	// Protected Methods
	protected function lineLength(startPt:Point = null, endPt:Point = null):Number {
		if (!startPt) startPt = _start;
		if (!endPt) endPt = _end;
		var dx:Number = endPt.x - startPt.x;
		var dy:Number = endPt.y - startPt.y;
		return Math.sqrt(dx*dx + dy*dy);
	}
}

class PathMoveSegment extends PathLineSegment {
	
	// Constructor
	public function PathMoveSegment(startPt:Point, endPt:Point){
		super(startPt, endPt);
		_command = "moveTo";
		_constructor = prototype.constructor;
	}
}

class PathCurveSegment extends PathLineSegment {
	
	internal var _control:Point;
	
	// Constructor
	public function PathCurveSegment(startPt:Point, controlPt:Point, endPt:Point){
		super(startPt, endPt);
		_control = controlPt.clone();
		_command = "curveTo";
		_constructor = prototype.constructor;
	}
	
	// Internal Properties
	internal override function get length():Number {
		if (isNaN(_length)){
			_length = curveLength();
		}
		return _length;
	}
	internal function get control():Point {
		return _control.clone();
	}
	
	// Internal Methods
	internal override function draw(target:*):void  {
		target[command](_control.x, _control.y, _end.x, _end.y);
	}
	internal override function pointAt(t:Number, startPt:Point = null, endPt:Point = null):Point {
		var p1:Point = Point.interpolate(_control, _start, t);
		var p2:Point = Point.interpolate(_end, _control, t);
		return Point.interpolate(p2, p1, t);
	}
	internal override function angleAt(t:Number, startPt:Point = null, endPt:Point = null):Number {
		var startPt:Point = super.pointAt(t, _start, _control);
		var endPt:Point = super.pointAt(t, _control, _end);
		return super.angleAt(t, startPt, endPt);
	}
	internal override function trim(t:Number, fromStart:Boolean = false):PathSegment {
		var startPt:Point;
		var endPt:Point;
		if (fromStart){
			endPt = _start;
			startPt = _end;
			t = 1 - t;
		}else{
			startPt = _start;
			endPt = _end;
		}
		var newstart:Point = startPt;
		var newcontrol:Point;
		var newend:Point = startPt;
		var dscx:Number = _control.x - startPt.x;
		var dscy:Number = _control.y - startPt.y;
		var dcex:Number = endPt.x - _control.x;
		var dcey:Number = endPt.y - _control.y;
		var dx:Number;
		var dy:Number;
		newcontrol = new Point(startPt.x + dscx*t, startPt.y + dscy*t);
		dx = _control.x + dcex*t - newcontrol.x;
		dy = _control.y + dcey*t - newcontrol.y;
		if (fromStart){
			newstart = new Point(newcontrol.x + dx*t, newcontrol.y + dy*t);
		}else{
			newend = new Point(newcontrol.x + dx*t, newcontrol.y + dy*t);
		}
		return new _constructor(newstart, newcontrol, newend);
	}
	
	// Private Methods
	private function curveLength(startPt:Point = null, controlPt:Point = null, endPt:Point = null):Number {
		if (!startPt) startPt = _start;
		if (!controlPt) controlPt = _control;
		if (!endPt) endPt = _end;
		var dx:Number = endPt.x - startPt.x;
		var dy:Number = endPt.y - startPt.y;
		var cx:Number = (dx == 0) ? 0 : (controlPt.x - startPt.x)/dx;
		var cy:Number = (dy == 0) ? 0 : (controlPt.y - startPt.y)/dy;
		var f1:Number;
		var f2:Number;
		var t:Number;
		var d:Number = 0;
		var p:Point = startPt;
		var np:Point;
		var i:int;
		for (i=1; i<curveAccuracy; i++){
			t = i/curveAccuracy;
			f1 = 2*t*(1 - t);
			f2 = t*t;
			np = new Point(startPt.x + dx*(f1*cx + f2), startPt.y + dy*(f1*cy + f2));
			d += lineLength(p, np);
			p = np;
		}
		return d + lineLength(p, endPt);
	}
}

class PathCircleSegment extends PathLineSegment {
	
	private var _control:Point;
	private var _center:Point;
	private var radius:Number = 0;
	private var angleStart:Number = 0;
	private var angleEnd:Number = 0;
	private var arc:Number = 0;
	
	// Constructor
	public function PathCircleSegment(startPt:Point, controlPt:Point, endPt:Point) {
		super(startPt, endPt);
		_control = controlPt.clone();
		_command = "circleTo";
		_center = getCircleCenter(_start, _control, _end);
		_constructor = prototype.constructor;
		if (_center) {
			radius = lineLength(_start, _center);
			angleStart = Math.atan2(_start.y - _center.y, _start.x - _center.x);
			angleEnd = Math.atan2(_end.y - _center.y, _end.x - _center.x);
			if (angleEnd < angleStart) {
				angleEnd += Math.PI*2;
			}
			arc = angleEnd - angleStart;
		}
	}
	
	// Public Properties
	internal override function get length():Number {
		if (isNaN(_length)){
			_length = circleLength();
		}
		return _length;
	}
	internal function get control():Point {
		return _control.clone();
	}
	
	// Internal Methods
	internal override function draw(target:*):void {
		if (!_center) {
			return;
		}
		var a1:Number = angleStart;
		var a2:Number;
		var n:int = Math.floor(arc/(Math.PI/4)) + 1;
		var span:Number = arc/(2*n);
		var spanCos:Number = Math.cos(span);
		var rc:Number = (spanCos) ? radius/spanCos : 0;
		var i:int;
		for (i=0; i<n; i++) {
			a2 = a1 + span;
			a1 = a2 + span;
			target.curveTo(
				_center.x + Math.cos(a2)*rc,
				_center.y + Math.sin(a2)*rc,
				_center.x + Math.cos(a1)*radius,
				_center.y + Math.sin(a1)*radius
			);
		}
	}
	internal override function pointAt(t:Number, startPt:Point = null, endPt:Point = null):Point {
		if (!_center) {
			return _start.clone();
		}
		var angle:Number = angleStart + t*arc;
		return new Point(_center.x + Math.cos(angle)*radius, _center.y + Math.sin(angle)*radius);
	}
	internal override function angleAt(t:Number, startPt:Point = null, endPt:Point = null):Number {
		var angle:Number = (angleStart + t*arc + (Math.PI/2)) % (Math.PI*2);
		if (angle > Math.PI) {
			angle -= Math.PI*2;
		}else if (angle < -Math.PI) {
			angle += Math.PI*2;
		}
		return angle;
	}
	internal override function trim(t:Number, fromStart:Boolean = false):PathSegment {
		var startPt:Point;
		var endPt:Point;
		if (fromStart){
			endPt = _start;
			startPt = _end;
		}else{
			startPt = _start;
			endPt = _end;
		}
		var newstart:Point = startPt;
		var newcontrol:Point;
		var newend:Point = startPt;
		var angle:Number = angleStart + t*arc;
		if (fromStart){
			newstart = new Point(_center.x + Math.cos(angle)*radius, _center.y + Math.sin(angle)*radius);
			angle = (angleEnd + angle)/2;
		}else{
			newend = new Point(_center.x + Math.cos(angle)*radius, _center.y + Math.sin(angle)*radius);
			angle = (angleStart + angle)/2;
		}
		newcontrol = new Point(_center.x + Math.cos(angle)*radius, _center.y + Math.sin(angle)*radius);
		return new _constructor(newstart, newcontrol, newend);
	}
	
	// Private Methods
	private function circleLength():Number {
		return radius*arc;
	}
	
	private function getCircleCenter(p1:Point, p2:Point, p3:Point):Point {
		var tmp:Point;
		if (p1.x == p2.x || p1.y == p2.y) {
			tmp = p1;
			p1 = p3;
			p3 = tmp;
		}
		if (p2.x == p3.x) {
			tmp = p1;
			p1 = p2;
			p2 = tmp;
		}
		if (p1.x == p2.x || p2.x == p3.x) return null;
		var ma:Number = (p2.y - p1.y)/(p2.x - p1.x);
		var mb:Number = (p3.y - p2.y)/(p3.x - p2.x);
		if (ma == mb) return null;
		var x12:Number = p1.x + p2.x;
		var x23:Number = p2.x + p3.x;
		var x:Number = (ma*mb*(p1.y - p3.y) + mb*x12 - ma*x23)/(2*(mb - ma));
		var y:Number = (ma) ? (p1.y + p2.y)/2 - (x - x12/2)/ma : (p2.y + p3.y)/2 - (x - x23/2)/mb;
		return new Point(x,y);
	}
}
