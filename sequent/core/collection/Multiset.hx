package sequent.core.collection;
import sequent.core.Wff;
import sequent.core.Wff;

/**
 * ...
 * @author JavidJafari
 */
@:forward
@:generic
abstract Multiset<T>(Map<T,Int>) 
{
	inline function new(map:Map<T,Int>){
		this = map;
		
	}
	@:from static public function fromArray(s:Iterable<Int>) {
		var map:Map<Int,Int> = new Map<Int,Int>();
		
		for (i in s) {
			if (map.exists(i)) map.set(i, map.get(i) + 1);
			else map.set(i,1);
		}
		
		return new Multiset(map);
		
	}
	
	@:from static public function fromWffArray(s:Iterable<Wff>) {
		var map:Map<Wff,Int> = new Map<Wff,Int>();
		
		for (i in s) {
		if (map.exists(i)) {map.set(i, map.get(i) + 1);}
			else {i.evaulate();map.set(i, 1);  }
		}
		
		return new Multiset(map);
		
	}
	
	
	 @:to public function toArray() : Array<T> {
    var arr : Array<T> = [];
	
    for(k in this.keys()){
		for(i in 0 ... this.get(k)){
			arr.push(k);
		}
	}
    return arr;
	}
	public function clone(){
		
		return new Multiset(this.copy());
	}
	public function add(t:T){
		
		var k:Int = this.get(t);
		if (k >= 1) this.set(t, k+1);
		else this.set(t,1);
	}
	public function delete(t:T){
		
		var k:Int = this.get(t);
		if (k > 1) this.set(t, k - 1);
		if (k == 1) this.remove(t);
	}
	@:to public function toString():String{
		return ""+toArray().toString()+"";
		
	}
	
	

}