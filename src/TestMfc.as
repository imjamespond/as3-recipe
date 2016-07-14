package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.text.TextField;

	public class TestMfc extends Sprite
	{
		[Embed(source="/../embeds/floor_diffuse.jpg")]
		public static var FloorDiffuse:Class;
		
		[Embed(source="/../embeds/leaf.swf")]
		public static var Bird:Class;
		
		public static var self:TestMfc;
		
		public function TestMfc()
		{
			self = this;
			
			var func: Function = function TestFunction1(he:String):void
			{
				self.addChild(new FloorDiffuse());
				
				var tx:TextField = new TextField();
				tx.text = he;
				self.addChild(tx);
				
				var bird:MovieClip = new Bird() as MovieClip;
				bird.gotoAndStop(0);
				self.addChild(bird);
			};
			// The following is called from our host 
			// Register TestFunction1 to be called
			flash.external.ExternalInterface.addCallback("foobar",  func); 		
		}
		


	}
}