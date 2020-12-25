package sequent.core;

/**
 * ...
 * @author JavidJafari
 */
class Wff 
{
	
	public var parent:Wff = null;
	public var left:Wff=null;
	public var right:Wff=null;
	public var connective:String;
	public var literal:String;
	public static var LANGUAGE:ILanugage;
	public function new(str:String) 
	{
		this.literal = str;
		
	}
	public function evaulate(){
		parse(this.literal, this);
	}
	public function toString(){
		return this.literal;
		
	}
	public static function hasEqualParentheses(s:String):Bool{
		
		var left:EReg = ~/\)/g;
		var right:EReg = ~/\(/g;
		var leftCount:Int = 0;
		var rightCount:Int = 0;
		var leftMatch:Bool = left.match(s);
		var rightMatch:Bool = right.match(s);
		left.map(s, function (o) {leftCount++; return ''; });
		right.map(s, function (o) {rightCount++; return ''; });
		
		return (leftMatch && rightMatch && leftCount==rightCount) || (!leftMatch && !rightMatch);
	}
	public function isWff(wff:Wff):Bool{
		
		if (wff.left == null || wff.right == null){
			
			if (wff.literal.length == 0) return false;
				for(i in 0 ... LANGUAGE.operators.length){
					var o = LANGUAGE.operators.charAt(i);
					if (wff.literal.indexOf(o) >-1) return false;
				}
				return true;
		}
		return isWff(wff.left) && isWff(wff.right);
		
		
	}
	public function isCorrect():Bool{
		return this.isWff(this);
	}
	public static function parse(str:String, wff:Wff):Bool{
		
		if (str.length <= 1) return false;
		str = str.substring(1, str.length - 1);
			for(i in 0 ... str.length){
			var c = str.charAt(i);
			if(LANGUAGE.operators.indexOf(c)>-1) {
				var l = str.substring(0, i);
				var r = str.substring(i + 1, str.length);
				if (hasEqualParentheses(l) && hasEqualParentheses(r)) {
			 		 var left:Wff = new Wff(l);
			 		 var right:Wff = new Wff(r);
			 		 left.parent=wff;
			 		 right.parent=wff;
			 		 wff.left = left;
			 		 wff.right=right;
			 		 wff.connective = c;
					
			 		// console.log(l+'|'+r)
					parse(l,left);
					parse(r, right);
				}
				
			}
		}
		
		
		return true;
		
	}
	
}