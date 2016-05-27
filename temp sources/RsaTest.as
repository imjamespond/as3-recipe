package
{
	import com.hurlant.crypto.rsa.RSAKey;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	public class RsaTest extends Sprite
	{
		public function RsaTest()
		{
			var exp:String = "0x10001";
			var mod:String = "00cf70c160647e1e7812372fafca5dee5e91a1801aea08884e2dd48e634039f1b21dac05667485d07e3622267b2783dec80776abcd4004c1b6053c7362edc6625d2ce1e90f9adb55c0e845b1728d3ca0f1bf859546f7680d50a405b6a491188b57c796a0800b2c5f213e77a7632349247c98e0da304291756a960184a2f2d9071b";
			var pri:String = "428c98ed34b025543dfbc867ac1380628473fc662608c0b9dc0821fa0363d37f61f78aeff897e970642b868ee1f9736256caa289416d853bc0e848d84711eb0206f1ec635c24d2e1dfcc027ee2953f510d3ec821f0620ad56c3bec560592b1d58170eef9c7be45177db1d6807697261368f73368e99f088fe8418b2e70e75929";
			var p:String = "00fba8628b4eb27488202da189192d0bbdd1f65b5b64b7699bd205a79fd99987a1be792bf72c7865f5ddd1e0acae07c2269035975d1edc8ea9a3d5b4182257daf7";
			var q:String = "00d3050e1ae54e9387d1df6a7a684f3739985a9f14e778b9883e43cc838e19ecaf114ddca16eabd46064f42fe8d75352caef5901f95f268362e066a1a7192627fd";
			//D mod p-1
			var p1:String = "768ed69620a62c06317aadde63f0f7d61e837c78ab13497ab2501daf4e19696f86c79931e24e7a6281752deecc3235826b7003f647e2ca871afb43d416e1e2f3";
			//D mod q-1
			var q1:String = "758dc25ecf5167b469013a12f8daf05be078d35854de9714c40307025e7e28b11a45b2dc278807a6af76acdddc5e69a7ed903b1e4d9869e702358a6649074d8d";
			var co:String = "551f9b675d2adf7b592f8cd41c80266611c8501a5e275cd6a6fac70953f292f35c0248f8be31d009f3571faac92deb37beb77c0a4a2218dca478e4463f52b59e";
			//1/q mod p
			var foobar:String = "01234567890abcdefghijklmnopqrstuvwxyz";
			var currentResult:String;
			trace(foobar);
			
			var encryptedData:ByteArray; 

			//var data:ByteArray = Hex.toArray(foobar);//hex string
			//var data:ByteArray = Hex.toArray(Hex.fromArray(Base64.decodeToByteArray(foobar)));
			var data:ByteArray = Hex.toArray(Hex.fromString(foobar));			
			var rsa:RSAKey = RSAKey.parsePublicKey(mod, exp);
			var dst:ByteArray = new ByteArray;
			rsa.encrypt(data, dst, data.length);
			currentResult = Hex.fromArray(dst);		
			trace("currentResult:", currentResult);
			
			//encryptedData = dst;
			encryptedData = Hex.toArray("81b429d0e074dd6fd875ee7c20d1f16a9882248ce15859a693abdb49a7cf2dced6aef5c1d5acb839ead6ac518ad9fb3a3df4b80ebd94c7292cf8781d6927a85842c6929723605ba30288959bbd9d398cd29f9ea06ebb20190fff54cedbe6abc41b1089a00739ded6aac611009db31c0c3a604cc426820fb84b0e867b502f0afe");

			var priRsa:RSAKey = RSAKey.parsePrivateKey(mod, exp, pri, p, q, p1, q1, co);
			var decryptedData:ByteArray = new ByteArray;
			priRsa.decrypt(encryptedData, decryptedData, encryptedData.length);
			currentResult = Hex.toString(Hex.fromArray(decryptedData));
			trace("currentResult:", currentResult);
			
			
		}
	}
}