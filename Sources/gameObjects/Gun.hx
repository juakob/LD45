package gameObjects;

import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

@:enum
abstract WeaponType(String) {
    var pistol="pistol";
    var shotgun="shotgun";
    var alien="alien";
}
class Gun extends Entity {
    public var display:Sprite;
    var bullets:Entity;
    public function new() {
        super();
        display=new Sprite("weapons");
        display.smooth=false;
        display.timeline.playAnimation(cast pistol);
        bullets=new Entity();
        bullets.pool=true;
        addChild(bullets);
    }
    public function changeType(type:WeaponType) {
        display.timeline.playAnimation(cast type);
    }
    public function shoot(x:Float,y:Float,side:Int) {
        var bullet:Bullet=cast bullets.recycle(Bullet);
        bullet.reset(x,y,side,"bullet");
    }
}