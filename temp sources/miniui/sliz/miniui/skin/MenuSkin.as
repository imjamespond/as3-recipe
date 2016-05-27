package sliz.miniui.skin 
{
    import flash.display.*;
    
    public class MenuSkin extends sliz.miniui.skin.SpriteSkin
    {
        public function MenuSkin(arg1:flash.display.Sprite)
        {
            super(arg1);
            return;
        }

        public override function updateSkin():void
        {
            target.graphics.clear();
            target.graphics.beginFill(8421504);
            target.graphics.drawRect(-1, -1, target.width + 3, target.height + 3);
            return;
        }
    }
}


