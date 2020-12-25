package sequent.core;
import haxe.ds.List;
import sequent.core.collection.Multiset;

/**
 * ...
 * @author JavidJafari
 */
class Sequent 
{
	public var antecedent:Multiset<Wff>;
	public var succedent:Multiset<Wff>;
	public var childs:Array<Dynamic>;
	public var rules:Array<String>;
	public function new(left:Multiset<Wff>,right:Multiset<Wff>) 
	{
		
	
		this.antecedent = left;
		this.succedent = right;
		this.childs = [];
		this.rules = [];
		
	}
	public function toString(){
		
		return this.antecedent + '=>' + this.succedent;
	}
}