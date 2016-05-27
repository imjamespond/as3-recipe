package sliz.miniui.skin 
{
    import flash.display.*;
    import sliz.miniui.*;
    
    public class ScrollBarSkin extends sliz.miniui.skin.SpriteSkin
    {
        public function ScrollBarSkin(arg1:flash.display.Sprite)
        {
            super(arg1);
            return;
        }

        public override function updateSkin():void
        {
            target.graphics.clear();
            target.graphics.lineStyle(1, 10526880);
            target.graphics.beginFill(15724527);
            var loc1:*=13;
            var loc2:*=(target as sliz.miniui.Silder).diffX;
            target.graphics.drawRect(-loc2, (-loc1) / 2, (target as sliz.miniui.Silder).l + loc2 * 2, loc1);
            return;
        }
    }
}


