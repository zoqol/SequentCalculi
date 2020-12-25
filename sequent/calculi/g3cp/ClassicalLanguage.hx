package sequent.calculi.g3cp;

import sequent.core.ILanugage;

/**
 * ...
 * @author JavidJafari
 */
class ClassicalLanguage implements ILanugage 
{

	
	
	/* INTERFACE sequent.core.ILanugage */
	
	public var constants:String;
	public var seperator:String=',';
	public var paranteces:String;
	public var operators:String = '&|>';
	public var falsum:String = 'f';
	public var AND:String="&";
	public var OR:String="|";
	public var IF:String=">";
	
	
	public function new() 
	{
		
		
	}
	
	
}