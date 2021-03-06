//class Wonderfl
package 
{
    import com.adobe.images.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class Wonderfl extends Object
    {
        public function Wonderfl()
        {
            super();
            return;
        }

        public static function capture(arg1:flash.display.DisplayObject=null):void
        {
            var $stage:flash.display.DisplayObject=null;
            var flashvars:Object;

            var loc1:*;
            $stage = arg1;
            if (called) 
            {
                return;
            }
            called = true;
            if (disabled) 
            {
                return;
            }
            if (!$stage) 
            {
                return;
            }
            stage = $stage;
            flashvars = flash.display.LoaderInfo($stage.root.loaderInfo).parameters;
            ticket = flashvars ? flashvars["ticket"] : null;
            code_uid = flashvars ? flashvars["code_uid"] : null;
            try 
            {
                receiver.allowDomain(flashvars ? flashvars["domain"] : null);
            }
            catch (e:Error)
            {
                onError(e);
            }
            if (!sender) 
            {
                try 
                {
                    receiver.connect("ew" + ticket);
                }
                catch (e:Error)
                {
                    onError(e);
                }
                conName = "we" + ticket;
                sender = new flash.net.LocalConnection();
                sender.addEventListener(flash.events.StatusEvent.STATUS, ignoreEvent);
                sender.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, ignoreEvent);
                try 
                {
                    sender.send(conName, "onCaptureReady");
                }
                catch (e:Error)
                {
                    onError(e);
                }
            }
            if (!ticket || !code_uid) 
            {
                return;
            }
            flash.utils.setTimeout(function ():void
            {
                if (disabled) 
                {
                    return;
                }
                flash.utils.setTimeout(_capture, delay * 1000);
                return;
            }, 0)
            return;
        }

        internal static function _capture():void
        {
            var bd:flash.display.BitmapData;
            var ba:flash.utils.ByteArray;
            var encoder:com.adobe.images.JPGEncoder;
            var url:String;
            var req:flash.net.URLRequest;
            var loader:flash.display.Loader;

            var loc1:*;
            bd = new flash.display.BitmapData(465, 465);
            sendMessageToJS("Taking Capture...");
            try 
            {
                bd.draw(stage);
            }
            catch (e:Error)
            {
                sendMessageToJS("Error: " + e.toString());
                return;
            }
            ba = new flash.utils.ByteArray();
            encoder = new com.adobe.images.JPGEncoder();
            ba = encoder.encode(bd);
            url = "/api/code/capture?code_uid=" + code_uid + "&ticket=" + ticket;
            req = new flash.net.URLRequest(url);
            req.contentType = "application/octet-stream";
            req.method = flash.net.URLRequestMethod.POST;
            req.data = ba;
            loader = new flash.display.Loader();
            addLoaderListeners(loader.contentLoaderInfo);
            loader.load(req);
            sendMessageToJS("Sending Capture to Server...");
            return;
        }

        internal static function sendMessageToJS(arg1:String):void
        {
            var msg:String;

            var loc1:*;
            msg = arg1;
            try 
            {
                sender.send(conName, "onSendMessageToJS", msg + "\n");
            }
            catch (e:Error)
            {
                onError(e);
            }
            return;
        }

        public static function disable_capture():void
        {
            disabled = true;
            return;
        }

        public static function capture_delay(arg1:int):void
        {
            delay = arg1;
            return;
        }

        public static function log(... rest):void
        {
            sendMessageToJS(rest.toString());
            return;
        }

        internal static function addLoaderListeners(arg1:flash.events.EventDispatcher):void
        {
            arg1.addEventListener(flash.events.IOErrorEvent.IO_ERROR, filterError);
            arg1.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, reportError);
            arg1.addEventListener(flash.events.Event.COMPLETE, onComplete);
            return;
        }

        internal static function filterError(arg1:flash.events.IOErrorEvent):void
        {
            if (new RegExp("2124").test(arg1.text)) 
            {
                printCompleteMessage(arg1.currentTarget);
            }
            return;
        }

        internal static function removeLoaderListeners(arg1:flash.events.EventDispatcher):void
        {
            arg1.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, reportError);
            arg1.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, reportError);
            arg1.removeEventListener(flash.events.Event.COMPLETE, onComplete);
            return;
        }

        internal static function reportError(arg1:flash.events.ErrorEvent):void
        {
            removeLoaderListeners(arg1.currentTarget as flash.events.EventDispatcher);
            sendMessageToJS("Error: " + arg1.text);
            return;
        }

        internal static function printCompleteMessage(arg1:Object):void
        {
            removeLoaderListeners(arg1 as flash.events.EventDispatcher);
            sendMessageToJS("Capture Saved");
            return;
        }

        internal static function onComplete(arg1:flash.events.Event):void
        {
            printCompleteMessage(arg1.currentTarget);
            return;
        }

        internal static function ignoreEvent(arg1:flash.events.Event):void
        {
            return;
        }

        internal static function onError(arg1:Error):void
        {
            return;
        }

        
        {
            disabled = false;
            delay = 3;
            called = false;
            _initialized = function ():Boolean
            {
                receiver = new flash.net.LocalConnection();
                receiver.client = {"takeCapture":_capture};
                receiver.addEventListener(flash.events.StatusEvent.STATUS, ignoreEvent);
                receiver.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, ignoreEvent);
                return true;
            }()
        }

        internal static var disabled:Boolean=false;

        internal static var delay:int=3;

        internal static var called:Boolean=false;

        internal static var receiver:flash.net.LocalConnection;

        internal static var sender:flash.net.LocalConnection;

        internal static var stage:flash.display.DisplayObject;

        internal static var ticket:String;

        internal static var code_uid:String;

        internal static var conName:String;

        internal static var _initialized:Boolean;
    }
}


