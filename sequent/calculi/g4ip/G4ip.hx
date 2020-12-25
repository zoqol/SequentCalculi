package sequent.calculi.g4ip;

import sequent.calculi.g3cp.G3cp;
import sequent.core.Sequent;
import sequent.core.Wff;
import sequent.core.collection.Multiset;

/**
 * ...
 * @author JavidJafari
 */
class G4ip extends G3cp 
{

	public function new() 
	{
		super();
	
	}
	
	override public  function proofSearch(seq:Sequent):Bool{
				if (isAbsurd(seq) || isAxiom(seq)) {
			trace('is axiom or absurd');
			trace(seq + '');
			return true;
		}
		var ant:Multiset<Wff> = seq.antecedent;
		var succ:Multiset<Wff> = seq.succedent;
		//trace(Std.isOfType([], Array));
		
		trace(seq + ' p:');
		for (c => value in ant){
		
			if (c.connective == Wff.LANGUAGE.AND){
				var newSequent:Sequent = leftAND(seq, c);
				seq.childs.unshift(newSequent);
				//trace(newSequent+'');
				proofSearch(newSequent);
			}
			if (c.connective ==Wff.LANGUAGE.OR){
				var newSequents:Array<Sequent> = leftOR(seq, c);
				seq.childs.unshift(newSequents);
				
			 
				proofSearch(newSequents[0]);
				proofSearch(newSequents[1]);
				
			}
			if(c.connective==Wff.LANGUAGE.IF){
				 if (c.left.connective == '|'){
					 
					 var newSequent:Sequent = leftIFOR(seq, c);
					seq.childs.unshift(newSequent);
					proofSearch(newSequent);
					 
				 }
				 if (seq.antecedent.toArray().map(o->o.literal).indexOf(c.left.literal) >-1){
					
					 var newSequent:Sequent = leftIF0(seq, c);
					seq.childs.unshift(newSequent);
					proofSearch(newSequent);
				 }
				 if (c.left.connective == '>'){
				var newSequents:Array<Sequent> = leftIFIF(seq, c);
				seq.childs.unshift(newSequents);
				proofSearch(newSequents[0]);
				proofSearch(newSequents[1]);
				 
					 
					 
				 }
				 	 if (c.left.connective == '&'){
				 var newSequent:Sequent = leftIFAND(seq, c);
					seq.childs.unshift(newSequent);
					proofSearch(newSequent);
					 
					 
				 }
			}
		}
		
		for(c => value in succ){
			if (c.connective == Wff.LANGUAGE.AND){
				var newSequents:Array<Sequent> = rightAND(seq, c);
				seq.childs.unshift(newSequents);
				
				proofSearch(newSequents[0]);
				proofSearch(newSequents[1]);
			}
			if (c.connective == Wff.LANGUAGE.OR){
				var newSequent:Sequent= rightOR1(seq, c);
				seq.childs.unshift(newSequent);
				if (proofSearch(newSequent)) return true;
				
				var newSequent2:Sequent= rightOR2(seq, c);
				seq.childs.unshift(newSequent2);
				if (proofSearch(newSequent2)) return true;
				
				
			}
			if(c.connective==Wff.LANGUAGE.IF){
				var newSequent:Sequent = rightIF(seq, c);
				seq.childs.unshift(newSequent);
				proofSearch(newSequent);
			
			}
		}
		
		return false;
		
	}
	
	public function leftIFOR(seq:Sequent,wff:Wff) {
	seq.rules.unshift('L>|');
	var f:Wff = wff;
	var o:String='('+f.left.left.literal+'>'+f.right.literal+')';
	var g:String = '(' + f.left.right.literal + '>' + f.right.literal + ')';
	var _1:Wff=new Wff(o);
	var _2:Wff = new Wff(g);
	_1.evaulate();
	_2.evaulate();

	var antecedent:Multiset<Wff> = seq.antecedent.clone();
	antecedent.delete(wff);
	antecedent.add(_2);
	antecedent.add(_1);
	
	var newSequent:Sequent = new Sequent(antecedent, seq.succedent);
	return newSequent;
	 
	}
	
	public function leftIFAND(seq:Sequent,wff:Wff) {
	seq.rules.unshift('L>&');
	var f:Wff=wff;
	var o='('+f.left.left.literal+'>('+f.left.right.literal+'>'+f.right.literal+'))';
	var _1:Wff=new Wff(o);
	_1.evaulate();

	var antecedent:Multiset<Wff> = seq.antecedent.clone();
	antecedent.delete(wff);
	antecedent.add(_1);
	var newSequent = new Sequent(antecedent, seq.succedent);
	return newSequent;
	 
	}

	public function leftIF0(seq:Sequent,wff:Wff) {
	seq.rules.unshift('L0>');
	var antecedent:Multiset<Wff> = seq.antecedent.clone();
	antecedent.delete(wff);
	antecedent.add(wff.right);
	
	var newSequent:Sequent = new Sequent(antecedent, seq.succedent);
	return newSequent;
	 
	}
	public function leftIFIF(seq:Sequent,wff:Wff) {
	seq.rules.unshift('L>>');
	var f:Wff=wff;
	var o:String='('+f.left.right.literal+'>'+f.right.literal+')';
	var _1:Wff=new Wff(o);
	_1.evaulate();

	var antecedent:Multiset<Wff> = seq.antecedent.clone();
	antecedent.delete(wff);
	var lseq:Multiset<Wff> = antecedent.clone();
	antecedent.add(f.right);
	lseq.add(f.left.left);
	lseq.add(_1);
	var sr:Sequent = new Sequent(antecedent, seq.succedent);
	var multiseq:Multiset<Wff> = [f.left.right];
	var sl=new Sequent(lseq,multiseq);
	return [sl, sr];
	 
}
	public function rightOR1(seq:Sequent, wff:Wff){
		seq.rules.unshift('R|1');
		var succedent:Multiset<Wff> = seq.succedent.clone();
		succedent.delete(wff);
		succedent.add(wff.left);
		
		return new Sequent(seq.antecedent,succedent);
		
		
	}
	public function rightOR2(seq:Sequent, wff:Wff){
		seq.rules.unshift('R|2');
		var succedent:Multiset<Wff> = seq.succedent.clone();
		succedent.delete(wff);
		succedent.add(wff.right);
		return new Sequent(seq.antecedent,succedent);
		
		
	}
}