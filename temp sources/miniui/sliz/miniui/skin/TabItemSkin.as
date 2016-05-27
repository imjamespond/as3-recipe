package sliz.miniui.skin 
{
    import flash.display.*;
    import flash.text.*;
    
    public class TabItemSkin extends sliz.miniui.skin.ButtonCoreSkin
    {
        public function TabItemSkin(arg1:flash.text.TextField, arg2:flash.display.Sprite)
        {
            super(arg1, arg2);
            return;
        }

        public override function setState(arg1:int):void
        {
            this.state = arg1;
            var loc1:*=arg1;
            switch (loc1) 
            {
                case 0:
                case 2:
                {
                    target.filters = [sliz.miniui.skin.Style.btnFilter];
                    target.borderColor = 10526880;
                    target.backgroundColor = 15329769;
                    target.textColor = 0;
                    target.defaultTextFormat = sliz.miniui.skin.Style.btnTfm;
                    target.setTextFormat(sliz.miniui.skin.Style.btnTfm);
                    break;
                }
                case 1:
                {
                    target.filters = [sliz.miniui.skin.Style.btnOverFilter, sliz.miniui.skin.Style.glowOverFilter];
                    target.borderColor = 10526880;
                    target.backgroundColor = 15329769;
                    target.textColor = 0;
                    target.defaultTextFormat = sliz.miniui.skin.Style.btnTfm;
                    target.setTextFormat(sliz.miniui.skin.Style.btnTfm);
                    break;
                }
                case 3:
                {
                    target.filters = [sliz.miniui.skin.Style.btnDownFilter];
                    target.borderColor = 10526880;
                    target.textColor = 0;
                    target.backgroundColor = 16777215;
                    target.defaultTextFormat = sliz.miniui.skin.Style.boldTfm;
                    target.setTextFormat(sliz.miniui.skin.Style.boldTfm);
                    break;
                }
                case 4:
                {
                    target.filters = [];
                    target.textColor = loc1 = 11184810;
                    target.borderColor = loc1;
                    target.backgroundColor = 15329769;
                    target.defaultTextFormat = sliz.miniui.skin.Style.btnTfm;
                    target.setTextFormat(sliz.miniui.skin.Style.btnTfm);
                    break;
                }
            }
            return;
        }
    }
}


