package gameObjects;

import com.framework.utils.XboxJoystick;
import com.TimeManager;
import com.collision.platformer.Sides;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionBox;
import kha.math.FastVector2;
import kha.math.FastVector4;
import kha.math.FastMatrix4;
import com.gEngine.display.Layer;
import com.gEngine.display.BasicSprite;
import com.framework.utils.Entity;

class Player extends Body {
    var weapon:Gun;
    public var interact:Bool;
    
    public function new(x:Float,y:Float) {
        super();
        weapon=new Gun();
        layerArmR.addChild(weapon.display);
        addChild(weapon);

        collision.x=x;
        collision.y=y;

       weapon.display.rotation=-Math.PI/2;
       weapon.display.x=-4;
       weapon.display.y=5+9;

    }
    public function onButtonChange(id:Int,value:Float) {
        if(id==XboxJoystick.LEFT_DPAD){
            if(value==1){
                collision.accelerationX=-maxSpeed*4;
                display.scaleX=Math.abs(display.scaleX);
            }else{
                if(collision.accelerationX<0){
                    collision.accelerationX=0;
                }
            }
        }
        if(id==XboxJoystick.RIGHT_DPAD){
            if(value==1){
                collision.accelerationX=maxSpeed*4;
                display.scaleX=-Math.abs(display.scaleX);
            }else{
                if(collision.accelerationX>0){
                    collision.accelerationX=0;
                }
            }
        }
         if(id==XboxJoystick.A){
            if(value==1){
                if(collision.isTouching(Sides.BOTTOM)){
                     collision.velocityY=-1000;
                }
            }
        }
        if(id==XboxJoystick.X){
            if(value==1){
               if(display.scaleX>0){
                  weapon.shoot(collision.x-50,collision.y+37,Sides.LEFT);
                }else{
                  weapon.shoot(collision.x+70,collision.y+37,Sides.RIGHT);
                }
            }
        }
        if(id==XboxJoystick.UP_DPAD){
            interact=(value==1);
        }
  
    }
    public function onAxisChange(id:Int,value:Float) {
        
    }
 
    override function update(dt:Float) {
        
        if(collision.velocityX!=0 && collision.isTouching(Sides.BOTTOM)){
            display.rotation=Math.PI/40*Math.sin(TimeManager.time*10);
            armL.rotation= display.rotation*4;
            layerArmR.rotation=-display.rotation+Math.PI/2;
        }
        else{
             armL.rotation=display.rotation=0;
        }
        super.update(dt);
        
    }
}