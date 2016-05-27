package testas
{
	import com.bit101.components.PushButton;
	import com.hexagonstar.display.bitmaps.AnimatedBitmap;
	import com.codechiev._2d.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.ByteArray;

	[SWF(width="1024", height="768", backgroundColor="#000000")]
	public class BitmapRotateTest extends Sprite
	{
		private var _imageContainer:Bitmap;
		private var _anim:AnimatedBitmap;
		public function BitmapRotateTest()
		{
			var btn1:PushButton = new PushButton(this, 0, 0, "open", startLoadingFile);
			var myText:TextField=new TextField();
			myText.width = 200;
			myText.height = 20;
			myText.type = TextFieldType.INPUT;
			myText.background = true;
			myText.backgroundColor = 0xffffff;
			myText.x = btn1.x + btn1.width + 10;
			myText.addEventListener(KeyboardEvent.KEY_DOWN,function(e:KeyboardEvent):void{
				if(e.keyCode == Keyboard.ENTER){
					if(null!=_anim){
						_anim.playOnFrameUpdate3(5,false);
						stage.addChild(_anim);
						_anim.x = stage.stageWidth/2;
						_anim.y = stage.stageHeight/2;
						_anim.angle = parseInt(myText.text);
					}					
				}
			});
			stage.addChild(myText);
			stage.addEventListener(Event.ENTER_FRAME,function():void{
				if(null!=_anim){
					_anim.onFrameUpdate();
				}
			});
		}
		
		// ------- Public Properties -------
		public static const IMAGE_VIEWPORT:Rectangle = new Rectangle(20, 40, 984, 708);
		// ------- Model -------
		// --- Load ---
		private var _loadFile:FileReference;
		
		private function startLoadingFile(e:Event):void
		{
			_loadFile = new FileReference();
			_loadFile.addEventListener(Event.SELECT, selectHandler);
			var fileFilter:FileFilter = new FileFilter("Images: (*.jpeg, *.jpg, *.gif, *.png)", "*.jpeg; *.jpg; *.gif; *.png");
			_loadFile.browse([fileFilter]);
		}
		
		private function selectHandler(event:Event):void
		{
			_loadFile.removeEventListener(Event.SELECT, selectHandler);
			
			//setDisplayState(PROGRESS);
			//_progressStateView.label = "Loading image...";
			//_progressStateView.source = _loadFile;
			
			_loadFile.addEventListener(Event.COMPLETE, loadCompleteHandler);
			_loadFile.load();
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			_loadFile.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			
			var loader:Loader = new Loader();
			
			//setDisplayState(PROGRESS);
			//_progressStateView.label = "Rendering image...";
			//_progressStateView.source = loader.contentLoaderInfo;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBytesHandler);
			loader.loadBytes(_loadFile.data);
		}
		
		private function loadBytesHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = (event.target as LoaderInfo);
			loaderInfo.removeEventListener(Event.COMPLETE, loadBytesHandler);
			
			showImage(loaderInfo.content);
		}
		
		private function showImage(bitmap:DisplayObject):void
		{
			if (_imageContainer == null)
			{
				//background
				var imageData:BitmapData = new BitmapData(IMAGE_VIEWPORT.width, IMAGE_VIEWPORT.height, true, 0x000000);
				var imageDataBackground:BitmapData = new BitmapData(IMAGE_VIEWPORT.width, IMAGE_VIEWPORT.height, false, 0xafafaf);
				var imageBackground:Bitmap = new Bitmap(imageDataBackground);
				_imageContainer = new Bitmap(imageData);
				
				//setDisplayState(CROP);
				addChildAt(imageBackground,0);
				addChild(_imageContainer);
				_imageContainer.x = IMAGE_VIEWPORT.x;
				_imageContainer.y = IMAGE_VIEWPORT.y;
				imageBackground.x = IMAGE_VIEWPORT.x;
				imageBackground.y = IMAGE_VIEWPORT.y;
			}
			
			var bd:BitmapData = new BitmapData(bitmap.width,bitmap.height,true,0x000000);
			bd.draw(bitmap);
			_anim = new AnimatedBitmap(bd, 83,31);
			_anim.rotateSequence(8);
			_imageContainer.bitmapData.draw(_anim.buffer);
			
		}
		
	}
}