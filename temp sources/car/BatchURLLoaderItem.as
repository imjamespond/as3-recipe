package com.codechiev.car
{
    import flash.net.*;
    import fr.digitas.flowearth.event.*;

    public class BatchURLLoaderItem extends AbstractBLoader
    {
        public var dataFormat:String;
        var _loader:URLLoader;

        public function BatchURLLoaderItem(param1:URLRequest, param2:Object = null, param3:String = null, param4:Boolean = false) : void
        {
            super(param1, context, param2, param3, param4);
            return;
        }// end function

        public function get data()
        {
            if (this._loader)
            {
                return this._loader.data;
            }
            return null;
        }// end function

        override public function execute() : void
        {
            super.execute();
            this._loader = new URLLoader();
            if (this.dataFormat)
            {
                this._loader.dataFormat = this.dataFormat;
            }
            register(this._loader);
            this._loader.load(_request);
            return;
        }// end function

        override public function dispose() : void
        {
            try
            {
                this._loader.close();
            }
            catch (e:Error)
            {
            }
            unregister();
            dispatchEvent(new BatchEvent(BatchEvent.DISPOSED, this));
            return;
        }// end function

    }
}
