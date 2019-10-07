package;

import kha.WindowMode;
import kha.FramebufferOptions;
import kha.WindowOptions;
import kha.System;
import com.framework.Simulation;
import states.BasicLoader;
import states.Test;

class Main {
	public static function main() {
		var windowsOptions=new WindowOptions("MECHANGREJO",0,0,1280,720,null,true,WindowFeatures.FeatureResizable,WindowMode.Windowed);
		var frameBufferOptions=new FramebufferOptions(60,true,32,16,8,0);
		System.start(new SystemOptions("coalTest",1280,720,windowsOptions,frameBufferOptions), function (w) {
			new Simulation(BasicLoader,1280,720,1,0);
		});
	}
}
