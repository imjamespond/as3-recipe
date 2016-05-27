package sliz.miniui 
{
    import sliz.miniui.core.*;
    import sliz.miniui.skin.*;
    
    public class TabItem extends sliz.miniui.MenuItem
    {
        public function TabItem(arg1:String, arg2:Number)
        {
            super(arg1, arg2);
            if (sliz.miniui.core.UIManager.tabItemSkin == null) 
            {
                setSkin(new sliz.miniui.skin.TabItemSkin(tf, this));
            }
            else 
            {
                setSkin(new sliz.miniui.core.UIManager.tabItemSkin(tf, this));
            }
            setState(0);
            return;
        }
    }
}


