package states;

import com.collision.platformer.CollisionEngine;
import gameObjects.Player;
import com.collision.platformer.CollisionTileMap;
import com.loading.basicResources.TilesheetLoader;
import com.gEngine.display.Blend;
import com.gEngine.shaders.ShRgbSplit;
import com.gEngine.Filter;
import com.loading.basicResources.ImageLoader;
import com.gEngine.display.Layer;
import com.loading.basicResources.DataLoader;
import com.collision.platformer.Tilemap;
import com.loading.basicResources.SparrowLoader;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;
import com.framework.utils.State;

class Test extends State {
    var tilemapCollision:CollisionTileMap;
    var ivanka:Player;
    public function new() {
        super();
    }
    override function load(resources:Resources) {
        resources.add(new DataLoader("level_tmx"));
        var atlas=new JoinAtlas(2048,2048);
        atlas.add(new SparrowLoader("Untitled_1","Untitled_1_xml"));
        atlas.add(new TilesheetLoader("tiles", 10,10,0));
        atlas.add(new SparrowLoader("ivanka", "ivanka_xml"));
        resources.add(atlas);
    }

    override function init() {

        stageColor(1,0.5,0.5);
       
        var simulationLayer=new Layer();

      // simulationLayer.filter=new Filter([new ShRgbSplit(Blend.blendMultipass())],0.5,0.5,0.5,0,false);
        
        
        ivanka=new Player();
        simulationLayer.addChild(ivanka.display);
        addChild(ivanka);
        
        
        
        stage.addChild(simulationLayer);
        var tilemap:Tilemap=new Tilemap();
        tilemapCollision=tilemap.init("level_tmx","tiles",10,10,simulationLayer,4);
        stage.defaultCamera().limits(0,0,tilemapCollision.widthIntTiles*40,tilemapCollision.heightInTiles*40);
    }
    override function update(dt:Float) {
        super.update(dt);
        CollisionEngine.collide(tilemapCollision,ivanka.collision);
        stage.defaultCamera().setTarget(ivanka.display.x,ivanka.display.y);
    }
}