package com.kitschpatrol.futil {
	import flash.display.DisplayObjectContainer;
	
	public class Utilities {
		
		
		// Useful generic toString override?
		//public static fieldsToString
		
		
		
		// DO stuff
		// https://github.com/mattupstate/AS3-Toolkit/blob/master/src/net/nobien/utils/DisplayObjectUtil.as		
		
		// PENDING PACKAGE CATEGORIZATION
		
		
		
		
		// return children removed
		public static function removeChildren(o:DisplayObjectContainer):uint {
			var numRemoved:uint = 0;
			while (o.numChildren > 0) {
				o.removeChild(o.getChildAt(0));
				numRemoved++;				
			}						
			return numRemoved;
		}		
		
		
		// via http://www.actionscript.org/forums/showthread.php3?t=158117
		// TODO only works for dynamic objects, need to split for reflection
		public static function traceObject(obj:*, level:int = 0):void {
			var tabs:String = "";
			
			for (var i:int = 0; i < level; i++)	tabs += "\t";
			
			for (var prop:String in obj) {
				trace(tabs + "[" + prop + "] -> " + obj[ prop ]);
				traceObject(obj[ prop ], level + 1);
			}
		}
		
		
		
		
		
		
		public static function dummyText(characters:int):String {
			var sourceText:Array = ['Lorem', 'ipsum', 'dolor', 'sit', 'amet', 'ceteros', 'torquatos', 'et', 'sea', 'Ea', 'utroque', 'explicari', 'concludaturque', 'nec', 'Nam', 'te', 'stet', 'assentior', 'reformidans', 'Ei', 'posse', 'volumus', 'duo', 'Ea', 'est', 'simul', 'dolore', 'nusquam', 'ei', 'tacimates', 'mediocrem', 'vim', 'Suas', 'forensibus', 'vis', 'cu', 'prompta', 'diceret', 'adipiscing', 'sed', 'te', 'integre', 'malorum', 'docendi', 'ei', 'eam', 'Cu', 'ius', 'odio', 'soleat', 'prodesset', 'ut', 'ius', 'iisque', 'legendos', 'Admodum', 'tractatos', 'qui', 'ad', 'Quo', 'ne', 'appetere', 'pericula', 'intellegam', 'Ne', 'eos', 'veri', 'ignota', 'deserunt', 'idque', 'insolens', 'antiopam', 'his', 'at', 'Facilis', 'deseruisse', 'id', 'eos', 'Ei', 'vel', 'oratio', 'iisque', 'vim', 'probo', 'abhorreant', 'et', 'Ne', 'habeo', 'vidisse', 'rationibus', 'vim', 'ei', 'quo', 'solet', 'tacimates', 'dissentiet', 'Pro', 'ea', 'vitae', 'commodo', 'eripuit', 'Ut', 'ipsum', 'principes', 'similique', 'mel', 'id', 'sapientem', 'pertinacia', 'liberavisse', 'Ex', 'iusto', 'conclusionemque', 'has', 'veritus', 'oporteat', 'no', 'his', 'Gubergren', 'adipiscing', 'cu', 'nec', 'Cu', 'cum', 'prima', 'recusabo', 'impetus', 'aliquid', 'interpretaris', 'an', 'his', 'Pro', 'no', 'dicat', 'nulla', 'placerat', 'suas', 'adipiscing', 'ad', 'sed', 'No', 'suscipit', 'perfecto', 'accusata', 'his', 'pri', 'hinc', 'habeo', 'adhuc', 'in', 'Ea', 'mea', 'menandri', 'adipiscing', 'inimicus', 'voluptatum', 'persequeris', 'an', 'vix', 'sea', 'ut', 'agam', 'inermis', 'Adipisci', 'praesent', 'vim', 'eu', 'no', 'has', 'laudem', 'dolorum', 'Summo', 'mandamus', 'eu', 'sit', 'no', 'vidisse', 'insolens', 'duo', 'Est', 'no', 'omnis', 'viris', 'cu', 'sed', 'veri', 'oportere', 'philosophia', 'Te', 'ceteros', 'gubergren', 'posidonium', 'sea', 'Aperiri', 'docendi', 'vis', 'no', 'at', 'eos', 'clita', 'veritus', 'Qui', 'dicta', 'dissentias', 'et', 'mea', 'ei', 'novum', 'oratio', 'forensibus', 'est', 'dictas', 'quaestio', 'at', 'Mundi', 'philosophia', 'his', 'in', 'Qui', 'error', 'accusata', 'constituam', 'ne', 'at', 'bonorum', 'scriptorem', 'disputationi', 'eam', 'Ius', 'et', 'utinam', 'apeirian', 'dissentiunt', 'augue', 'graeci', 'te', 'est', 'voluptatum', 'scribentur', 'ei', 'est', 'Cu', 'has', 'recusabo', 'convenire', 'tincidunt', 'An', 'vel', 'mundi', 'euismod', 'expetenda', 'ut', 'probo', 'moderatius', 'pro', 'Nam', 'ne', 'oporteat', 'interesset', 'facer', 'appellantur', 'concludaturque', 'et', 'mel', 'Iuvaret', 'praesent', 'te', 'sit', 'ei', 'dico', 'democritum', 'vix', 'Sale', 'delicata', 'vis', 'ne', 'cu', 'noster', 'similique', 'quo', 'Persius', 'habemus', 'tractatos', 'sed', 'et', 'duo', 'paulo', 'diceret', 'probatus', 'et', 'Atqui', 'denique', 'insolens', 'et', 'vix', 'duo', 'mutat', 'nominavi', 'at', 'eu', 'postea', 'dissentias', 'vel', 'Duis', 'dicant', 'corrumpit', 'id', 'mea', 'cum', 'graeco', 'salutatus', 'ne', 'His', 'tale', 'fugit', 'adipisci', 'ut', 'eos', 'aeque', 'homero', 'soleat', 'ei', 'Ea', 'vis', 'prima', 'legendos', 'et', 'nec', 'semper', 'persecuti', 'Adhuc', 'ignota', 'an', 'cum', 'Id', 'his', 'etiam', 'partem', 'iracundia', 'mea', 'ad', 'iuvaret', 'discere', 'ea', 'mei', 'eligendi', 'molestie', 'petentium', 'Temporibus', 'intellegebat', 'eu', 'usu', 'et', 'eros', 'elit', 'conceptam', 'sea', 'Ea', 'eos', 'vidit', 'erant', 'eos', 'et', 'omnis', 'inani', 'legere', 'Eu', 'quo', 'novum', 'torquatos', 'efficiendi', 'eam', 'at', 'splendide', 'intellegebat', 'consequuntur', 'ornatus', 'conceptam', 'dissentias', 'vim', 'id', 'Pro', 'ne', 'iriure', 'detraxit', 'deserunt', 'te', 'pro', 'suscipit', 'officiis', 'atomorum', 'cetero', 'accumsan', 'est', 'no', 'Ne', 'puto', 'detracto', 'vis', 'munere', 'impetus', 'eos', 'at', 'Ad', 'pro', 'sapientem', 'reprimique', 'ipsum', 'vivendum', 'gubergren', 'qui', 'eu', 'Ea', 'iudico', 'aliquando', 'constituto', 'his', 'mucius', 'denique', 'no', 'has', 'ad', 'mei', 'dicta', 'impetus', 'His', 'in', 'fabulas', 'voluptua', 'oporteat', 'Eum', 'te', 'tation', 'scripta', 'sint', 'forensibus', 'no', 'nam', 'Erat', 'recusabo', 'temporibus', 'mea', 'no', 'Iusto', 'offendit', 'ut', 'vim', 'eum', 'ne', 'vidisse', 'incorrupte', 'Nec', 'errem', 'elitr', 'eirmod', 'ei', 'paulo', 'debitis', 'referrentur', 'ad', 'pro', 'Quo', 'ullum', 'velit', 'viris', 'in', 'Eam', 'tota', 'lobortis', 'ut', 'ei', 'nam', 'modo', 'novum', 'conclusionemque', 'Facer', 'libris', 'molestie', 'id', 'mei', 'Antiopam', 'conceptam', 'cu', 'vim', 'vim', 'modo', 'equidem', 'expetendis', 'in', 'Pro', 'ei', 'libris', 'aperiri', 'Duo', 'constituam', 'inciderint', 'ne', 'senserit', 'constituto', 'mel', 'te', 'Cum', 'tollit', 'definitionem', 'ad', 'Nam', 'albucius', 'disputando', 'ad', 'Summo', 'dissentias', 'efficiantur', 'quo', 'ei', 'ne', 'vel', 'veritus', 'interesset', 'Vim', 'ex', 'ponderum', 'perfecto', 'principes', 'Est', 'et', 'qualisque', 'pertinacia', 'usu', 'delenit', 'denique', 'praesent', 'at', 'Utamur', 'labores', 'neglegentur', 'an', 'his', 'Cum', 'ea', 'scripta', 'bonorum', 'maluisset', 'no', 'malis', 'nonumes', 'detracto', 'mel', 'Dicant', 'adipisci', 'has', 'at', 'No', 'viris', 'nostrud', 'pro', 'prompta', 'virtute', 'scripserit', 'nec', 'te', 'cu', 'duo', 'munere', 'melius', 'deleniti', 'Consequat', 'moderatius', 'ea', 'mei', 'summo', 'referrentur', 'eos', 'at', 'per', 'eu', 'facer', 'animal', 'Ne', 'tota', 'impedit', 'sententiae', 'per', 'vim', 'minim', 'repudiare', 'voluptaria', 'te', 'Eos', 'at', 'dicam', 'melius', 'intellegat', 'sit', 'sale', 'libris', 'cetero', 'id', 'Eu', 'nulla', 'detraxit', 'sit', 'Cum', 'ea', 'hinc', 'cibo', 'animal', 'Audire', 'luptatum', 'constituto', 'ex', 'mea', 'est', 'ea', 'tritani', 'assueverit', 'Dicant', 'voluptaria', 'te', 'has', 'eum', 'apeirian', 'consetetur', 'repudiandae', 'ne', 'Agam', 'concludaturque', 'sed', 'ei', 'nam', 'no', 'mutat', 'assum', 'tollit', 'Cu', 'mei', 'voluptua', 'delicata', 'hendrerit', 'Summo', 'regione', 'rationibus', 'ad', 'quo', 'graeco', 'probatus', 'singulis', 'ei', 'mea', 'His', 'mundi', 'nemore', 'forensibus', 'ea', 'Cum', 'an', 'veniam', 'pericula', 'Ad', 'nullam', 'indoctum', 'conceptam', 'est', 'Et', 'mea', 'erat', 'error', 'feugiat', 'Natum', 'movet', 'iudicabit', 'eu', 'vis', 'eum', 'no', 'nostrud', 'gloriatur', 'assueverit', 'Vix', 'in', 'oporteat', 'petentium', 'torquatos', 'per', 'at', 'justo', 'everti', 'Ut', 'nisl', 'sumo', 'tritani', 'pro', 'at', 'nam', 'clita', 'molestiae', 'concludaturque', 'pro', 'nominati', 'eleifend', 'efficiantur', 'at', 'Duo', 'congue', 'oblique', 'molestiae', 'et', 'duo', 'solum', 'nulla', 'aliquam', 'no', 'His', 'et', 'brute', 'commune', 'atomorum', 'eu', 'vis', 'mutat', 'graeci', 'philosophia', 'sea', 'ne', 'vidit', 'quidam', 'Cu', 'his', 'appetere', 'complectitur', 'Esse', 'mundi', 'menandri', 'vel', 'ex', 'Vis', 'ut', 'tritani', 'assentior', 'No', 'facete', 'civibus', 'argumentum', 'sed', 'in', 'quodsi', 'conclusionemque', 'duo', 'duo', 'adipiscing', 'scripserit', 'ut', 'Te', 'usu', 'oratio', 'blandit', 'deterruisset', 'Sumo', 'aliquam', 'partiendo', 'qui', 'an', 'simul', 'adipisci', 'scripserit', 'qui', 'ex', 'cum', 'id', 'veri', 'luptatum', 'No', 'alterum', 'tincidunt', 'sed', 'nam', 'id', 'ponderum', 'mandamus', 'Cu', 'ridens', 'temporibus', 'sea', 'mei', 'virtute', 'menandri', 'an', 'Deleniti', 'splendide', 'eu', 'mea', 'pro', 'aliquip', 'forensibus', 'interesset', 'te', 'Et', 'vel', 'ponderum', 'splendide', 'voluptatum', 'dissentias', 'vituperatoribus', 'cu', 'vel', 'Ea', 'nam', 'paulo', 'nullam', 'Ut', 'vel', 'graece', 'blandit', 'patrioque', 'Graece', 'verear', 'pertinax', 'vim', 'at', 'duo', 'sale', 'populo', 'epicurei', 'at', 'cu', 'delectus', 'accusata', 'duo', 'Ad', 'quo', 'simul', 'veritus', 'signiferumque', 'te', 'altera', 'eleifend', 'definiebas', 'sea', 'ad', 'nemore', 'reprimique', 'contentiones', 'nec', 'Vis', 'no', 'puto', 'accumsan', 'Fabulas', 'scaevola', 'iracundia', 'te', 'vim', 'Graeci', 'audiam', 'audire', 'in', 'vim', 'id', 'sea', 'fugit', 'ludus', 'ne', 'nec', 'fuisset', 'pericula', 'Altera', 'moderatius', 'pri', 'ne', 'Vel', 'utinam', 'postulant', 'et', 'Mea', 'labitur', 'vituperata', 'at', 'at', 'pri', 'autem', 'saepe', 'putant', 'prima', 'simul', 'saepe', 'ea', 'pro', 'Corpora', 'phaedrum', 'theophrastus', 'pri', 'et', 'sit', 'te', 'legendos', 'erroribus', 'Pri', 'ne', 'ferri', 'zril', 'populo', 'Te', 'denique', 'albucius', 'laboramus', 'eam', 'Duo', 'probo', 'maluisset', 'ne', 'ex', 'his', 'vide', 'velit', 'vitae', 'Elit', 'detracto', 'ei', 'sea', 'mandamus', 'praesent', 'est', 'te', 'prompta', 'menandri', 'ea', 'eam', 'Habeo', 'regione', 'te', 'has', 'ea', 'mei', 'tibique', 'accusamus', 'sea', 'in', 'placerat', 'consectetuer', 'Nec', 'latine', 'nusquam', 'incorrupte', 'ea', 'Vel', 'id', 'eirmod', 'atomorum', 'veniam', 'option', 'sea', 'no', 'Alii', 'eleifend', 'an', 'his', 'Sit', 'te', 'abhorreant', 'moderatius', 'Quo', 'no', 'suas', 'dicta', 'urbanitas', 'Ad', 'usu', 'praesent', 'vituperata', 'efficiendi', 'eam', 'an', 'impedit', 'hendrerit', 'reformidans', 'eu', 'cum', 'mundi', 'veritus', 'adolescens', 'Ut', 'pri', 'harum', 'iudicabit', 'theophrastus', 'Convenire', 'interpretaris', 'his', 'at', 'dicat', 'malorum', 'assentior', 'eu', 'per', 'elit', 'omnis', 'in', 'eum', 'Epicuri', 'percipit'];			
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
		
		
		public static function randomElement(a:Array):* {
			return a[randRange(0, a.length)];
		}	
		
		public static function randRange(low:int, high:int):int {
			return Math.floor(Math.random() * (high - low + 1) + low);			
		}			
		
		
	}
}