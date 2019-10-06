package gameObjects;

import com.collision.platformer.CollisionGroup;
import com.gEngine.display.Layer;
import fx.Blood;

class GameGlobals {
    public static inline var Gravity:Float=2000;
    public static var simulationLayer:Layer;
    public static var bulletCollisions:CollisionGroup;
    public static var blood:Blood;

   public static function clear() {
      simulationLayer=null;
      bulletCollisions=null;
      blood=null;
   }
}