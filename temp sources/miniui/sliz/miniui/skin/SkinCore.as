package sliz.miniui.skin 
{
    public class SkinCore extends Object
    {
        public function SkinCore()
        {
            super();
            return;
        }

        public function updateSkin():void
        {
            this.setState(this.state);
            return;
        }

        public function setState(arg1:int):void
        {
            this.state = arg1;
            return;
        }

        public function init():void
        {
            return;
        }

        protected var state:int=0;
    }
}


