package sliz.miniui 
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.ui.*;
    import sliz.miniui.core.*;
    import sliz.miniui.skin.*;
    
    public class Input extends sliz.miniui.core.SkinAbleSprite
    {
        public function Input(arg1:String, arg2:String="input text", arg3:flash.display.DisplayObjectContainer=null, arg4:Function=null, arg5:Number=0, arg6:Number=0, arg7:Number=100, arg8:Number=15, arg9:Boolean=false)
        {
            this.tf = new flash.text.TextField();
            addChild(this.tf);
            this.defText = arg2;
            if (sliz.miniui.core.UIManager.inputSkin == null) 
            {
                skin = new sliz.miniui.skin.InputSkin(this.tf, this);
            }
            else 
            {
                skin = sliz.miniui.core.UIManager.inputSkin(this.tf, this);
            }
            super(skin);
            skin.init();
            this.tf.type = flash.text.TextFieldType.INPUT;
            this.tf.multiline = arg9;
            this.tf.wordWrap = true;
            this.tf.text = arg1;
            if (arg1 == "") 
            {
                this.isWaitInput = true;
            }
            this.checkInput();
            this.tf.width = arg7;
            this.tf.height = arg8;
            this.x = arg5;
            this.y = arg6;
            if (arg3) 
            {
                arg3.addChild(this);
            }
            if (arg4 != null) 
            {
                addEventListener(flash.events.KeyboardEvent.KEY_UP, this.onKeyUp);
                this.func = arg4;
            }
            addEventListener(flash.events.FocusEvent.FOCUS_IN, this.onFocusIn);
            addEventListener(flash.events.FocusEvent.FOCUS_OUT, this.onFocusOut);
            return;
        }

        internal function onFocusIn(arg1:flash.events.FocusEvent=null):void
        {
            skin.setState(0);
            return;
        }

        internal function onFocusOut(arg1:flash.events.FocusEvent):void
        {
            if (this.tf.text == "") 
            {
                this.isWaitInput = true;
            }
            else 
            {
                this.isWaitInput = false;
            }
            skin.setState(1);
            this.checkInput();
            return;
        }

        public function checkInput():void
        {
            if (this.isWaitInput) 
            {
                skin.setState(2);
            }
            return;
        }

        internal function onKeyUp(arg1:flash.events.KeyboardEvent):void
        {
            if (arg1.keyCode == flash.ui.Keyboard.ENTER) 
            {
                this.func();
            }
            return;
        }

        public function get text():String
        {
            return this.isWaitInput ? "" : this.tf.text;
        }

        public function set text(arg1:String):void
        {
            this.tf.text = arg1;
            this.isWaitInput = false;
            this.onFocusIn();
            return;
        }

        internal var func:Function;

        public var tf:flash.text.TextField;

        public var defText:String;

        public var isWaitInput:Boolean=false;
    }
}


