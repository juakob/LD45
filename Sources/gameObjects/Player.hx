package gameObjects;

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
 
    override function update(dt:Float) {
        

        if(Input.i.isKeyCodeDown(KeyCode.Left)){
            collision.accelerationX=-maxSpeed*4;
            
            display.scaleX=Math.abs(display.scaleX);
        }else
        if(Input.i.isKeyCodeDown(KeyCode.Right)){
            collision.accelerationX=maxSpeed*4;
             display.scaleX=-Math.abs(display.scaleX);
        }else{
            collision.accelerationX=0;
        }
        if(Input.i.isKeyCodePressed(KeyCode.Space)){
            collision.velocityY=-1000;
        }
        interact=(Input.i.isKeyCodePressed(KeyCode.Up));
         if(Input.i.isKeyCodePressed(KeyCode.X)){
             if(display.scaleX>0){
                  weapon.shoot(collision.x-50,collision.y+37,Sides.LEFT);
             }else{
                  weapon.shoot(collision.x+70,collision.y+37,Sides.RIGHT);
             }
           
        }
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