package sliz.miniui 
{
    import sliz.miniui.core.*;
    import sliz.miniui.skin.*;
    
    public class MenuItem extends sliz.miniui.Button
    {
        public function MenuItem(arg1:String, arg2:Number)
        {
            super(arg1);
            if (sliz.miniui.core.UIManager.menuItemSkin == null) 
            {
                setSkin(new sliz.miniui.skin.MenuItemSkin(tf, this));
            }
            else 
            {
                setSkin(new sliz.miniui.core.UIManager.menuItemSkin(tf, this));
            }
            if (arg2 != -1) 
            {
                tf.wordWrap = true;
                tf.width = arg2;
            }
            setState(0);
            tf.background = true;
            return;
        }
    }
}


