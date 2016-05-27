package sliz.miniui.skin 
{
    import flash.display.*;
    import sliz.miniui.*;
    
    public class SilderSkin extends sliz.miniui.skin.SpriteSkin
    {
        public function SilderSkin(arg1:flash.display.Sprite)
        {
            super(arg1);
            return;
        }

        public override function updateSkin():void
        {
            target.graphics.clear();
            target.graphics.lineStyle(0);
            target.graphics.drawRoundRect(0, 0, (target as sliz.miniui.Silder).l, 2, 5, 5);
            return;
        }
    }
}


