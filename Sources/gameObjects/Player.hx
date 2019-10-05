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

class Player extends Entity {
    public var display:Layer;
    public var collision:CollisionBox;
    var maxSpeed:Float=400;
    var armL:BasicSprite;
    var armR:BasicSprite;
    var body:BasicSprite;
    public function new() {
        super();
        display=new Layer();
         armR=new BasicSprite("ivankaArm");
        display.addChild(armR);
        armR.smooth=false;
        body=new BasicSprite("ivanka");
        display.addChild(body);
        body.smooth=false;
        armL=new BasicSprite("ivankaArm");
        display.addChild(armL);
        armL.smooth=false;

       display.scaleX=display.scaleY=4;
       body.x=-9;
       body.y=-23;

       armL.x=-(9-11);
       armL.y=-(23-14);
       armL.pivotX=2;
       armL.pivotY=2;

       armR.x=-(9-3);
       armR.y=-(23-14);
       armR.pivotX=2;
       armR.pivotY=2;

       // display.offsetX=-display.width()*0.5;
       // display.offsetY=-display.width()*0.5;
        collision=new CollisionBox();
        collision.width=10*4;
        collision.height=21*4;
        collision.maxVelocityX=maxSpeed;
        display.x=collision.x=500;
        display.y=collision.y=200;

        collision.accelerationY=GameGlobals.Gravity;
        
        collision.dragX=0.9;
    }
 
  
    override function update(dt:Float) {
        super.update(dt);
        display.x=collision.x+10*2;
        display.y=collision.y+21*4;

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
            collision.velocityY=-500;
        }
        if(collision.velocityX!=0 && collision.isTouching(Sides.BOTTOM)){
            display.rotation=Math.PI/20*Math.sin(TimeManager.time*10);
            armL.rotation= display.rotation*2;
            armR.rotation=-armL.rotation;
        }
        else{
             armR.rotation=armL.rotation=display.rotation=0;
        }

        collision.update(dt); 
        
        
    }
}