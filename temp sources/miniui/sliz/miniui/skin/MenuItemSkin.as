package sliz.miniui.skin 
{
    import flash.display.*;
    import flash.text.*;
    
    public class MenuItemSkin extends sliz.miniui.skin.ButtonCoreSkin
    {
        public function MenuItemSkin(arg1:flash.text.TextField, arg2:flash.display.Sprite)
        {
            super(arg1, arg2);
            return;
        }

        public override function setState(arg1:int):void
        {
            this.state = arg1;
            target.filters = [];
            var loc1:*=arg1;
            switch (loc1) 
            {
                case 0:
                {
                    target.backgroundColor = loc1 = 16645629;
                    target.borderColor = loc1;
                    break;
                }
                case 1:
                {
                    target.borderColor = 3381759;
                    target.backgroundColor = 12902911;
                    break;
                }
                case 2:
                {
                    break;
                }
                case 4:
                {
                    target.textColor = 11184810;
                    break;
                }
            }
            return;
        }
    }
}


