package states;

import com.collision.platformer.CollisionBox;
import format.tmx.Data.TmxTileLayer;
import format.tmx.Data.TmxObject;
import kha.Color;
import kha.Assets;
import com.gEngine.display.TextDisplay;
import com.loading.basicResources.FontLoader;
import com.TimeManager;
import com.g3d.Object3d;
import com.g3d.Object3dLoader;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.gEngine.display.BasicSprite;
import com.gEngine.display.StaticLayer;
import fx.Blood;
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
    var worldMap:Tilemap;
    var ivanka:Player;
    var enemiesCollisions:CollisionGroup;
    var doors:CollisionGroup;
    var bullets:CollisionGroup;
    var hudLayer:StaticLayer;
    var pumpkinIcon:Object3d;
    var pumpkinKillText:TextDisplay;
    var pumpkinKill:Int=0;
    var simulationLayer:Layer;
    var room:String;
    var fromRoom:String;
    public function new(room:String,fromRoom:String=null) {
        super();
        this.room = room;
        this.fromRoom = fromRoom;
    }
    override function load(resources:Resources) {
        resources.add(new DataLoader(room+"_tmx"));
        var atlas=new JoinAtlas(2048,2048);
        atlas.add(new TilesheetLoader("tiles", 10,10,1));
        atlas.add(new SparrowLoader("skins", "skins_xml"));
        atlas.add(new SparrowLoader("weapons", "weapons_xml"));
        atlas.add(new SparrowLoader("bullets", "bullets_xml"));
        atlas.add(new SparrowLoader("pumpkinBlood", "pumpkinBlood_xml"));
        atlas.add(new ImageLoader("ivankaArm"));
        atlas.add(new ImageLoader("ivankaFace"));
        resources.add(atlas);
        resources.add(new FontLoader("fofbb_reg_ttf"));
        resources.add(new Object3dLoader("pumpkin_ogex"));
        
    }

    override function init() {

        stageColor(0.5,.5,0.5);
       
        simulationLayer=new Layer();
        var backgroundLayer=new Layer();
        simulationLayer.addChild(backgroundLayer);
        GameGlobals.simulationLayer = simulationLayer;
       stage.addChild(simulationLayer);

        hudLayer=new StaticLayer();
        stage.addChild(hudLayer);

        enemiesCollisions=new CollisionGroup();
        doors=new CollisionGroup();

        worldMap=new Tilemap(room+"_tmx","tiles",4);
        worldMap.init(
            function(layerTilemap,tileLayer){
                if(!tileLayer.properties.exists("noCollision")){
                    layerTilemap.createCollisions(tileLayer);
                }
                layerTilemap.createDisplay(tileLayer);
            },
            parseMapObjects
        );
        stage.defaultCamera().limits(0,0,worldMap.widthIntTiles*40,worldMap.heightInTiles*40);
        backgroundLayer.addChild(worldMap.display);
        
       
       

      // simulationLayer.filter=new Filter([new ShRetro(Blend.blendMultipass()),new ShRgbSplit(Blend.blendDefault())],0.5,.5,0.5,1,false);
        
        
        
        
        
        
        

        GameGlobals.bulletCollisions=bullets=new CollisionGroup();
       // stage.defaultCamera().offsetX=-1280/2;
       // stage.defaultCamera().offsetX=-720/2;
       // stage.defaultCamera().rotation=Math.PI/4;

         
       
       

        GameGlobals.blood=new Blood(this,simulationLayer);
        
        
        var ivankaFace:BasicSprite=new BasicSprite("ivankaFace");
        ivankaFace.x=ivankaFace.y=20;
        ivankaFace.scaleX=ivankaFace.scaleY=4;
        ivankaFace.smooth=false;
        hudLayer.addChild(ivankaFace);

        pumpkinIcon=new Object3d("pumpkin_ogex");
        pumpkinIcon.x=1280-100;
        pumpkinIcon.y=100;
        pumpkinIcon.scaleX=4;
        pumpkinIcon.scaleY=4;
        pumpkinIcon.scaleZ=4;
        pumpkinIcon.z=-40;
        pumpkinIcon.angleZ=Math.PI;
        pumpkinIcon.rotation=0;
        hudLayer.addChild(pumpkinIcon);

        pumpkinKillText=new TextDisplay(Assets.fonts.fofbb_reg);
        pumpkinKillText.x=1280-200;
        pumpkinKillText.y=60;
        pumpkinKillText.fontSize=40;
        pumpkinKillText.color=Color.Orange;
        pumpkinKillText.text=pumpkinKill+"";
        hudLayer.addChild(pumpkinKillText);
    
    }
    function parseMapObjects(layerTilemap:Tilemap,object:TmxObject){
        if(object.type=="enemy"){
            var count=Std.parseInt(object.properties.get("enemyCount"));
            for(i in 0...count){
                var enemy=new gameObjects.Enemy(object.x*4+Math.random()*object.width*4,object.y*4+Math.random()*object.height*4);
                addChild(enemy);
                simulationLayer.addChild(enemy.display);
                enemiesCollisions.add(enemy.collision);
            }
        }else
        if(object.type=="player"&&ivanka==null){
            ivanka=new Player(object.x*4,object.y*4);
            simulationLayer.addChild(ivanka.display);
            addChild(ivanka);
        }else
        if(object.type=="door"){
            var door=new CollisionBox();
            door.x=object.x*4;
            door.y=object.y*4;
            door.width=object.width*4;
            door.height=object.height*4;
            door.userData=object.properties.get("goTo");
            doors.add(door);
            if(door.userData==fromRoom){
                if(ivanka==null){
                    ivanka=new Player(object.x*4,object.y*4);
                    simulationLayer.addChild(ivanka.display);
                    addChild(ivanka);
                }else{
                    ivanka.collision.x=object.x*4;
                    ivanka.collision.y=object.y*4;
                }
            }
        }
    }
    override function update(dt:Float) {
        super.update(dt);
        CollisionEngine.collide(worldMap.collision,ivanka.collision);
        CollisionEngine.collide(worldMap.collision,enemiesCollisions);
        enemiesCollisions.overlap(bullets,enemyVsBullet);
        if(ivanka.interact) ivanka.collision.overlap(doors,ivankaVsDoors);
         bullets.collide(worldMap.collision,bulletsVsMap);
        stage.defaultCamera().setTarget(ivanka.display.x,ivanka.display.y);

        if(Input.i.isKeyCodePressed(KeyCode.R)){
            changeState(new Intro());
        }
        pumpkinIcon.rotation=Math.PI/4*Math.sin(TimeManager.time);
    }
    function enemyVsBullet(a:ICollider,b:ICollider) {
        (cast a.userData).damage();
        (cast b.userData).die();
        ++pumpkinKill;
        pumpkinKillText.text=pumpkinKill+"";
    }
    function ivankaVsDoors(a:ICollider,b:ICollider) {
       changeState(new Test(a.userData,room));
    }
    function bulletsVsMap(a:ICollider,b:ICollider) {
        (cast b.userData).die();
    }
    override function destroy() {
        super.destroy();
        GameGlobals.clear();
    }
}