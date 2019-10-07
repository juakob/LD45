package gameObjects;

import com.TimeManager;
import com.collision.platformer.Sides;

class Enemy extends Body {
    public function new(x:Float,y:Float) {
        super();
        body.timeline.playAnimation("pumpkin");
        collision.x=x;
        collision.y=y;
        collision.accelerationX=Math.random()<0.5?collision.maxVelocityX:-collision.maxVelocityX;
        //add some small variations
        display.scaleX=display.scaleY = 3.9+Math.random()*0.2;
        var r=0.8+Math.random()*0.3;
        var g=0.8+Math.random()*0.3;
        var b=0.8+Math.random()*0.3;
        body.colorMultiplication(r,g,b);
        armL.colorMultiplication(r,g,b);
        armR.colorMultiplication(r,g,b);
    }
    override function update(dt:Float) {
        
         display.rotation=Math.PI/40*Math.sin(TimeManager.time*10);
        armL.rotation= display.rotation+Math.PI/2;
        layerArmR.rotation=-display.rotation+Math.PI/2;
        if(collision.isTouching(Sides.LEFT)){
            collision.accelerationX=collision.maxVelocityX;
            display.scaleX=-Math.abs(display.scaleX);
        }else 
        if(collision.isTouching(Sides.RIGHT)){
            collision.accelerationX=-collision.maxVelocityX;
            display.scaleX=Math.abs(display.scaleX);
        }
        if(Math.random()<0.02&&collision.isTouching(Sides.BOTTOM)){
            collision.velocityY=-700-Math.random()*300;
        }
        super.update(dt);
    }
    public function damage() {
        die();
        GameGlobals.blood.addBlood(collision.x,collision.y);
    }
    
}