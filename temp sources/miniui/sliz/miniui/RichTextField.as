package sliz.miniui 
{
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    
    public class RichTextField extends flash.display.Sprite
    {
        public function RichTextField(arg1:String, arg2:flash.display.DisplayObjectContainer=null, arg3:Number=0, arg4:Number=0, arg5:Number=NaN)
        {
            super();
            this.label = new sliz.miniui.Label(arg1, this, 0, 0, arg5);
            addChild(this.label);
            if (arg2) 
            {
                arg2.addChild(this);
            }
            this.x = arg3;
            this.y = arg4;
            return;
        }

        public function updateFace():void
        {
            var loc2:*=null;
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=null;
            var loc6:*=0;
            var loc7:*=null;
            var loc8:*=null;
            this.faceWrapper.graphics.clear();
            var loc1:*=new flash.geom.Matrix();
            var loc9:*=0;
            var loc10:*=this.faceStrs;
            for each (loc2 in loc10) 
            {
                loc3 = this.faceRegs[loc2];
                loc4 = this.faceBmds[loc2];
                for (;;) 
                {
                    var loc11:*;
                    loc5 = loc11 = loc3.exec(this.label.text);
                    if (!loc11) 
                    {
                        break;
                    }
                    loc6 = loc5.index;
                    loc7 = this.label.getCharBoundaries(loc6);
                    loc1.tx = loc7.x;
                    loc1.ty = loc7.y;
                    this.faceWrapper.graphics.beginBitmapFill(loc4, loc1);
                    this.faceWrapper.graphics.drawRect(loc7.x, loc7.y, loc4.width, loc4.height);
                    (loc8 = new flash.text.TextFormat()).size = 1;
                    loc8.letterSpacing = (loc4.width - loc2.length) / loc2.length;
                    this.label.setTextFormat(loc8, loc6, loc6 + loc2.length);
                }
            }
            return;
        }

        public function setFace(arg1:String, arg2:flash.display.BitmapData):void
        {
            if (this.faceStrs == null) 
            {
                this.faceStrs = [];
                this.faceRegs = [];
                this.faceBmds = [];
                this.faceWrapper = new flash.display.Shape();
                addChild(this.faceWrapper);
            }
            this.faceStrs.push(arg1);
            this.faceRegs[arg1] = new RegExp(arg1, "g");
            this.faceBmds[arg1] = arg2;
            return;
        }

        public var label:sliz.miniui.Label;

        internal var faceWrapper:flash.display.Shape;

        internal var faceStrs:Array;

        internal var faceRegs:Array;

        internal var faceBmds:Array;
    }
}


