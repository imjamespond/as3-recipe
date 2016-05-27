package sliz.miniui.layouts 
{
    import flash.display.*;
    import flash.geom.*;
    import sliz.miniui.*;
    
    public class BoxLayout extends sliz.miniui.layouts.Layout
    {
        public function BoxLayout(arg1:sliz.miniui.Panel, arg2:int=0, arg3:Number=0)
        {
            super(arg1);
            this.axis = arg2;
            this.gap = arg3;
            return;
        }

        public override function doLayout():void
        {
            var loc1:*=NaN;
            var loc2:*=null;
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=NaN;
            var loc6:*=NaN;
            if (this.axis != Y_AXIS) 
            {
                if (!this.h) 
                {
                    this.h = 0;
                    loc7 = 0;
                    loc8 = target.childs;
                    for each (loc2 in loc8) 
                    {
                        loc3 = loc2.c;
                        loc4 = loc3.getBounds(loc3);
                        this.h = Math.max(this.h, loc4.height);
                    }
                }
                loc6 = 0;
                loc7 = 0;
                loc8 = target.childs;
                for each (loc2 in loc8) 
                {
                    loc3 = loc2.c;
                    loc4 = loc3.getBounds(loc3);
                    loc5 = loc2.l;
                    loc3.y = Math.round(-loc4.top + (this.h - loc4.height) * loc5 + target.top);
                    loc3.x = loc6 + target.left;
                    loc6 = loc6 + (loc4.right + this.gap);
                }
                target.setWH(loc6 - this.gap, this.h);
            }
            else 
            {
                if (!this.w) 
                {
                    this.w = 0;
                    var loc7:*=0;
                    var loc8:*=target.childs;
                    for each (loc2 in loc8) 
                    {
                        loc3 = loc2.c;
                        loc4 = loc3.getBounds(loc3);
                        this.w = Math.max(this.w, loc4.width);
                    }
                }
                loc1 = 0;
                loc7 = 0;
                loc8 = target.childs;
                for each (loc2 in loc8) 
                {
                    loc3 = loc2.c;
                    loc4 = loc3.getBounds(loc3);
                    loc5 = loc2.l;
                    loc3.x = Math.round(-loc4.left + (this.w - loc4.width) * loc5 + target.left);
                    loc3.y = loc1 + target.top;
                    loc1 = loc1 + (loc4.bottom + this.gap);
                }
                target.setWH(this.w, loc1 - this.gap);
            }
            return;
        }

        public static const X_AXIS:int=0;

        public static const Y_AXIS:int=1;

        public var axis:int;

        public var w:Number;

        public var h:Number;

        internal var gap:Number=0;
    }
}


