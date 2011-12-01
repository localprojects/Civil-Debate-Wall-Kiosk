package com.kitschpatrol.futil
{
	import flash.utils.describeType;

	/**
	 * Converts any object or instance of a class into a readable string.
	 * 
	 * @param obj Object.
	 * @param omitNull Omits values that are null or empty.
	 * @param depth How many levels should be looked at [obj-0][depth-1][depth-2][depth-N].
	 * @param indent Tabbing to make reading easier, this will increment with each depth level. -internal
	 * @param prefix Prefixes output with variable name. -internal
	 */
	public function toStr(obj : Object, omitNull : Boolean = true, depth : uint = 0, indent : uint = 0, prefix : String = "") : String
	{
		if(obj)
		{
			// Get the description of the class
			var description : XML = describeType(obj);
			var properties : Array = [];

			// Get accessors from description
			for each(var a:XML in description.accessor)
			{
				properties.push(String(a.@name));
			}

			// Get variables from description
			for each(var v:XML in description.variable)
			{
				properties.push(String(v.@name));
			}

			// Get dynamic properties if the class is dynamic
			if(description.@isDynamic == "true")
			{
				for(var p : String in obj)
				{
					properties.push(p);
				}
			}
			// Sort
			properties.sort();

			// Build the string with properties and values
			var tabs : String = "";
			for(var t : int = 0; t < indent; t++)
			{
				tabs += "|\t";
			}
			var str : String = tabs + "[";
			if(prefix != "")
				str += prefix + ":";

			var desName : String = description.@name;
			str += (desName.search("::") == -1) ? desName : desName.slice(desName.search("::") + 2, desName.length);

			var appendAfter : Array = [];

			var pL : int = properties.length;
			for(var i : int = 0;i < pL;i++)
			{
				var mustOutput : Boolean = true;

				if(omitNull)
				{
					try
					{
						if(obj[properties[i]] == null || obj[properties[i]] == undefined || obj[properties[i]] === "")
							mustOutput = false;
					}
					catch(err : Error)
					{
						mustOutput = false;
					}
				}

				if(mustOutput)
				{
					if(depth > 0 && (typeof obj[properties[i]] == "object"))
						appendAfter.push(properties[i]);
					else
						str += " | " + properties[i] + " = " + obj[properties[i]];
				}
			}
			str += "]";

			depth--;
			indent++;

			var aL : int = appendAfter.length;
			for(var k : int = 0; k < aL; k++)
			{
				str += "\n" + toStr(obj[appendAfter[k]], omitNull, depth, indent, appendAfter[k]);
			}

			return str;
		}

		return "";
	}
}
