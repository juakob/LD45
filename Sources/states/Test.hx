package states;

import com.framework.utils.XboxJoystick;
import com.framework.utils.VirtualGamepad;
import com.soundLib.SoundManager.SM;
import com.loading.basicResources.SoundLoader;
import format.swf.Data.BlendMode;
import format.png.Data;
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
        atlas.add(new SparrowLoader("drop", "drop_xml"));
        atlas.add(new SparrowLoader("weapons", "weapons_xml"));
        atlas.add(new SparrowLoader("bullets", "bullets_xml"));
        atlas.add(new SparrowLoader("pumpkinBlood", "pumpkinBlood_xml"));
        atlas.add(new ImageLoader("ivankaArm"));
        atlas.add(new ImageLoader("ivankaFace"));
        atlas.add(new ImageLoader("lightFocal"));
        atlas.add(new ImageLoader("policeCar"));
        atlas.add(new ImageLoader("light"));
        atlas.add(new ImageLoader("tree"));
        atlas.add(new ImageLoader("faceDead"));
        atlas.add(new ImageLoader("bodyDead"));
        atlas.add(new ImageLoader("guts"));
        atlas.add(new ImageLoader("moveButton"));
        resources.add(atlas);
        resources.add(new FontLoader("fofbb_reg_ttf"));
        resources.add(new Object3dLoader("gun3d_ogex"));
        resources.add(new SoundLoader("rain",false));
        
    }

    override function init() {
        SM.playMusic("rain");
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
                simulationLayer.addChild(layerTilemap.createDisplay(tileLayer));
            },
            parseMapObjects
        );
        stage.defaultCamera().limits(0,0,worldMap.widthIntTiles*40,worldMap.heightInTiles*40);

       simulationLayer.filter=new Filter([new ShRgbSplit(Blend.blendMultipass()),new ShFilmGrain(Blend.blendDefault())],0.5,.5,0.5,1,false);

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

        pumpkinIcon=new Object3d("gun3d_ogex");
        pumpkinIcon.x=1280-100;
        pumpkinIcon.y=100;
        pumpkinIcon.scaleX=40;
        pumpkinIcon.scaleY=40;
        pumpkinIcon.scaleZ=40;
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
        createTouchJoystick();
    }
    function createTouchJoystick() {
        var border:Int=20;
        var left=new BasicSprite("moveButton");
        left.smooth=false;
        left.x=border;
        left.scaleX=left.scaleY=2;
        left.y=720-border-left.height()*2;
        hudLayer.addChild(left);

  
        var right=new BasicSprite("moveButton");
        right.smooth=false;
        right.x=border+right.width()*2+border*4;
        right.scaleX=right.scaleY=2;
        right.offsetX=-right.width();
        right.scaleX*=-1;
        right.y=720-border-right.height()*2;
        hudLayer.addChild(right);

         var up=new BasicSprite("moveButton");
        up.smooth=false;
        up.x=1280-border-up.width()*2;
        up.scaleX=up.scaleY=2;
        up.recenter();
        //up.offsetX=-up.width();
        up.rotation=Math.PI/2;
        up.y=720-border-up.height()*2;
        hudLayer.addChild(up);
        
        var touchJoystick=new VirtualGamepad();
        touchJoystick.addButton(XboxJoystick.LEFT_DPAD,left.x+left.width(),left.y+left.height(),left.width());
        touchJoystick.addButton(XboxJoystick.RIGHT_DPAD,right.x+right.width(),right.y+right.height(),right.width());
        touchJoystick.addButton(XboxJoystick.A,1280-up.width()-border,up.y+up.height(),up.width());
        touchJoystick.addKeyButton(XboxJoystick.LEFT_DPAD,KeyCode.Left);
        touchJoystick.addKeyButton(XboxJoystick.RIGHT_DPAD,KeyCode.Right);
        touchJoystick.addKeyButton(XboxJoystick.UP_DPAD,KeyCode.Up);
        touchJoystick.addKeyButton(XboxJoystick.A,KeyCode.Space);
        touchJoystick.addKeyButton(XboxJoystick.X,KeyCode.X);
        touchJoystick.notify(ivanka.onAxisChange,ivanka.onButtonChange);

        var gamepad=Input.i.getGamepad(0);
        gamepad.notify(ivanka.onAxisChange,ivanka.onButtonChange);
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
        }else
        if(object.type=="rain"){
            var drops:Int=Std.int(object.width*object.height*4/1000);
            for(i in 0...drops){
                var drop=new fx.Drop(object.y*4,(object.y+object.height)*4,object.x*4,(object.x+object.width)*4,800+Math.random()*200);
                simulationLayer.addChild(drop.display);
                addChild(drop);
            }
        }else
        if(object.type=="asset"){
             var display=new BasicSprite(object.properties.get("asset"));
             display.scaleX=(object.width/display.width())*4;
             display.scaleY=(object.height/display.height())*4;
             display.offsetY=-display.height();// origin at the bottom?
             display.x=object.x*4;
             display.y=object.y*4;
             display.rotation=object.rotation*Math.PI/180;
             simulationLayer.addChild(display);
             if(object.properties.exists("blend")){
                if(object.properties.get("blend")=="add"){
                    display.blend=com.gEngine.display.BlendMode.Add;
                }
             }
             if(object.properties.exists("multiply")){
                 var color:kha.Color=kha.Color.fromString(object.properties.get("multiply"));
                 display.colorMultiplication(color.R,color.G,color.B,color.A);
             }
             display.smooth=!(object.properties.exists("smooth")&&object.properties.get("smooth")=="false");
        }
    }
    override function update(dt:Float) {
        super.update(dt);
        CollisionEngine.collide(worldMap.collision,ivanka.collision);
        CollisionEngine.collide(worldMap.collision,enemiesCollisions);
        enemiesCollisions.overlap(bullets,enemyVsBullet);
        enemiesCollisions.overlap(ivanka.collision,enemyVsIvanka);
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
    function enemyVsIvanka(a:ICollider,b:ICollider) {
        changeState(new Intro());
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