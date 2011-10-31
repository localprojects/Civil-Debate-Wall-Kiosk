package com.kitschpatrol.futil.constants {
	
	public class Char {
		// set what we will factor into size based on combination of sets
		public static const SET_OF_UPPERCASE_LETTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		public static const SET_OF_LOWERCASE_LETTERS:String = "abcdefghijklmnopqrstuvwxyz";
		public static const SET_OF_NUMBERS:String = "1234567890";
		public static const SET_OF_PUNCTUATION:String = "!;':\",.?";
		public static const SET_OF_SYMBOLS:String = "-=@#$%^&*()_+{}|[]\/<>`~";
		public static const SET_OF_ASCENT_LETTERS:String = "AEFHIKLMNTVWXYZ"; // NO TOP OR BOTTOM ROUNDED characters that would break the baseline
		public static const SET_OF_DESCENT_LETTERS:String = "gjpqy";		
		
		// The above encompas all of ascii, here are some subsets
		public static const SET_OF_ALPHABET:String = SET_OF_UPPERCASE_LETTERS + SET_OF_LOWERCASE_LETTERS;
		public static const SET_OF_ALPHANUMERIC:String = SET_OF_ALPHABET + SET_OF_NUMBERS;
		public static const SET_OF_ASCENDERS_ONLY:String = SET_OF_UPPERCASE_LETTERS + "abcdefghiklmnorstuvwxz";
		public static const SET_OF_ALL_CHARACTERS:String = SET_OF_ALPHANUMERIC + SET_OF_PUNCTUATION + SET_OF_SYMBOLS;
		public static const SET_OF_CURRENT_CONTENT:String = "sizeForCustonSet"; // TODO resizes dynamically based on content of the text field
		
		// UTF stuff
		public static const LEFT_SINGLE_QUOTE:String = "\u2018";
		public static const RIGHT_SINGLE_QUOTE:String = "\u2019";
		public static const APOSTROPHE:String = RIGHT_SINGLE_QUOTE;
		public static const LEFT_QUOTE:String = "\u201C";
		public static const RIGHT_QUOTE:String = "\u201D";
		
	}
}