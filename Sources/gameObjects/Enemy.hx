package gameObjects;

import kha.math.Random;
import com.TimeManager;
import com.collision.platformer.Sides;

class Enemy extends Body {
    var dying:Bool=false;
    var dieTime:Float=0;
    var totalDieTime:Float=0.2;
    var diePosX:Float=0;
    var diePosY:Float=0;

    public function new(x:Float,y:Float) {
        super();
        body.timeline.playAnimation("pumpkin");
        collision.x=x;
        collision.y=y;
        collision.accelerationX=Math.random()<0.5?collision.maxVelocityX:-collision.maxVelocityX;
        //add some small variations
        display.scaleX=display.scaleY = 3.9 + Math.random() * 0.2;
        var r=0.8+Math.random()*0.3;
        var g=0.8+Math.random()*0.3;
        var b=0.8+Math.random()*0.3;
        body.colorMultiplication(r,g,b);
        armL.colorMultiplication(r,g,b);
        armR.colorMultiplication(r,g,b);
    }
    override function update(dt:Float) {
        if(dying){
            if(dieTime>0){
                var spread=1-(dieTime/totalDieTime); 
                body.colorAdd(spread,spread,spread);
                armL.colorAdd(spread,spread,spread);
                armR.colorAdd(spread,spread,spread);          
                dieTime-=dt;
                collision.x=diePosX+Random.getFloatIn(-10*spread,10*spread);
                collision.y=diePosY+Random.getFloatIn(-10*spread,10*spread);
                super.update(dt);
            }else{
                 GameGlobals.blood.addBlood(collision.x,collision.y);
                 die();
            }
            return;
        }
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
        collision.removeFromParent();
        collision.accelerationX=0;
        collision.accelerationY=0;
        collision.velocityX=0;
        collision.velocityY=0;
        diePosX=collision.x;
        diePosY=collision.y;
        dieTime=totalDieTime;
        dying=true;
    }
    
}