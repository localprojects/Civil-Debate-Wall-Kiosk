package com.kitschpatrol.futil.utilitites {
	
	public class StringUtil	{
		
		
		
		// very crude implementation, but works in our case
		public static function plural(word:String, count:Number):String {
			if (count != 1) {
				return word + 's';
			}
			else {
				return word;
			}
		}
		
		
		public static function dummyText(characters:int):String {
			var sourceText:Array = ['Lorem', 'ipsum', 'dolor', 'sit', 'amet', 'ceteros', 'torquatos', 'et', 'sea', 'Ea', 'utroque', 'explicari', 'concludaturque', 'nec', 'Nam', 'te', 'stet', 'assentior', 'reformidans', 'Ei', 'posse', 'volumus', 'duo', 'Ea', 'est', 'simul', 'dolore', 'nusquam', 'ei', 'tacimates', 'mediocrem', 'vim', 'Suas', 'forensibus', 'vis', 'cu', 'prompta', 'diceret', 'adipiscing', 'sed', 'te', 'integre', 'malorum', 'docendi', 'ei', 'eam', 'Cu', 'ius', 'odio', 'soleat', 'prodesset', 'ut', 'ius', 'iisque', 'legendos', 'Admodum', 'tractatos', 'qui', 'ad', 'Quo', 'ne', 'appetere', 'pericula', 'intellegam', 'Ne', 'eos', 'veri', 'ignota', 'deserunt', 'idque', 'insolens', 'antiopam', 'his', 'at', 'Facilis', 'deseruisse', 'id', 'eos', 'Ei', 'vel', 'oratio', 'iisque', 'vim', 'probo', 'abhorreant', 'et', 'Ne', 'habeo', 'vidisse', 'rationibus', 'vim', 'ei', 'quo', 'solet', 'tacimates', 'dissentiet', 'Pro', 'ea', 'vitae', 'commodo', 'eripuit', 'Ut', 'ipsum', 'principes', 'similique', 'mel', 'id', 'sapientem', 'pertinacia', 'liberavisse', 'Ex', 'iusto', 'conclusionemque', 'has', 'veritus', 'oporteat', 'no', 'his', 'Gubergren', 'adipiscing', 'cu', 'nec', 'Cu', 'cum', 'prima', 'recusabo', 'impetus', 'aliquid', 'interpretaris', 'an', 'his', 'Pro', 'no', 'dicat', 'nulla', 'placerat', 'suas', 'adipiscing', 'ad', 'sed', 'No', 'suscipit', 'perfecto', 'accusata', 'his', 'pri', 'hinc', 'habeo', 'adhuc', 'in', 'Ea', 'mea', 'menandri', 'adipiscing', 'inimicus', 'voluptatum', 'persequeris', 'an', 'vix', 'sea', 'ut', 'agam', 'inermis', 'Adipisci', 'praesent', 'vim', 'eu', 'no', 'has', 'laudem', 'dolorum', 'Summo', 'mandamus', 'eu', 'sit', 'no', 'vidisse', 'insolens', 'duo', 'Est', 'no', 'omnis', 'viris', 'cu', 'sed', 'veri', 'oportere', 'philosophia', 'Te', 'ceteros', 'gubergren', 'posidonium', 'sea', 'Aperiri', 'docendi', 'vis', 'no', 'at', 'eos', 'clita', 'veritus', 'Qui', 'dicta', 'dissentias', 'et', 'mea', 'ei', 'novum', 'oratio', 'forensibus', 'est', 'dictas', 'quaestio', 'at', 'Mundi', 'philosophia', 'his', 'in', 'Qui', 'error', 'accusata', 'constituam', 'ne', 'at', 'bonorum', 'scriptorem', 'disputationi', 'eam', 'Ius', 'et', 'utinam', 'apeirian', 'dissentiunt', 'augue', 'graeci', 'te', 'est', 'voluptatum', 'scribentur', 'ei', 'est', 'Cu', 'has', 'recusabo', 'convenire', 'tincidunt', 'An', 'vel', 'mundi', 'euismod', 'expetenda', 'ut', 'probo', 'moderatius', 'pro', 'Nam', 'ne', 'oporteat', 'interesset', 'facer', 'appellantur', 'concludaturque', 'et', 'mel', 'Iuvaret', 'praesent', 'te', 'sit', 'ei', 'dico', 'democritum', 'vix', 'Sale', 'delicata', 'vis', 'ne', 'cu', 'noster', 'similique', 'quo', 'Persius', 'habemus', 'tractatos', 'sed', 'et', 'duo', 'paulo', 'diceret', 'probatus', 'et', 'Atqui', 'denique', 'insolens', 'et', 'vix', 'duo', 'mutat', 'nominavi', 'at', 'eu', 'postea', 'dissentias', 'vel', 'Duis', 'dicant', 'corrumpit', 'id', 'mea', 'cum', 'graeco', 'salutatus', 'ne', 'His', 'tale', 'fugit', 'adipisci', 'ut', 'eos', 'aeque', 'homero', 'soleat', 'ei', 'Ea', 'vis', 'prima', 'legendos', 'et', 'nec', 'semper', 'persecuti', 'Adhuc', 'ignota', 'an', 'cum', 'Id', 'his', 'etiam', 'partem', 'iracundia', 'mea', 'ad', 'iuvaret', 'discere', 'ea', 'mei', 'eligendi', 'molestie', 'petentium', 'Temporibus', 'intellegebat', 'eu', 'usu', 'et', 'eros', 'elit', 'conceptam', 'sea', 'Ea', 'eos', 'vidit', 'erant', 'eos', 'et', 'omnis', 'inani', 'legere', 'Eu', 'quo', 'novum', 'torquatos', 'efficiendi', 'eam', 'at', 'splendide', 'intellegebat', 'consequuntur', 'ornatus', 'conceptam', 'dissentias', 'vim', 'id', 'Pro', 'ne', 'iriure', 'detraxit', 'deserunt', 'te', 'pro', 'suscipit', 'officiis', 'atomorum', 'cetero', 'accumsan', 'est', 'no', 'Ne', 'puto', 'detracto', 'vis', 'munere', 'impetus', 'eos', 'at', 'Ad', 'pro', 'sapientem', 'reprimique', 'ipsum', 'vivendum', 'gubergren', 'qui', 'eu', 'Ea', 'iudico', 'aliquando', 'constituto', 'his', 'mucius', 'denique', 'no', 'has', 'ad', 'mei', 'dicta', 'impetus', 'His', 'in', 'fabulas', 'voluptua', 'oporteat', 'Eum', 'te', 'tation', 'scripta', 'sint', 'forensibus', 'no', 'nam', 'Erat', 'recusabo', 'temporibus', 'mea', 'no', 'Iusto', 'offendit', 'ut', 'vim', 'eum', 'ne', 'vidisse', 'incorrupte', 'Nec', 'errem', 'elitr', 'eirmod', 'ei', 'paulo', 'debitis', 'referrentur', 'ad', 'pro', 'Quo', 'ullum', 'velit', 'viris', 'in', 'Eam', 'tota', 'lobortis', 'ut', 'ei', 'nam', 'modo', 'novum', 'conclusionemque', 'Facer', 'libris', 'molestie', 'id', 'mei', 'Antiopam', 'conceptam', 'cu', 'vim', 'vim', 'modo', 'equidem', 'expetendis', 'in', 'Pro', 'ei', 'libris', 'aperiri', 'Duo', 'constituam', 'inciderint', 'ne', 'senserit', 'constituto', 'mel', 'te', 'Cum', 'tollit', 'definitionem', 'ad', 'Nam', 'albucius', 'disputando', 'ad', 'Summo', 'dissentias', 'efficiantur', 'quo', 'ei', 'ne', 'vel', 'veritus', 'interesset', 'Vim', 'ex', 'ponderum', 'perfecto', 'principes', 'Est', 'et', 'qualisque', 'pertinacia', 'usu', 'delenit', 'denique', 'praesent', 'at', 'Utamur', 'labores', 'neglegentur', 'an', 'his', 'Cum', 'ea', 'scripta', 'bonorum', 'maluisset', 'no', 'malis', 'nonumes', 'detracto', 'mel', 'Dicant', 'adipisci', 'has', 'at', 'No', 'viris', 'nostrud', 'pro', 'prompta', 'virtute', 'scripserit', 'nec', 'te', 'cu', 'duo', 'munere', 'melius', 'deleniti', 'Consequat', 'moderatius', 'ea', 'mei', 'summo', 'referrentur', 'eos', 'at', 'per', 'eu', 'facer', 'animal', 'Ne', 'tota', 'impedit', 'sententiae', 'per', 'vim', 'minim', 'repudiare', 'voluptaria', 'te', 'Eos', 'at', 'dicam', 'melius', 'intellegat', 'sit', 'sale', 'libris', 'cetero', 'id', 'Eu', 'nulla', 'detraxit', 'sit', 'Cum', 'ea', 'hinc', 'cibo', 'animal', 'Audire', 'luptatum', 'constituto', 'ex', 'mea', 'est', 'ea', 'tritani', 'assueverit', 'Dicant', 'voluptaria', 'te', 'has', 'eum', 'apeirian', 'consetetur', 'repudiandae', 'ne', 'Agam', 'concludaturque', 'sed', 'ei', 'nam', 'no', 'mutat', 'assum', 'tollit', 'Cu', 'mei', 'voluptua', 'delicata', 'hendrerit', 'Summo', 'regione', 'rationibus', 'ad', 'quo', 'graeco', 'probatus', 'singulis', 'ei', 'mea', 'His', 'mundi', 'nemore', 'forensibus', 'ea', 'Cum', 'an', 'veniam', 'pericula', 'Ad', 'nullam', 'indoctum', 'conceptam', 'est', 'Et', 'mea', 'erat', 'error', 'feugiat', 'Natum', 'movet', 'iudicabit', 'eu', 'vis', 'eum', 'no', 'nostrud', 'gloriatur', 'assueverit', 'Vix', 'in', 'oporteat', 'petentium', 'torquatos', 'per', 'at', 'justo', 'everti', 'Ut', 'nisl', 'sumo', 'tritani', 'pro', 'at', 'nam', 'clita', 'molestiae', 'concludaturque', 'pro', 'nominati', 'eleifend', 'efficiantur', 'at', 'Duo', 'congue', 'oblique', 'molestiae', 'et', 'duo', 'solum', 'nulla', 'aliquam', 'no', 'His', 'et', 'brute', 'commune', 'atomorum', 'eu', 'vis', 'mutat', 'graeci', 'philosophia', 'sea', 'ne', 'vidit', 'quidam', 'Cu', 'his', 'appetere', 'complectitur', 'Esse', 'mundi', 'menandri', 'vel', 'ex', 'Vis', 'ut', 'tritani', 'assentior', 'No', 'facete', 'civibus', 'argumentum', 'sed', 'in', 'quodsi', 'conclusionemque', 'duo', 'duo', 'adipiscing', 'scripserit', 'ut', 'Te', 'usu', 'oratio', 'blandit', 'deterruisset', 'Sumo', 'aliquam', 'partiendo', 'qui', 'an', 'simul', 'adipisci', 'scripserit', 'qui', 'ex', 'cum', 'id', 'veri', 'luptatum', 'No', 'alterum', 'tincidunt', 'sed', 'nam', 'id', 'ponderum', 'mandamus', 'Cu', 'ridens', 'temporibus', 'sea', 'mei', 'virtute', 'menandri', 'an', 'Deleniti', 'splendide', 'eu', 'mea', 'pro', 'aliquip', 'forensibus', 'interesset', 'te', 'Et', 'vel', 'ponderum', 'splendide', 'voluptatum', 'dissentias', 'vituperatoribus', 'cu', 'vel', 'Ea', 'nam', 'paulo', 'nullam', 'Ut', 'vel', 'graece', 'blandit', 'patrioque', 'Graece', 'verear', 'pertinax', 'vim', 'at', 'duo', 'sale', 'populo', 'epicurei', 'at', 'cu', 'delectus', 'accusata', 'duo', 'Ad', 'quo', 'simul', 'veritus', 'signiferumque', 'te', 'altera', 'eleifend', 'definiebas', 'sea', 'ad', 'nemore', 'reprimique', 'contentiones', 'nec', 'Vis', 'no', 'puto', 'accumsan', 'Fabulas', 'scaevola', 'iracundia', 'te', 'vim', 'Graeci', 'audiam', 'audire', 'in', 'vim', 'id', 'sea', 'fugit', 'ludus', 'ne', 'nec', 'fuisset', 'pericula', 'Altera', 'moderatius', 'pri', 'ne', 'Vel', 'utinam', 'postulant', 'et', 'Mea', 'labitur', 'vituperata', 'at', 'at', 'pri', 'autem', 'saepe', 'putant', 'prima', 'simul', 'saepe', 'ea', 'pro', 'Corpora', 'phaedrum', 'theophrastus', 'pri', 'et', 'sit', 'te', 'legendos', 'erroribus', 'Pri', 'ne', 'ferri', 'zril', 'populo', 'Te', 'denique', 'albucius', 'laboramus', 'eam', 'Duo', 'probo', 'maluisset', 'ne', 'ex', 'his', 'vide', 'velit', 'vitae', 'Elit', 'detracto', 'ei', 'sea', 'mandamus', 'praesent', 'est', 'te', 'prompta', 'menandri', 'ea', 'eam', 'Habeo', 'regione', 'te', 'has', 'ea', 'mei', 'tibique', 'accusamus', 'sea', 'in', 'placerat', 'consectetuer', 'Nec', 'latine', 'nusquam', 'incorrupte', 'ea', 'Vel', 'id', 'eirmod', 'atomorum', 'veniam', 'option', 'sea', 'no', 'Alii', 'eleifend', 'an', 'his', 'Sit', 'te', 'abhorreant', 'moderatius', 'Quo', 'no', 'suas', 'dicta', 'urbanitas', 'Ad', 'usu', 'praesent', 'vituperata', 'efficiendi', 'eam', 'an', 'impedit', 'hendrerit', 'reformidans', 'eu', 'cum', 'mundi', 'veritus', 'adolescens', 'Ut', 'pri', 'harum', 'iudicabit', 'theophrastus', 'Convenire', 'interpretaris', 'his', 'at', 'dicat', 'malorum', 'assentior', 'eu', 'per', 'elit', 'omnis', 'in', 'eum', 'Epicuri', 'percipit'];			
			var text:String = '';
			
			// Build the string
			while (text.length < (characters + 50)) {
				if (text.length == 0) {
					text += ArrayUtil.randomElement(sourceText);
				}
				else {
					text += ' ' + ArrayUtil.randomElement(sourceText);
				}
			}
			
			// Trim the extra
			text = text.substr(0, characters);
			
			return text;
		}				
		
		// returns a tuple (array) of start / end indexes for the search word (word, not phrase?)
		public static function searchString(needle:String, haystack:String, caseSensitive:Boolean = false):Array {
			
			// TODO Regex capture groups, instead?
			
			if (!caseSensitive) {
				needle = needle.toLowerCase();
				haystack = haystack.toLowerCase();				
			}
			
			// goodness gracious, this syntax...
			// http://stackoverflow.com/questions/6657179/using-a-variable-in-an-as3-regexp
			var regex:RegExp = new RegExp(/\b/.source + needle +  /\b/.source, 'g');			
			var indexes:Array = [];
			var offset:uint = 0;
			var substack:String = haystack; // this gets lopped off
			
			while (substack.search(regex) >= 0) {
				var leftIndex:uint = substack.search(regex);
				indexes.push([offset + leftIndex, offset + leftIndex + needle.length]);
				offset += leftIndex + needle.length;
				substack = substack.substr(leftIndex + needle.length);
			}
			
			return indexes;
		}
		
		
		// From Skinner's StringUtils.as class
		// Returns everything after the first occurrence of the provided character in the string.		
		public static function afterFirst(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.indexOf(p_char);
			if (idx == -1) { return ''; }
			idx += p_char.length;
			return p_string.substr(idx);
		}
		
		
		// Returns everything after the last occurrence of the provided character in the string.		
		public static function afterLast(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.lastIndexOf(p_char);
			if (idx == -1) { return ''; }
			idx += p_char.length;
			return p_string.substr(idx);
		}
		
		
		public static function beginsWith(p_string:String, p_begin:String):Boolean {
			if (p_string == null) { return false; }
			return p_string.indexOf(p_begin) == 0;
		}
		
		
		public static function beforeFirst(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.indexOf(p_char);
			if (idx == -1) { return ''; }
			return p_string.substr(0, idx);
		}
		
		
		public static function beforeLast(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.lastIndexOf(p_char);
			if (idx == -1) { return ''; }
			return p_string.substr(0, idx);
		}
		
		
		// everything after p_start and before p_end, exclusive
		public static function between(p_string:String, p_start:String, p_end:String):String {
			var str:String = '';
			if (p_string == null) { return str; }
			var startIdx:int = p_string.indexOf(p_start);
			if (startIdx != -1) {
				startIdx += p_start.length; // RM: should we support multiple chars? (or ++startIdx);
				var endIdx:int = p_string.indexOf(p_end, startIdx);
				if (endIdx != -1) { str = p_string.substr(startIdx, endIdx-startIdx); }
			}
			return str;
		}
		
		
		// Description, Utility method that intelligently breaks up your string, allowing you to create blocks of readable text.
		// This method returns you the closest possible match to the p_delim paramater, while keeping the text length within the p_len paramter.
		// If a match can't be found in your specified length an  '...' is added to that block, and the blocking continues untill all the text is broken apart.
		// p_string The string to break up.
		//  p_len Maximum length of each block of text.
		// p_delim delimter to end text blocks on, default = '.'
		public static function block(p_string:String, p_len:uint, p_delim:String = "."):Array {
			var arr:Array = new Array();
			if (p_string == null || !contains(p_string, p_delim)) { return arr; }
			var chrIndex:uint = 0;
			var strLen:uint = p_string.length;
			var replPatt:RegExp = new RegExp("[^"+escapePattern(p_delim)+"]+$");
			while (chrIndex <  strLen) {
				var subString:String = p_string.substr(chrIndex, p_len);
				if (!contains(subString, p_delim)){
					arr.push(truncate(subString, subString.length));
					chrIndex += subString.length;
				}
				subString = subString.replace(replPatt, '');
				arr.push(subString);
				chrIndex += subString.length;
			}
			return arr;
		}
		
		
		// all words to true to capitalize all words in the string
		public static function capitalize(p_string:String, allWords:Boolean = false):String {
			var str:String = trimLeft(p_string);
			if (allWords == true) { return str.replace(/^.|\b./g, _upperCase);}
			else { return str.replace(/(^\w)/, _upperCase); }
		}
		
		
		// Determines whether the specified string contains any instances of p_char.
		public static function contains(p_string:String, p_char:String):Boolean {
			if (p_string == null) { return false; }
			return p_string.indexOf(p_char) != -1;
		}
		
		
		//	Determines the number of times a charactor or sub-string appears within the string.
		public static function countOf(haystack:String, needle:String, p_caseSensitive:Boolean = true):uint {
			if (haystack == null) { return 0; }
			var char:String = escapePattern(needle);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return haystack.match(new RegExp(char, flags)).length;
		}
		
		
		//	Levenshtein distance (editDistance) is a measure of the similarity between two strings,
		//	The distance is the number of deletions, insertions, or substitutions required to
		//	transform p_source into p_target.
		public static function editDistance(p_source:String, p_target:String):uint {
			var i:uint;
			
			if (p_source == null) { p_source = ''; }
			if (p_target == null) { p_target = ''; }
			
			if (p_source == p_target) { return 0; }
			
			var d:Array = new Array();
			var cost:uint;
			var n:uint = p_source.length;
			var m:uint = p_target.length;
			var j:uint;
			
			if (n == 0) { return m; }
			if (m == 0) { return n; }
			
			for (i=0; i<=n; i++) { d[i] = new Array(); }
			for (i=0; i<=n; i++) { d[i][0] = i; }
			for (j=0; j<=m; j++) { d[0][j] = j; }
			
			for (i=1; i<=n; i++) {
				
				var s_i:String = p_source.charAt(i-1);
				for (j=1; j<=m; j++) {
					
					var t_j:String = p_target.charAt(j-1);
					
					if (s_i == t_j) { cost = 0; }
					else { cost = 1; }
					
					d[i][j] = _minimum(d[i-1][j]+1, d[i][j-1]+1, d[i-1][j-1]+cost);
				}
			}
			return d[n][m];
		}
		
		
		//	Determines whether the specified string ends with the specified suffix.
		public static function endsWith(p_string:String, p_end:String):Boolean {
			return p_string.lastIndexOf(p_end) == p_string.length - p_end.length;
		}
		
		
		//	Determines whether the specified string contains text.
		public static function hasText(p_string:String):Boolean {
			var str:String = removeExtraWhitespace(p_string);
			return !!str.length;
		}
		
		
		public static function isEmpty(p_string:String):Boolean {
			if (p_string == null) { return true; }
			return !p_string.length;
		}
		
		
		// Determines whether the specified string is numeric.
		public static function isNumeric(p_string:String):Boolean {
			if (p_string == null) { return false; }
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test(p_string);
		}
		
		
		// Pads p_string with specified character to a specified length from the left.
		public static function padLeft(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) { s = p_padChar + s; }
			return s;
		}
		
		
		// Pads p_string with specified character to a specified length from the right.
		public static function padRight(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) { s += p_padChar; }
			return s;
		}
		
		
		//	Properly cases' the string in "sentence format".
		public static function properCase(p_string:String):String {
			if (p_string == null) { return ''; }
			var str:String = p_string.toLowerCase().replace(/\b([^.?;!]+)/, capitalize);
			return str.replace(/\b[i]\b/, "I");
		}
		
		
		//	Escapes all of the characters in a string to create a friendly "quotable" sting
		public static function quote(p_string:String):String {
			var regx:RegExp = /[\\"\r\n]/g;
			return '"'+ p_string.replace(regx, _quote) +'"'; //"
		}
		
		
		//	Removes all instances of the remove string in the input string.
		public static function remove(p_string:String, p_remove:String, p_caseSensitive:Boolean = true):String {
			if (p_string == null) { return ''; }
			var rem:String = escapePattern(p_remove);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.replace(new RegExp(rem, flags), '');
		}
		
		
		//	Removes extraneous whitespace (extra spaces, tabs, line breaks, etc)
		public static function removeExtraWhitespace(p_string:String):String {
			if (p_string == null) { return ''; }
			var str:String = trim(p_string);
			return str.replace(/\s+/g, ' ');
		}
		
		
		// Reverse letters
		public static function reverse(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.split('').reverse().join('');
		}
		
		
		// Returns the specified string in reverse word order.
		public static function reverseWords(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.split(/\s+/).reverse().join('');
		}
		
		
		//	Determines the percentage of similiarity, based on editDistance ??
		public static function similarity(p_source:String, p_target:String):Number {
			var ed:uint = editDistance(p_source, p_target);
			var maxLen:uint = Math.max(p_source.length, p_target.length);
			if (maxLen == 0) { return 100; }
			else { return (1 - ed/maxLen) * 100; }
		}
		
		
		// removes <*> from string
		public static function stripTags(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/<\/?[^>]+>/igm, '');
		}
		
		
		//	Swaps the casing of a string.
		public static function swapCase(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/(\w)/, _swapCase);
		}
		
		
		// Removes whitespace from the front and the end of the specified
		public static function trim(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/^\s+|\s+$/g, '');
		}
		
		
		//	Removes whitespace from the front (left-side) of the specified string.
		public static function trimLeft(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/^\s+/, '');
		}
		
		
		//	Removes whitespace from the end (right-side) of the specified string.
		public static function trimRight(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/\s+$/, '');
		}
		
		
		//	Determines the number of words in a string.
		public static function wordCount(p_string:String):uint {
			if (p_string == null) { return 0; }
			return p_string.match(/\b\w+\b/g).length;
		}
		
		
		// Returns a string truncated to a specified length with optional suffix
		public static function truncate(p_string:String, p_len:uint, p_suffix:String = "..."):String {
			if (p_string == null) { return ''; }
			p_len -= p_suffix.length;
			var trunc:String = p_string;
			if (trunc.length > p_len) {
				trunc = trunc.substr(0, p_len);
				if (/[^\s]/.test(p_string.charAt(p_len))) {
					trunc = trimRight(trunc.replace(/\w+$|\s+$/, ''));
				}
				trunc += p_suffix;
			}
			
			return trunc;
		}
		
		/* **************************************************************** */
		/*	These are helper methods used by some of the above methods.		*/
		/* **************************************************************** */
		private static function escapePattern(p_pattern:String):String {
			// RM: might expose this one, I've used it a few times already.
			return p_pattern.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, '\\$1');
		}
		
		private static function _minimum(a:uint, b:uint, c:uint):uint {
			return Math.min(a, Math.min(b, Math.min(c,a)));
		}
		
		private static function _quote(p_string:String, ...args):String {
			switch (p_string) {
				case "\\":
					return "\\\\";
				case "\r":
					return "\\r";
				case "\n":
					return "\\n";
				case '"':
					return '\\"';
				default:
					return '';
			}
		}
		
		private static function _upperCase(p_char:String, ...args):String {
			return p_char.toUpperCase();
		}
		
		private static function _swapCase(p_char:String, ...args):String {
			var lowChar:String = p_char.toLowerCase();
			var upChar:String = p_char.toUpperCase();
			switch (p_char) {
				case lowChar:
					return upChar;
				case upChar:
					return lowChar;
				default:
					return p_char;
			}
		}		
		
		
	}
}