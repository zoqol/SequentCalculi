package;

import haxe.Timer;
import js.Browser;
import js.Lib;
import js.html.InputElement;
import js.html.SelectElement;
import js.html.Window;
import sequent.calculi.g3cp.ClassicalLanguage;
import sequent.calculi.g3cp.G3cp;
import sequent.calculi.g4ip.G4ip;
import sequent.core.ILanugage;
import sequent.core.Latex;
import sequent.core.Sequent;
import sequent.core.Wff;
import sequent.core.Wff;
import sequent.core.collection.Multiset;
import sequent.core.collection.Set;

/**
 * ...
 * @author JavidJafari
 */
@:native('MathJax')
 extern class MathJax{
	 public static var Hub:Dynamic;
	
	 
 }
class Main 
{
	
	static function main() 
	{
		trace('hello');
		var math;
		 Browser.window.addEventListener('load', function (){
			 MathJax.Hub.queue.Push(function() {
            math = MathJax.Hub.getAllJax("sd")[0];
        });
			 //Browser.alert('fuuck');
		 });

		Wff.LANGUAGE = new ClassicalLanguage();
		var g3cp:G3cp = new G3cp();
	
		var wff:Wff = new Wff('(A>B)');
		var wff2:Wff = new Wff('B>A');
		wff2.evaulate();
		wff.evaulate();
		var hash = Browser.window.location.hash.substr(3);
		hash = (~/%3E/g).replace(hash, '>');
		hash = (~/%7C/g).replace(hash, '|');
		
		//%3E/g/g
		var prefix = Browser.window.location.hash.substring(1,2);
		
		
		//window.location.hash.substr(3).replace(/%3E/g,'>').replace(/%7C/g,'|');
		trace(hash);
		var formula:String = '((A>B)>((A>f)|B))';
		if (hash != '') {
			trace(hash +' : hash'	);
			formula = '(' + hash + ')';
		}
	
		var st:Wff = new Wff(formula);
		st.evaulate();
		trace(st);
		
		if(!st.isCorrect()){
			
			 Browser.alert('incorrect formula');
			 return;
			 
			// return;
		}
		
		var pf:Wff = new Wff('f');

		var mlset:Multiset<Wff> = [st];
		var wls:Multiset<Wff> = [];
		var seq:Sequent = new Sequent(wls, mlset);
		trace(seq + '');
	
		
 
		 
		
		//g3cp.proofSearch(seq);
	//	var s:String = g3cp.getProofTree(seq);
		//trace(g3cp.toLatex(s));
		var calc:SelectElement = cast(Browser.document.querySelector('#calc'),SelectElement);
		var g3cp = new G3cp();
		var g4ip = new G4ip();
	
		//window.location.hash.substr(3).replace(/%3E/g,'>').replace(/%7C/g,'|');
		if (prefix == 'i') calc.value = 'g4ip';
		else if(prefix == 'c') calc.value = 'g3cp';
			
		var solution = '';
		if (calc.value == 'g3cp'){
				 trace('g3cp');
				 trace(g3cp.proofSearch(seq));
				 var tree = g3cp.getProofTree(seq);
				 if (tree==null) tree = g3cp.toFrac(seq);
				
				 solution= Latex.toLatex(tree);
				 
			 }else if (calc.value == 'g4ip'){
				 trace(g4ip.proofSearch(seq));
				  var tree = g4ip.getProofTree(seq);
				 if (tree==null)  tree = g4ip.toFrac(seq);
				
				 solution= Latex.toLatex(tree);
				 
			 }
			 
			 
		var mathjaxcontainer = Browser.document.querySelector('#sd');
		var input = cast(Browser.document.querySelector('#inpt'), InputElement);
		input.value=st.literal.substring(1,st.literal.length-1);
		 var btn = Browser.document.querySelector('#btn');
		 btn.addEventListener('click', function (){
			 
			 trace(calc.value);
			 var t:String = 'i=';
			 if (calc.value == 'g3cp') t = 'c=';
			 Browser.document.location.hash = '#'+t + input.value;
			 if (input.value == '') return;
			
			 var wffinput:Wff = new Wff('(' + input.value+')');
			 wffinput.evaulate();
			 if (!wffinput.isCorrect()) {Browser.alert('incorrect formula'); return; }
			 var multiset:Multiset<Wff> = [wffinput];
			 var seq:Sequent = new Sequent([], multiset);
			 var solution:String = '';
			 
			 if (calc.value == 'g3cp'){
				 trace('g3cp');
				 trace(g3cp.proofSearch(seq));
				 var tree = g3cp.getProofTree(seq);
				 if (tree==null) tree = g3cp.toFrac(seq);
				trace(tree);
				 solution= Latex.toLatex(tree);
				 
			 }else if (calc.value == 'g4ip'){
				 trace(g4ip.proofSearch(seq));
				  var tree = g4ip.getProofTree(seq);
				 if (tree==null)  tree = g4ip.toFrac(seq);
				trace(tree);
				 solution= Latex.toLatex(tree);
				 
			 }
			
			 MathJax.Hub.queue.Push(["Text", math, solution]);

			 
			 
			
		 });
		 mathjaxcontainer.innerHTML = '$' + solution + '$';
		 
		 var mouseY = 0;
		 
		var scrollerHolder = Browser.document.querySelector('#scroll-holder');
		var handle = Browser.document.querySelector('#handle');

		
		var initPos = Std.parseInt(Browser.window.getComputedStyle(scrollerHolder, null).getPropertyValue('top'));
		var initH=Std.parseInt(Browser.window.getComputedStyle(scrollerHolder,null).getPropertyValue('height'));

		var mouseDown = false;
		
		    Browser.window.addEventListener("mouseup", (e)->{
				mouseDown = false;
			});
			 Browser.window.addEventListener("touchcancel", (e)->{
				mouseDown = false;
			});
			 Browser.window.addEventListener("touchend", (e)->{
				 trace('touchend');
				mouseDown = false;
			});
		Browser.window.addEventListener('mousemove', (e)->{
			if (mouseDown) mouseY = e.clientY - initPos;
			
			
		});
		scrollerHolder.addEventListener("touchstart", function (e) {

     mouseY=e.changedTouches[0].pageY;
       mouseDown=true;
     

      
    });
		Browser.window.addEventListener('touchmove', function(e){
	   
			mouseY = e.changedTouches[0].pageY-initPos;
			trace(e.changedTouches[0].pageY);
			
		}, false);
		scrollerHolder.addEventListener('mousedown', (e)->{
			mouseY = (e.clientY - initPos);
			trace(e.clientY-initPos);
			mouseDown = true;
			
			
		});
		var scale:Float = 1;
		var loop:Timer = new Timer(1);
		
		loop.run = function (){
			if (mouseDown){
				mathjaxcontainer.style.transform = 'scale(' + scale+')';
				trace('this:' + handle.style.top);
				
				if (mouseY > 0 && mouseY < (initH - 9)) {
					scale = .3 + (mouseY / initH)*2;
					handle.style.top = mouseY + 'px';
				}
				
				
			}
			
			
		}
		var timer:Timer = new Timer(1);
		timer.run=function (){
			
			if(mathjaxcontainer.getElementsByClassName('MathJax_Preview')[0]!=null){
				
				Timer.delay(()->{
					
					mathjaxcontainer.classList.add('visible');
					timer.stop();
				}, 400);
			}
		}
		
		 
		 


		
	}
	static public function test(i:Int):Bool{
		return true;
	}
	
}
 