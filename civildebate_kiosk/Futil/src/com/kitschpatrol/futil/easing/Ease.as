package com.kitschpatrol.futil.easing {
	
	public class Ease {
		public function Ease()

		public static function easeInExpo(t:Number, b:Number, c:Number, d:Number):Number {
			return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b - c * 0.001;
		}
		
		public static function easeOutExpo(t:Number, b:Number, c:Number, d:Number):Number {
			return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
		}
		
		public static function easeInOutExpo(t:Number, b:Number, c:Number, d:Number):Number {
			if (t==0) return b;
			if (t==d) return b+c;
			if ((t/=d*0.5) < 1) return c*0.5 * Math.pow(2, 10 * (t - 1)) + b;
			return c*0.5 * (-Math.pow(2, -10 * --t) + 2) + b;
		}
		
		

		// Out and ins
		// Via http://forums.greensock.com/viewtopic.php?f=1&t=2648
		
		public static function easeOutInQuad(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return -c/2 * (--t*t - 1) + b;
			return c/2*(--t*t + 1) + b;
		}
		
		public static function easeOutInQuart (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2)<1) return -c/2*(--t*t*t*t-1)+b;
			return c/2*(--t*t*t*t+1)+b;
		}
		
		public static function easeOutInCirc(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return c/2 * Math.sqrt(1 - --t*t)  + b;
			return c/2 * (2-Math.sqrt(1 - --t*t) ) + b;
		}
		
		public static function easeOutInBack(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
			if ((t/=d/2) < 1) return c/2*(--t*t*(((s*=(1.525))+1)*t + s) + 1) + b;
			return c/2*(--t*t*(((s*=(1.525))+1)*t - s) + 1) + b;
		}		
		
		
		public static function easeOutInElastic(t:Number, b:Number, c:Number, d:Number, a:Number, p:Number):Number {
			var s:Number;
			if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
			if (!a ||a < Math.abs(c)) {a=c; s = p/4;}
			else s = p/(2*Math.PI) * Math.asin (c/a);
			if (t < 1) return .5*(a*Math.pow(2,-10*t) * Math.sin((t*d-s)*(2*Math.PI)/p))+c/2+b;
			return c/2 +.5*(a*Math.pow(2,10*(t-2)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		}		
		
		
		public static function easeOutBounce(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d) < (1/2.75)) {
				return c*(7.5625*t*t) + b;
			} else if (t < (2/2.75)) {
				return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
			} else if (t < (2.5/2.75)) {
				return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
			} else {
				return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
			}
		}		

		public static function easeInBounce(t:Number, b:Number, c:Number, d:Number):Number {
			return c - easeOutBounce(d-t, 0, c, d) + b;
		}
		
		public static function easeOutInBounce(t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d/2) return easeOutBounce (t*2, 0, c, d) * .5 + b;
			return easeInBounce(t*2-d, 0, c, d) * .5 + c*.5 + b;
		}
		
		
		
		public static function easeOutInExpo(t:Number, b:Number, c:Number, d:Number):Number {
			if (t==0) return b;
			if (t==d) return b+c;
			if ((t/=d/2) < 1) return c/2 * (-Math.pow(2, -10 * t) + 1) + b;
			return c/2 * (Math.pow(2, 10 * (t-2))+1) + b;
		}		
		
		public static function easeOutInQuint(t:Number, b:Number, c:Number, d:Number):Number {
			t/=d/2;
			return c/2*(--t*t*t*t*t+1) + b;
		}
		
		public static function easeOutInSine (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t /= d/2)<1) return c/2 * (Math.sin(Math.PI*t/2) ) + b;
			return -c/2 * (Math.cos(Math.PI*--t/2)-2) + b;
		}		
		
		public static function easeOutInCubic(t:Number, b:Number, c:Number, d:Number):Number {
			var ts:Number=(t/=d)*t;
			var tc:Number=ts*t;
			return b+c*(4*tc + -6*ts + 3*t);
		}		
		
		
		public static function easeOutInStrong(t:Number, b:Number, c:Number, d:Number):Number {
			t/=d/2;
			return c/2*(--t*t*t*t*t+1) + b;
		}		
		
	}
}