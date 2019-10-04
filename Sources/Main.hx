package;

import kha.WindowMode;
import kha.FramebufferOptions;
import kha.WindowOptions;
import kha.System;
import com.framework.Simulation;
import states.Test;

class Main {
	public static function main() {
		var windowsOptions=new WindowOptions("MECHANGREJO",0,0,1280,720,null,true,WindowFeatures.FeatureResizable,WindowMode.Windowed);
		var frameBufferOptions=new FramebufferOptions(60,true,32,16,8,0);
		System.start(new SystemOptions("coalTest",1280,720,windowsOptions,frameBufferOptions), function (w) {
			//Mouse.get().notify(onMouseDown, onMouseDown, null, null);
			new Simulation(Test,1280,720,1,0);
			//trace( EarCut.earcut([0,0,100,0,100,100,0,100,0,0,100,0,220,0,220,100,120,100,100,0,20,20,80,20,80,80,20,80],[10], 2));
			
		});
	}
}
