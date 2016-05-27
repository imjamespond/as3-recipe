package com.codechiev.away3d
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ResourcesManager
	{
		static public var TEXTURE:uint = 1;
		static public var resources:Dictionary = new Dictionary();
		public function ResourcesManager()
		{
		}
		
		static public function getResourceBytesArray(assest:String):ByteArray{
			return resources[assest] as ByteArray;
		}
		
		static public function load(assest:String, type:uint, name:String, loaderDone:Function=null):void{
			var loader:URLLoader = new URLLoader();

			loader.addEventListener(Event.COMPLETE, function(e:Event):void{
				if(loaderDone!=null)
					loaderDone(e.target.data, type, name);

				resources[assest] = e.target.data;
						
				//loader.removeEventListener(Event.COMPLETE);
				//loader.removeEventListener(IOErrorEvent.IO_ERROR);
			});			
			loader.addEventListener(IOErrorEvent.IO_ERROR, function errorHandler(e:IOErrorEvent):void {
				trace("Had problem loading File.");
				//loader.removeEventListener(Event.COMPLETE);
				//loader.removeEventListener(IOErrorEvent.IO_ERROR);
			});
			
			try {
				loader.load(new URLRequest(assest));
			}catch (error:SecurityError){
				trace("A SecurityError has occurred.");
			}
		}
	}
}