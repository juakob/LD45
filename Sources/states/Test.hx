package states;

import com.gEngine.display.Layer;
import com.loading.basicResources.TilesheetLoader;
import com.loading.basicResources.DataLoader;
import com.collision.platformer.Tilemap;
import com.gEngine.display.BasicSprite;
import com.loading.basicResources.SparrowLoader;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;
import com.framework.utils.State;

class Test extends State {
    public function new() {
        super();
    }
    override function load(resources:Resources) {
        resources.add(new DataLoader("level_tmx"));
        var atlas=new JoinAtlas(2048,2048);
         atlas.add(new SparrowLoader("Untitled_1","Untitled_1_xml"));
        atlas.add(new SparrowLoader("tiles", "tiles_xml"));
       
        resources.add(atlas);
    }

    override function init() {
        var display=new BasicSprite("Untitled_1");
        stageColor(0.5,0.5,0.5);
        display.timeline.frameRate=1/30;
        display.x=100;
        display.y=200;
        display.scaleX=1;
        display.scaleY=1;
        display.textureFilter=PointFilter;
       //display.timeline.playAnimation("idle");
        stage.addChild(display);
        var simulationLayer=new Layer();
        stage.addChild(simulationLayer);
         var tilemap:Tilemap=new Tilemap();
        var tilemapCollision=tilemap.init("level_tmx","tiles",30,30,simulationLayer);
    }
}