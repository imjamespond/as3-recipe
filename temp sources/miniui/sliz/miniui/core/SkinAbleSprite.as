package sliz.miniui.core 
{
    import flash.display.*;
    import sliz.miniui.skin.*;
    
    public class SkinAbleSprite extends flash.display.Sprite implements sliz.miniui.skin.ISkinAble
    {
        public function SkinAbleSprite(arg1:sliz.miniui.skin.SkinCore)
        {
            super();
            this.skin = arg1;
            return;
        }

        public function updateSkin():void
        {
            this.skin.updateSkin();
            return;
        }

        public function setState(arg1:int):void
        {
            this.skin.setState(arg1);
            return;
        }

        public function setSkin(arg1:sliz.miniui.skin.SkinCore):void
        {
            this.skin = arg1;
            return;
        }

        public function getSkin():sliz.miniui.skin.SkinCore
        {
            return this.skin;
        }

        protected var skin:sliz.miniui.skin.SkinCore;
    }
}


