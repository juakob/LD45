package gameObjects;

import com.collision.platformer.Sides;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.BasicSprite;
import com.framework.utils.Entity;

class Bullet extends Entity {
    var display:BasicSprite;
    var collision:CollisionBox;
    public function new() {
        super();
        display=new BasicSprite("bullets");
        display.scaleX=display.scaleY=4;
        display.smooth=false;
        collision=new CollisionBox();
        collision.width=2*4;
        collision.height=1*4;
        collision.userData=this;
    }
    public function reset(x:Float,y:Float,side:Int,type:String) {
        display.timeline.playAnimation(type);
        collision.x=x;
        collision.y=y;
        GameGlobals.simulationLayer.addChild(display);
        GameGlobals.bulletCollisions.add(collision);
        if(side==Sides.RIGHT){
            collision.velocityX=2000;
        }else{
            collision.velocityX=-2000;
        }
    }
    override function limboStart() {
        display.removeFromParent();
        collision.removeFromParent();
    }
    var timer:Float=0;
    override function update(dt:Float) {
        super.update(dt);
        timer+=dt;
        if(timer>2){
           timer=0;
            die();
        }
        display.x=collision.x;
        display.y=collision.y;
        collision.update(dt);
    }
}