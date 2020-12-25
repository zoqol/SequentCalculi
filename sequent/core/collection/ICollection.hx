package sequent.core.collection;
import sequent.core.Wff;

/**
 * @author JavidJafari
 */
interface ICollection 
{
	public function contains(wff:Wff):Bool;
}