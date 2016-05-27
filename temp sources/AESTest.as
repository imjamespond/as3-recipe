package
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.prng.Random;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.IVMode;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.Hex;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	public class AESTest extends Sprite
	{
		public function AESTest()
		{
			var foobar:String = "01234567890abcdefghijklmnopqrstuvwxyz";
			trace(foobar);
			//var data:ByteArray = Hex.toArray(foobar);//hex string
			//var data:ByteArray = Hex.toArray(Hex.fromArray(Base64.decodeToByteArray(foobar)));
			var data:ByteArray = Hex.toArray(Hex.fromString(foobar));			
			var decryptData:ByteArray = new ByteArray();
			
			var aesKey:String = "hehe1212";
			var key:ByteArray = Hex.toArray(Hex.fromString(aesKey));    
			var pad:IPad = new PKCS5;
			var cipher:ICipher = Crypto.getCipher("aes-256-ofb", key, pad);
			pad.setBlockSize(cipher.getBlockSize());
			var rand:Random = new Random; // we need a lot of random bytes.
			var iv:ByteArray = new ByteArray;
			rand.nextBytes(iv, cipher.getBlockSize());
			if (cipher is IVMode) {
				var ivm:IVMode = cipher as IVMode;
				ivm.IV = iv;
			}
			cipher.encrypt(data);  				
			decryptData.writeBytes(data);
			trace("currentResult:", Hex.fromArray(decryptData));
			cipher.decrypt(decryptData);
			trace("currentResult:", Hex.toString(Hex.fromArray(decryptData)));
		}
	}
}