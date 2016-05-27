package
{
	import com.codechiev._2d.MovieClipController;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.getTimer;

	public class GlossyBtnTest extends Sprite
	{
		private var mcControl:MovieClipController;
		
		public function GlossyBtnTest()
		{
			
			var myLoader:Loader = new Loader();  
			var url:URLRequest = new URLRequest("test.swf"); 
			var wait:int = 0;
			var waitTime:int = 0;
			
			myLoader.load(url); 
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(evt:Event):void{
				var mc:MovieClip = MovieClip(myLoader.content);
				var ma:MovieClip = mc.abc;
				addChild(ma);  
				
				mcControl = new MovieClipController(ma);
				mcControl.play(10);
			});
			 
			addEventListener(Event.ENTER_FRAME,function():void{
				var timer:int = flash.utils.getTimer();
				if(mcControl){
					mcControl.stepForwardEvery(timer,2000);

				}
			});
		}
	}
}