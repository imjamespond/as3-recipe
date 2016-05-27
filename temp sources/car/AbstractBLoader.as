package com.codechiev.car
{
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import fr.digitas.flowearth.command.*;
    import fr.digitas.flowearth.core.*;
    import fr.digitas.flowearth.event.*;

    public class AbstractBLoader extends BatchableDecorator implements IBatchable, IProgressor
    {
        public var params:Object;
        var _request:URLRequest;
        var _context:LoaderContext;
        var _statusMessage:String;
        var _failOnError:Boolean;
        private var _ed:IEventDispatcher;

        public function AbstractBLoader(param1:URLRequest, param2:LoaderContext = null, param3:Object = null, param4:String = null, param5:Boolean = false) : void
        {
            super(null);
            this._failOnError = param5;
            this._request = param1;
            this._context = param2;
            this._statusMessage = param4;
            this.params = param3;
            return;
        }// end function

        public function get request() : URLRequest
        {
            return this._request;
        }// end function

        public function get context() : LoaderContext
        {
            return this._context;
        }// end function

        override public function execute() : void
        {
            if (this.request.url == "")
            {
                throw new Error("fr.digitas.flowearth.net.AbstractBLoader - execute : empty url");
            }
            this.sendStatus(new StatusEvent(StatusEvent.STATUS, false, false, this._statusMessage || "loading media : " + this.request.url, "status"));
            return;
        }// end function

        override public function toString() : String
        {
            return "[" + getQualifiedClassName(this) + "] url " + (this._request != null ? (this._request.url) : ("null"));
        }// end function

        protected function register(param1:IEventDispatcher) : void
        {
            if (this._ed)
            {
                this.unregister();
            }
            this._ed = param1;
            param1.addEventListener(Event.INIT, this.onInit);
            param1.addEventListener(Event.COMPLETE, this.sendComplete);
            param1.addEventListener(ProgressEvent.PROGRESS, this.sendProgress);
            param1.addEventListener(IOErrorEvent.IO_ERROR, this.sendError);
            param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.sendError);
            param1.addEventListener(Event.OPEN, this.sendOpen);
            return;
        }// end function

        protected function unregister() : void
        {
            if (!this._ed)
            {
                return;
            }
            this._ed.removeEventListener(Event.INIT, this.onInit);
            this._ed.removeEventListener(Event.COMPLETE, this.sendComplete);
            this._ed.removeEventListener(ProgressEvent.PROGRESS, this.sendProgress);
            this._ed.removeEventListener(IOErrorEvent.IO_ERROR, this.sendError);
            this._ed.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.sendError);
            this._ed.removeEventListener(Event.OPEN, this.sendOpen);
            this._ed = null;
            return;
        }// end function

        protected function onInit(event:Event) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        public function sendError(event:ErrorEvent) : void
        {
            dispatchEvent(new BatchErrorEvent(ErrorEvent.ERROR, this, event.text, this._failOnError));
            return;
        }// end function

        public function sendProgress(event:ProgressEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        public function sendOpen(event:Event) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        public function sendComplete(event:Event) : void
        {
            this.unregister();
            dispatchEvent(event);
            return;
        }// end function

        public function sendStatus(event:StatusEvent) : void
        {
            dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, this._statusMessage || "loading " + this.request.url));
            return;
        }// end function

    }
}
