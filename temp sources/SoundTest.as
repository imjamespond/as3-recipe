package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundCodec;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	import flash.utils.Endian;
	import flash.utils.Timer;

	public class SoundTest extends Sprite
	{
		private var soundBytes:ByteArray = new ByteArray();
		private const DELAY_LENGTH:int = 4000; 
		private var mic:Microphone = Microphone.getEnhancedMicrophone(); 
		private var timer:Timer = new Timer(DELAY_LENGTH); 
		private var sound:Sound = new Sound(); 
		private var channel:SoundChannel = new SoundChannel(); 
		
		public function SoundTest()
		{
			//mic.setSilenceLevel(0, DELAY_LENGTH); 
			//mic.gain = 100; 
			mic.encodeQuality = 10;
			//mic.codec = SoundCodec.SPEEX;
			mic.rate = 22;
			mic.addEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler); 		
			
			timer.addEventListener(TimerEvent.TIMER, timerHandler); 
			timer.start(); 
		}

		
		private function micSampleDataHandler(event:SampleDataEvent):void 
		{ 
			while(event.data.bytesAvailable) 
			{ 
				var sample:Number = event.data.readFloat(); 
				soundBytes.writeFloat(sample); 
				//floatsToSignedShorts(sample,soundBytes); 
			} 
		} 

		private function timerHandler(event:TimerEvent):void 
		{ 
			
			mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler); 
			timer.stop(); 
			
			soundBytes.position = 0; 
			trace( "soundBytes.length:"+soundBytes.length); 
			soundBytes.compress();
			trace( "soundBytes.compressed:"+soundBytes.length); 
			soundBytes.uncompress();
			//sound.addEventListener(SampleDataEvent.SAMPLE_DATA, playbackSampleHandler); 
			//channel.addEventListener( Event.SOUND_COMPLETE, playbackComplete ); 
			//channel = sound.play(); 
			playBytes(soundBytes, 1, .25, 1);
		} 
		
		private function playbackSampleHandler(event:SampleDataEvent):void 
		{ 
			trace(soundBytes.bytesAvailable); 
			var old:Number = 0;
			//每次采样 4*2 * 8192的长度, thus 4*4 * 4096
			for (var i:int = 0; i < 4096 && soundBytes.bytesAvailable > 0; i++) 
			{
				var sample:Number = soundBytes.readFloat(); 
				
				for(var j:int = 0; j < 2; j++){
					var k:Number = .1 * j * old + (1 - .1 * j)* sample;
					event.data.writeFloat( k ); 
					event.data.writeFloat( k );
				}
				old = sample;
			} 
		} 
		
		private function playbackComplete( event:Event ):void 
		{ 
			trace( "Playback finished."); 
		}
		
		/**
		 * 播放二进制数据 
		 * @param bytes
		 * @return 
		 * 
		 */
		public static function playBytes(samplesData:ByteArray,loop:int = 1,speed:Number = 1.0,multiple:int = 2):SoundChannel
		{
			samplesData.position = 0;
			var position:Number = 0;
			var loopCount:int = 0;
			
			var s:Sound = new Sound();
			s.addEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
			var channel:SoundChannel = s.play();
			return channel;
			
			function sampleDataHandler(event:SampleDataEvent):void
			{
				if ((position + 2048 * speed) * 4 * multiple >= samplesData.length)
				{
					loopCount++;
					if (loopCount < loop)
					{
						position = 0;
					}
					else
					{
						s.removeEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
						channel.dispatchEvent(new Event(Event.SOUND_COMPLETE));
						return;
					}
				}	
				
				for (var i:int = 0 ;i < 2048; i++)
				{
					samplesData.position = int(position) * 4 * multiple;
					
					var left:Number = samplesData.readFloat();
					event.data.writeFloat(left);
					event.data.writeFloat(multiple == 2 ? samplesData.readFloat() : left);
					
					position = position + speed;
				}
			}
		}
		
		/**
		 * Convenience method to convert Sound.extract data or SampleDataEvent data
		 * into linear PCM format used for uncompressed FLV audio.
		 * I.e., converts normalized floats to signed shortints.
		 */
		public static function floatsToSignedShorts(n:Number, out:ByteArray ):void
		{
			out.endian = Endian.LITTLE_ENDIAN;
			
			var val:int = n * 32768;
			out.writeShort(val);
		}		
	}
}