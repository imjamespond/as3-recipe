package sliz.miniui.skin 
{
    import flash.display.*;
    
    public class SpriteSkin extends sliz.miniui.skin.SkinCore
    {
        public function SpriteSkin(arg1:flash.display.Sprite)
        {
            super();
            this.target = arg1;
            return;
        }

        protected var target:flash.display.Sprite;
    }
}


