package sliz.miniui 
{
    import flash.events.*;
    
    public class RadioGroup extends Object
    {
        public function RadioGroup(arg1:Array=null)
        {
            var loc1:*=null;
            this.radios = [];
            super();
            if (arg1) 
            {
                var loc2:*=0;
                var loc3:*=arg1;
                for each (loc1 in loc3) 
                {
                    this.add(loc1);
                }
            }
            return;
        }

        public function add(arg1:sliz.miniui.Radio):void
        {
            this.radios.push(arg1);
            arg1.addEventListener(flash.events.MouseEvent.CLICK, this.onClick);
            return;
        }

        internal function onClick(arg1:flash.events.MouseEvent):void
        {
            var loc2:*=null;
            var loc1:*=arg1.currentTarget as sliz.miniui.Radio;
            loc1.setToggle(true);
            var loc3:*=0;
            var loc4:*=this.radios;
            for each (loc2 in loc4) 
            {
                if (loc2 == loc1) 
                {
                    continue;
                }
                loc2.setToggle(false);
            }
            return;
        }

        internal var radios:Array;
    }
}


