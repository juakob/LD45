package states;

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
        var atlas=new JoinAtlas(2048,2048);
        atlas.add(new SparrowLoader("pig","pig_xml"));
        resources.add(atlas);
    }

    override function init() {
        var display=new BasicSprite("pig");
        display.timeline.frameRate=1/7;
        display.scaleX=2;
        display.scaleY=2;
        display.textureFilter=PointFilter;
        display.timeline.playAnimation("walk.png");
        stage.addChild(display);
    }
}