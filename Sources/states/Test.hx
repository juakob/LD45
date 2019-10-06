package states;

import com.collision.platformer.ICollider;
import gameObjects.GameGlobals;
import com.framework.Simulation;
import com.gEngine.shaders.ShRetro;
import com.collision.platformer.CollisionGroup;
import com.gEngine.shaders.ShFilmGrain;
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
    var enemiesCollisions:CollisionGroup;
    var bullets:CollisionGroup;
    public function new() {
        super();
    }
    override function load(resources:Resources) {
        resources.add(new DataLoader("level_tmx"));
        var atlas=new JoinAtlas(2048,2048);
        atlas.add(new SparrowLoader("Untitled_1","Untitled_1_xml"));
        atlas.add(new TilesheetLoader("tiles", 10,10,1));
        atlas.add(new SparrowLoader("skins", "skins_xml"));
        atlas.add(new SparrowLoader("weapons", "weapons_xml"));
        atlas.add(new SparrowLoader("bullets", "bullets_xml"));
        atlas.add(new ImageLoader("ivankaArm"));
        resources.add(atlas);
        
    }

    override function init() {

        stageColor(0.5,.5,0.5);
       
        var simulationLayer=new Layer();
        GameGlobals.simulationLayer = simulationLayer;

      // simulationLayer.filter=new Filter([new ShRetro(Blend.blendMultipass()),new ShRgbSplit(Blend.blendDefault())],0.5,.5,0.5,1,false);
        
        
        ivanka=new Player();
        simulationLayer.addChild(ivanka.display);
        addChild(ivanka);
        
        enemiesCollisions=new CollisionGroup();
        for(i in 0...400){
            var enemy=new gameObjects.Enemy(100+Math.random()*1900,100);
            addChild(enemy);
            simulationLayer.addChild(enemy.display);
            enemiesCollisions.add(enemy.collision);
        }

        GameGlobals.bulletCollisions=bullets=new CollisionGroup();
       // stage.defaultCamera().offsetX=-1280/2;
       // stage.defaultCamera().offsetX=-720/2;
       // stage.defaultCamera().rotation=Math.PI/4;
        
        stage.addChild(simulationLayer);
        var tilemap:Tilemap=new Tilemap();
        tilemapCollision=tilemap.init("level_tmx","tiles",10,10,simulationLayer,4);
        stage.defaultCamera().limits(0,0,tilemapCollision.widthIntTiles*40,tilemapCollision.heightInTiles*40);
    }
    override function update(dt:Float) {
        super.update(dt);
        CollisionEngine.collide(tilemapCollision,ivanka.collision);
        CollisionEngine.collide(tilemapCollision,enemiesCollisions);
        enemiesCollisions.overlap(bullets,enemyVsBullet);
         bullets.collide(tilemapCollision,bulletsVsMap);
        stage.defaultCamera().setTarget(ivanka.display.x,ivanka.display.y);
    }
    function enemyVsBullet(a:ICollider,b:ICollider) {
        (cast a.userData).die();
        (cast b.userData).die();
    }
    function bulletsVsMap(a:ICollider,b:ICollider) {
        (cast b.userData).die();
    }
    override function destroy() {
        super.destroy();
        GameGlobals.clear();
    }
}