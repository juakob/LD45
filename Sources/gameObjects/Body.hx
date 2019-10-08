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

class Body extends Entity {
    public var display:Layer;
    public var collision:CollisionBox;
    var maxSpeed:Float=400;
    var layerArmR:Layer;
    var armL:BasicSprite;
    var armR:BasicSprite;
    var body:BasicSprite;
    
    public function new() {
        super();
        display=new Layer();
        layerArmR=new Layer();
        display.addChild(layerArmR);
         armR=new BasicSprite("ivankaArm");
        layerArmR.addChild(armR);
        armR.smooth=false;

        body=new BasicSprite("skins");
        body.timeline.playAnimation("policeWoman");
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

       armR.x=-2;
       armR.y=-1;
       layerArmR.x=-(9-3+armR.x);
       layerArmR.y=-(23-14+armR.y);

       // display.offsetX=-display.width()*0.5;
       // display.offsetY=-display.width()*0.5;
        collision=new CollisionBox();
        collision.width=10*4;
        collision.height=21*4;
        collision.maxVelocityX=maxSpeed;
        display.x=collision.x=500;
        display.y=collision.y=200;
        collision.userData=this;

        collision.accelerationY=GameGlobals.Gravity;
        collision.maxVelocityY=1000;
        
        collision.dragX=0.9;
    }
 
  
    override function update(dt:Float) {
        super.update(dt);
        display.x=collision.x+10*2;
        display.y=collision.y+21*4;

        collision.update(dt); 
        
        
    }
    override function destroy() {
        super.destroy();
        collision.removeFromParent();
        display.removeFromParent();
    }
}