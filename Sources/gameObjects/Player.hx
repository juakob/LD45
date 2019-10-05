package gameObjects;

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

class Player extends Entity {
    public var display:BasicSprite;
    public var collision:CollisionBox;
    var maxSpeed:Float=400;
    public function new() {
        super();

        display=new BasicSprite("ivanka");
       
        
        display.z=50;
        display.scaleX=display.scaleY=4;
        display.offsetX=-9;
        display.offsetY=-4;
       // display.offsetX=-display.width()*0.5;
       // display.offsetY=-display.width()*0.5;
        collision=new CollisionBox();
        collision.width=10*4;
        collision.height=21*4;
        collision.x=100;
        collision.y=200;
        collision.accelerationY=GameGlobals.Gravity;
        display.textureFilter=PointFilter;
        collision.dragX=0.9;
    }
 
  
    override function update(dt:Float) {
        super.update(dt);
        display.x=collision.x-display.offsetX*2;
        display.y=collision.y-display.offsetY*2;

        if(Input.i.isKeyCodeDown(KeyCode.Left)){
            collision.velocityX=-maxSpeed;
            display.scaleX=4;
        }
        if(Input.i.isKeyCodeDown(KeyCode.Right)){
            collision.velocityX=maxSpeed;
             display.scaleX=-4;
        }
        if(Input.i.isKeyCodePressed(KeyCode.Space)){
            collision.velocityY=-500;
        }

        collision.update(dt); 
        
        
    }
}