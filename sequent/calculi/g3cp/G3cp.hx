package sequent.calculi.g3cp;

import sequent.core.Sequent;
import sequent.core.Wff;
import sequent.core.collection.Multiset;

/**
 * ...
 * @author JavidJafari
 */
class G3cp 
{

	public function new() 
	{
		
	}
	public  function proofSearch(seq:Sequent):Bool{
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
				var newSequents:Array<Sequent> = leftIF(seq, c);
				seq.childs.unshift(newSequents);
			 
				
			 	proofSearch(newSequents[0]);
				proofSearch(newSequents[1]);
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
				var newSequent:Sequent= rightOR(seq, c);
				seq.childs.unshift(newSequent);
				proofSearch(newSequent);
				
			}
			if(c.connective==Wff.LANGUAGE.IF){
				var newSequent:Sequent = rightIF(seq, c);
				seq.childs.unshift(newSequent);
				proofSearch(newSequent);
			
			}
		}
		
		return false;
		
	}
	 
	
	public  function getProofTree(seq:Sequent){
		
		if(seq.childs.length==0){
			
			if (isAxiom(seq) || isAbsurd(seq)) { return seq.toString();}  
			return null;
		}
		var childs=seq.childs;
	for( i in 0 ... seq.childs.length){
		var c:Dynamic=seq.childs[i];
		var bot = '{' + seq.toString() + '}';
		if(Std.isOfType(c,Array)){
			var l = c[0];
			var r = c[1];
			if(getProofTree(l)!=null && getProofTree(r)!=null) {
			/*	var n1=new Node();
				var n2=new Node()
				n2.level=n1.level=node.level+1;
				node.left=n1;node.right=n2;*/


				return '\\frac{'+getProofTree(l)+'\\hspace{1cm}'+getProofTree(r)+'}'+bot+seq.rules[i];}
		}
		else{
			if(getProofTree(c)!=null) {
				return '\\frac{'+getProofTree(c)+'}'+bot+seq.rules[i];}
		}

	}
return null;
	}
	public function toFrac(s:Sequent) {
	if(s.childs.length==0) return s.toString();
	
	var c:Dynamic = s.childs[0];
	var bot = '{' + s.toString() + '}';
	if(Std.isOfType(c,Array)){
		var l = c[0];
		var r = c[1];
		return  '\\frac{'+toFrac(l)+'\\hspace{1cm}'+toFrac(r)+'}'+bot+s.rules[0];

		//return '\\frac{'+toFrac(l)+'}'+'{'+l.toString()+'}'+'\\frac{'+toFrac(r)+'}'+'{'+r.toString()+'}';

	}
	
	return '\\frac{'+toFrac(c)+'}'+bot+s.rules[0];
	//if(Array.isArray(s.childs[0]))

	
}
	public  function isAxiom(seq:Sequent):Bool{
		var ant:Array<String> = seq.antecedent.toArray().map(o -> o.literal);
		var succ:Array<String> = seq.succedent.toArray().map(o -> o.literal);
		for(i in ant){
			if (succ.indexOf(i) >-1) return true;
		}
		return false;
	}
	public  function isAbsurd(seq:Sequent):Bool{
		
		return seq.antecedent.toArray().map(o -> o.literal).indexOf(Wff.LANGUAGE.falsum) >-1;
		
		
	}
	public  function leftAND(seq:Sequent, wff:Wff){
		seq.rules.unshift('L&');
		var antecedent:Multiset<Wff> = seq.antecedent.clone();
		antecedent.delete(wff);
		antecedent.add(wff.left);
		antecedent.add(wff.right);
		return new Sequent(antecedent, seq.succedent);
	}
	public  function rightAND(seq:Sequent, wff:Wff){
		seq.rules.unshift('R&');
		 var rightSuccedent:Multiset<Wff> = seq.succedent.clone();
		 rightSuccedent.delete(wff);
		 var leftSuccedent:Multiset<Wff> = rightSuccedent.clone();
		 leftSuccedent.add(wff.left);
		 rightSuccedent.add(wff.right);
		 var leftSequent:Sequent = new Sequent(seq.antecedent, leftSuccedent);
		 var rightSequent:Sequent = new Sequent(seq.antecedent, rightSuccedent);
		 
		 return [leftSequent,rightSequent];
		 
		
	}
	public  function rightOR(seq:Sequent, wff:Wff){
		seq.rules.unshift('R|');
		var succedent:Multiset<Wff> = seq.succedent.clone();
		succedent.delete(wff);
		succedent.add(wff.left);
		succedent.add(wff.right);
		
		return new Sequent(seq.antecedent, succedent);
	}
	public  function leftOR(seq:Sequent, wff:Wff){
		seq.rules.unshift('L|');
		var rightAntecedent:Multiset<Wff> = seq.antecedent.clone();
		rightAntecedent.delete(wff);
		var leftAntecedent:Multiset<Wff> = rightAntecedent.clone();
		leftAntecedent.add(wff.left);
		rightAntecedent.add(wff.right);
		var leftSequent:Sequent = new Sequent(leftAntecedent, seq.succedent);
		var rightSequent:Sequent = new Sequent(rightAntecedent, seq.succedent);
		return [leftSequent,rightSequent];
	}
	public  function leftIF(seq:Sequent, wff:Wff){
		seq.rules.unshift('L>');
	 
		var leftSuccedent:Multiset<Wff> = seq.succedent.clone();
		leftSuccedent.add(wff.left);
		//trace(wff.left+'');
		var rightAntecedent:Multiset<Wff> = seq.antecedent.clone();
		 
		rightAntecedent.delete(wff);
		var leftAntecdent:Multiset<Wff> = rightAntecedent.clone();

		rightAntecedent.add(wff.right);
		
		var leftSequent:Sequent = new Sequent(leftAntecdent, leftSuccedent);
		var rightSequent:Sequent = new Sequent(rightAntecedent, seq.succedent);
		return [leftSequent, rightSequent];
		
			
	}
	public  function rightIF(seq:Sequent, wff:Wff){
		seq.rules.unshift('R>');
		var antecedent:Multiset<Wff> = seq.antecedent.clone();
		antecedent.add(wff.left);
		var succedent:Multiset<Wff> = seq.succedent.clone();
		succedent.delete(wff);
		succedent.add(wff.right);
		return new Sequent(antecedent, succedent);
		
	}
	
	
}