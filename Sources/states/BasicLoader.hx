package states;

import com.gEngine.helper.RectangleDisplay;
import com.framework.Simulation;
import com.framework.utils.State;
import com.gEngine.GEngine;
import kha.Assets;


/**
 * ...
 * @author Joaquin
 */
class BasicLoader extends State
{

	public function new() 
	{
		super();
		
	}
	var allLoaded:Bool;
    var backgroundLoader:RectangleDisplay;
    var bar:RectangleDisplay;
	override public function init():Void 
	{
		stageColor(0.2,0.2,0.2);
		Assets.loadEverything(onAllLoaded );
        backgroundLoader=new RectangleDisplay();
        backgroundLoader.x=50;
        backgroundLoader.y=GEngine.virtualHeight*0.5;
        backgroundLoader.scaleX=GEngine.virtualWidth-50*2;
        backgroundLoader.scaleY=50;
        stage.addChild(backgroundLoader);

         bar=new RectangleDisplay();
        bar.x=50;
        bar.y=GEngine.virtualHeight*0.5;
        bar.scaleX=0;
        bar.scaleY=50;
        bar.setColor(0,255,0);
        stage.addChild(bar);

	}
	function onAllLoaded() {
		allLoaded = true;
	}
	override function onUpdate(aDt:Float):Void 
	{
		bar.scaleX=Assets.progress *GEngine.virtualWidth-50*2;
		if (allLoaded) {
			Simulation.i.manualLoad = true;
			changeState(new Intro()); 	
		}
	}
}