package fx;

import kha.math.Random;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Drop extends Entity {

    public var display:Sprite;
    
    var speed:Float;
    var dropHeight:Float;
    var startY:Float;
    var floorY:Float;
    var minX:Float;
    var maxX:Float;
    public function new(startY:Float,floorY:Float,minX:Float,maxX:Float,speed:Float) {
        super();

        this.startY=startY;
        this.floorY=floorY;
        this.minX=minX;
        this.maxX=maxX;

        this.speed=speed;
        display=new Sprite("drop");
        display.scaleX=display.scaleY=4;
        display.timeline.playAnimation("fall",false);
        display.timeline.frameRate=1/(Random.getFloatIn(15,30));
        display.offsetY=-9;
        display.scaleX=display.scaleY=Random.getFloatIn(3.9,4.5);
        if(Math.random()>0.5)display.scaleX=-display.scaleX;
        reset();
        display.y = Random.getFloatIn(startY,floorY);
        display.smooth=false;
    }
    override function update(dt:Float) {
        display.y+=speed*dt;
        if(display.y>floorY){
            display.y=floorY;
            if(!display.timeline.playing){
                reset();
            }else{
                display.timeline.playAnimation("fall",false);
            }
            
        }
        super.update(dt);
    }
    public function reset() {
        display.y = startY;
        display.x = Random.getFloatIn(minX,maxX);
        display.timeline.playAnimation("drop");
    }
}