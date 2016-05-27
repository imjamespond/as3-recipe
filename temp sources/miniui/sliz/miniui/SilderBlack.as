package sliz.miniui 
{
    import flash.display.*;
    import sliz.miniui.core.*;
    import sliz.miniui.skin.*;
    
    public class SilderBlack extends sliz.miniui.SpriteButton
    {
        public function SilderBlack(arg1:Number=0, arg2:Number=0, arg3:flash.display.DisplayObjectContainer=null, arg4:Function=null)
        {
            super(arg1, arg2, arg3, arg4);
            if (sliz.miniui.core.UIManager.silderBlackSkin == null) 
            {
                skin = new sliz.miniui.skin.SilderBlackSkin(this);
            }
            else 
            {
                skin = new sliz.miniui.core.UIManager.silderBlackSkin(this);
            }
            skin.init();
            return;
        }
    }
}


