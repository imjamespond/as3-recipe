package
{
	import com.bit101.components.PushButton;
	import com.codechiev._2d.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Encoder;

	[SWF(width="1024", height="768", backgroundColor="#000000")]
	public class BitmapCompositTest extends Sprite
	{
		private var _imageContainer:Bitmap;
		private var adaptWidth_:uint;
		private var adaptHeight_:uint;
		private var adaptHeightOffset_:uint;	
		private var viewPoint_:Rectangle;
		private var loadFile_:FileReferenceList;
		private var loadIndex_:uint = 0;
		/**
		 *按钮事件
		 */
		public function BitmapCompositTest()
		{
			viewPoint_ = new Rectangle(10, 10, stage.stageWidth-20, stage.stageHeight-20);
			var btn1:PushButton = new PushButton(this, 0, 0, "open", startLoadingFile);
			var btn2:PushButton = new PushButton(this, btn1.x + btn1.width + 10, 0, "save", cropAndSave);
		}

		/**
		 *开启选择文件
		 * @param e
		 * 
		 */
		private function startLoadingFile(e:Event):void
		{
			loadFile_ = new FileReferenceList();
			loadFile_.addEventListener(Event.SELECT, selectHandler);
			var fileFilter:FileFilter = new FileFilter("Images: (*.jpeg, *.jpg, *.gif, *.png)", "*.jpeg; *.jpg; *.gif; *.png");
			loadFile_.browse([fileFilter]);
		}
		
		/**
		 * 选中文件事件
		 * @param event
		 * 
		 */
		private function selectHandler(event:Event):void
		{
			loadFile_.removeEventListener(Event.SELECT, selectHandler);
			loadIndex_=0;
			loadOne(loadIndex_++);
		}
		private function loadOne(index:uint):void
		{
			var file:FileReference;	
			if (index < loadFile_.fileList.length) {
				file = FileReference(loadFile_.fileList[index]);
				file.addEventListener(Event.COMPLETE, loadCompleteHandler);
				file.load();
			}
		}
		
		/**
		 *文件载入完毕 
		 * @param event
		 * 
		 */
		private function loadCompleteHandler(event:Event):void
		{
			var file:FileReference = FileReference(event.target);
			file.removeEventListener(Event.COMPLETE, loadCompleteHandler);
	
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBytesHandler);
			loader.loadBytes(file.data);
		}
		
		/**
		 * 载入文件数据完毕
		 * @param event
		 * 
		 */
		private function loadBytesHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = (event.target as LoaderInfo);
			loaderInfo.removeEventListener(Event.COMPLETE, loadBytesHandler);
			
			showImage(loaderInfo.content);
			loadOne(loadIndex_++);
		}
		
		private function showImage(bitmap:DisplayObject):void
		{
			if(_imageContainer == null){
				//initialize background,canvas
				var emptyData:BitmapData = new BitmapData(viewPoint_.width, viewPoint_.height, true, 0x000000);
				var bgData:BitmapData = new BitmapData(viewPoint_.width, viewPoint_.height, false, 0xafafaf);
				var bgImage:Bitmap = new Bitmap(bgData);
				_imageContainer = new Bitmap(emptyData);
				
				addChildAt(bgImage,0);
				addChild(_imageContainer);
				_imageContainer.x = viewPoint_.x;
				_imageContainer.y = viewPoint_.y;
				bgImage.x = viewPoint_.x;
				bgImage.y = viewPoint_.y;
			}
			
			var matrix:Matrix = new Matrix();
			matrix.translate(adaptWidth_,0);
			adaptWidth_ += bitmap.width;
			adaptHeight_ = adaptHeight_<bitmap.height?bitmap.height:adaptHeight_ + adaptHeightOffset_;
			if(_imageContainer.width < adaptWidth_ || _imageContainer.height < adaptHeight_){
				//update size of canvas
				var width:uint = _imageContainer.width < adaptWidth_ ? adaptWidth_ : _imageContainer.width;
				var height:uint = _imageContainer.height < adaptHeight_ ? adaptHeight_ : _imageContainer.height;
				var emptyData2:BitmapData = new BitmapData(width, height, true, 0x000000);
				emptyData2.draw(_imageContainer);
				
				removeChild(_imageContainer);		
				_imageContainer = new Bitmap(emptyData2);
				addChild(_imageContainer);
				_imageContainer.x = viewPoint_.x;
				_imageContainer.y = viewPoint_.y;
			}
			
			
			_imageContainer.bitmapData.draw(bitmap, matrix);
			if(_imageContainer.width > viewPoint_.width){
				_imageContainer.scaleX = viewPoint_.width/_imageContainer.width;
			}
			if(_imageContainer.height > viewPoint_.height){
				_imageContainer.scaleY = viewPoint_.height/_imageContainer.height;
			}
			
			
//			// Scale the bitmap to fit the display area
//			if (bitmap.width > IMAGE_VIEWPORT.width || bitmap.height > IMAGE_VIEWPORT.height)
//			{
//				var hRatio:Number = bitmap.width / IMAGE_VIEWPORT.width;
//				var vRatio:Number = bitmap.height / IMAGE_VIEWPORT.height;
//				
//				if (hRatio >= vRatio)
//				{
//					bitmap.width = IMAGE_VIEWPORT.width;
//					bitmap.scaleY = bitmap.scaleX;
//				}
//				else
//				{
//					bitmap.height = IMAGE_VIEWPORT.height;
//					bitmap.scaleX = bitmap.scaleY;
//				}
//			}
//			
//			// Center the bitmap in the display area
//			bitmap.x = (IMAGE_VIEWPORT.width - bitmap.width) / 2;
//			bitmap.y = (IMAGE_VIEWPORT.height - bitmap.height) / 2;
		}
		
		private function cropAndSave(e:Event):void
		{
			var imageData:BitmapData = new BitmapData(adaptWidth_, adaptHeight_, true, 0x000000);
			imageData.draw(_imageContainer);
			
			var encodedImage:ByteArray;
			
			var fileNameRegExp:RegExp = /^(?P<fileName>.*)\..*$/;
			var outputFileName:String = fileNameRegExp.exec(loadFile_.fileList[0].name).fileName + "_crop";
			
//			if (_cropStateView.outputFormat == CropStateView.JPEG)
//			{
//				var jpgEncoder:JPGEncoder = new JPGEncoder(85);
//				encodedImage = jpgEncoder.encode(imageData);
//				outputFileName += ".jpg";
//			}
//			else
//			{
				encodedImage = PNGEncoder.encode(imageData);
				outputFileName += ".png";
//			}
				
			//var be:Base64Encoder = new Base64Encoder();
			//var ba:ByteArray = new ByteArray();
			//ba.writeObject(encodedImage);
			//be.encodeBytes(ba);
			//be.toString()
			
			var saveFile:FileReference = new FileReference();
			saveFile.addEventListener(Event.OPEN, saveBeginHandler);
			saveFile.addEventListener(Event.COMPLETE, saveCompleteHandler);
			saveFile.addEventListener(IOErrorEvent.IO_ERROR, saveIOErrorHandler);
			saveFile.save(encodedImage, outputFileName);
		}
		
		
		private function saveBeginHandler(event:Event):void
		{
			trace("saveBeginHandler");
		}
		
		
		private function saveCompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.OPEN, saveBeginHandler);
			event.target.removeEventListener(Event.COMPLETE, saveCompleteHandler);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, saveIOErrorHandler);
		}
		
		
		private function saveIOErrorHandler(event:IOErrorEvent):void
		{
			event.target.removeEventListener(Event.COMPLETE, saveCompleteHandler);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, saveIOErrorHandler);
			
			trace("Error while trying to save:");
			trace(event);
		}
	}
	
}