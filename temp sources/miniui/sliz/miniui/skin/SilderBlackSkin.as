package sliz.miniui.skin 
{
    import flash.display.*;
    import flash.geom.*;
    
    public class SilderBlackSkin extends sliz.miniui.skin.SpriteSkin
    {
        public function SilderBlackSkin(arg1:flash.display.Sprite)
        {
            this.ct = new flash.geom.ColorTransform();
            super(arg1);
            return;
        }

        public override function init():void
        {
            var loc1:*=new flash.geom.Matrix();
            var loc2:*=5;
            loc1.createGradientBox(loc2 * 2, loc2 * 2, 0, -loc2, -loc2);
            target.graphics.lineStyle(0);
            target.graphics.beginGradientFill(flash.display.GradientType.LINEAR, [16777215, 12105912], [1, 1], [0, 255], loc1);
            target.graphics.drawCircle(0, 0, 5);
            return;
        }

        public override function setState(arg1:int):void
        {
            super.setState(arg1);
            var loc1:*=arg1;
            switch (loc1) 
            {
                case 0:
                case 2:
                {
                    this.ct.redMultiplier = 1;
                    this.ct.greenMultiplier = 1;
                    this.ct.blueMultiplier = 1;
                    target.transform.colorTransform = this.ct;
                    break;
                }
                case 1:
                {
                    this.ct.redMultiplier = 0.8;
                    this.ct.greenMultiplier = 0.8;
                    this.ct.blueMultiplier = 0.8;
                    target.transform.colorTransform = this.ct;
                    break;
                }
                case 3:
                {
                    this.ct.redMultiplier = 0.5;
                    this.ct.greenMultiplier = 0.5;
                    this.ct.blueMultiplier = 0.5;
                    target.transform.colorTransform = this.ct;
                    break;
                }
                case 4:
                {
                    this.ct.redMultiplier = 1;
                    this.ct.greenMultiplier = 1;
                    this.ct.blueMultiplier = 1;
                    target.transform.colorTransform = this.ct;
                    break;
                }
            }
            return;
        }

        internal var ct:flash.geom.ColorTransform;
    }
}


