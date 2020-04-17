package;

import states.Intro;
import kha.math.Random;
import kha.WindowMode;
import kha.FramebufferOptions;
import kha.WindowOptions;
import kha.System;
import com.framework.Simulation;
import states.BasicLoader;
import states.Test;
#if (kha_html5 && js)
import js.html.CanvasElement;
import js.Browser.document;
import js.Browser.window;
import js.Browser.navigator;
#end

class Main {
	
	public static function main() {
		#if hotml new hotml.Client(); #end
		#if (kha_html5 && js)
		//make html5 canvas resizable
		document.documentElement.style.padding = "0";
		document.documentElement.style.margin = "0";
		document.body.style.padding = "0";
		document.body.style.margin = "0";
		var canvas:CanvasElement = cast(document.getElementById("khanvas"), CanvasElement);
		canvas.style.display = "block";

		var resize = function() {
			canvas.width = Std.int(window.innerWidth * window.devicePixelRatio);
			canvas.height = Std.int(window.innerHeight * window.devicePixelRatio);
			canvas.style.width = document.documentElement.clientWidth + "px";
			canvas.style.height = document.documentElement.clientHeight + "px";
		}
		window.onresize = resize;
		resize();
		#end
		
		var windowsOptions=new WindowOptions("MECHANGREJO",0,0,1280,720,null,true,WindowFeatures.FeatureResizable,WindowMode.Windowed);
		var frameBufferOptions=new FramebufferOptions(60,true,32,16,8,0);
		System.start(new SystemOptions("coalTest",1280,720,windowsOptions,frameBufferOptions), function (w) {
			Random.init(0);
			new Simulation(BasicLoader,1280,720,1,0);
		});
	}
}
