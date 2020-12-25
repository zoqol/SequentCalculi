package sequent.core;

/**
 * ...
 * @author JavidJafari
 */
class Latex 
{

	public function new() 
	{
		
	}
	public  static function toLatex(x) {
		
	
	var a:String = (~/&/g).replace(x, '\\land ');
	a = (~/\|/g).replace(a, '\\lor ');
	a = (~/&/g).replace(a, '*');
	a = (~/\(([A-Z]|[a-z])\)/g).replace(a, '$1');
	a = (~/=>/g).replace(a, '\\hspace{.1cm}\\vdash ');
	a = (~/>/g).replace(a, '\\supset ');
	a = (~/f([^r])/g).replace(a, '\\bot $1');
	return a;
	}
}