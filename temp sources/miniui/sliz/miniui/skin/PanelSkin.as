package sliz.miniui.skin 
{
    import flash.display.*;
    import sliz.miniui.*;
    
    public class PanelSkin extends sliz.miniui.skin.SpriteSkin
    {
        public function PanelSkin(arg1:flash.display.Sprite)
        {
            super(arg1);
            return;
        }

        public override function updateSkin():void
        {
            var loc1:*=target as sliz.miniui.Panel;
            loc1.graphics.clear();
            loc1.graphics.lineStyle(0, 10066329);
            loc1.graphics.beginFill(15658734);
            loc1.graphics.drawRoundRect(0, 0, loc1.maxW + loc1.left + loc1.right, loc1.maxH + loc1.top + loc1.bottom, 2, 2);
            return;
        }
    }
}


