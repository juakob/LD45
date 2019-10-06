package fx;


import com.fx.Particle;
import com.fx.Emitter;
import com.framework.utils.Entity;
import com.gEngine.display.Layer;
import com.framework.utils.State;
import com.gEngine.display.BasicSprite;

class Blood {
    var bloodPool:Entity;
    var layer:Layer;
    public function new(state:State,layer:Layer){
        bloodPool=new Entity();
        bloodPool.pool=true;
        state.addChild(bloodPool);
        this.layer=layer;
    }
    function initBloodPool(emitter:Emitter){
            emitter.gravity=2000;
            emitter.minVelocityX=-400;
            emitter.maxVelocityX=400;
            emitter.minVelocityY=-450;
            emitter.maxVelocityY=-1000;
            emitter.minScale=2;
            emitter.maxScale=8;
            emitter.minLife=1;
            emitter.maxLife=2;
            emitter.angularVelocityMin=-3;
            emitter.angularVelocityMax=3;
            for(i in 0...20){
                var display=new BasicSprite("pumpkinBlood");
                display.smooth=false;
                display.timeline.gotoAndStop(i%display.timeline.totalFrames);
                var particle:Particle=new Particle(display);
                
                emitter.addChild(particle);
            }
            
            bloodPool.addChild(emitter);
    }
    public function addBlood(x:Float,y:Float){
        var emitter:Emitter=cast bloodPool.recycle(Emitter);
        if(emitter.currentCapacity()==0){
            initBloodPool(emitter);
        }
        emitter.reset(layer);
        emitter.allX=x;
        emitter.allY=y;
        emitter.start(0.1);
    }
}