package sequent.core.collection;
import haxe.ds.Map;

/**
 * ...
 * @author JavidJafari
 */

abstract Set<T>(Map<T,Bool>) 
{
	inline function new(map:Map<T,Bool>){
		this = map;
	}
	
	@:from static public function fromArray(s:Iterable<Int>) {
		
		var map:Map<Int,Bool> = new Map<Int,Bool>();
		for (i in s) map.set(i, true);
		return new Set(map);
		
	}
	public function contains(s:T){
		
		return this.exists(s);
	}
	@:to public function toString()
    {
		return "{" + toArray().join(", ") + "}";
	}
	 @:to public function toArray() : Array<T> {
    var arr : Array<T> = [];
    for(k in this.keys())
      arr.push(k);
    return arr;
	}

}