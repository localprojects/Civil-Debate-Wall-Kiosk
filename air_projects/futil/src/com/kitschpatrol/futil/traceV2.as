// via http://doesflash.com/2011/01/verbose-tostring-for-any-object-or-class/

package com.kitschpatrol.futil
{
	/**
	 * Converts any object or instance of a class into a readable string and traces the result.
	 * 
	 * @param obj Object.
	 * @param omitNull Omits values that are null or empty.
	 * @param depth How many levels should be looked at [obj-0][depth-1][depth-2][depth-N].
	 * @param indent Tabbing to make reading easier, this will increment with each depth level. -internal
	 * @param prefix Prefixes output with variable name. -internal
	 */
	public function traceV2(obj : Object, omitNull : Boolean = true, depth : uint = 0, indent : uint = 0, prefix : String = "") : void
	{
		trace(toStr(obj, omitNull, depth, indent, prefix));
	}
}
