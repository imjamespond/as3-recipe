package testas
{	
	import flash.display.Sprite;	
	
	public class CardTest extends Sprite
		
	{		
		private const CARDPATTERN:Array = [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3];// 花样
		
		private const CARDPOINT:Array = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 11, 11, 11, 11, 12, 12, 12, 12, 13, 13, 13, 13];// 点数 1-13
		
		
		private const CARDPATTERN_NAME:Array = ["方块","梅花","红桃","黑桃"];	
		
		
		private var playerCardSequence1:Array = new Array();			
		private var playerCardSequence2:Array = new Array();			
		private var playerCardSequence3:Array = new Array();
		
		//private playerCardSequence:Array = [ 35, 48, 49, 24, 14, 21, 26, 31, 9, 4, 36, 23, 18 ];			
		//private playerCardSequence:Array = [42, 48, 32, 10, 49, 26, 4, 22, 16, 3,41, 27, 18];
		//private const playerCardSequence:Array = [0,4,5,8,12,16,20,24,28,29,30,31,32];//同花顺，铁支
		//private const playerCardSequence:Array = [0,4,8,12, 16,20,24,28, 32,36,40,44, 5];	//N同花顺
		//private const playerCardSequence:Array = [ 12,13,14, 32,33,34,35, 36,37, 48,49,50,51];//N铁支
		//private const playerCardSequence:Array = [ 12,14, 33,34,35, 36,37, 44,45,46, 48,49,50];//N葫芦
		//private const playerCardSequence:Array = [ 0,3, 12,14, 33,34, 36,37, 44,45, 48,49,50];//N对子
		//private const playerCardSequence:Array = [ 0,4,8,12, 20,24,28,32, 40,44, 45, 48,49];//N同花
		private const playerCardSequence:Array = [49,1,5,9,13,17,21,25,24,28,32,36,40];//同花顺,铁支,同花
		
		public function CardTest()		
		{
			cardAIThink();			
		}		
		public function cardAIThink():void {			
					
			//trace(playerCardSequence);			
			cardAI(playerCardSequence);			
			//explain(playerCardSequence3);				
			
			
		}		
		private function cardAI(playerCardSequence:Array):void {		
			
			playerCardSequence.sort(Array.NUMERIC);			
			var straightFlushDiamond:Array = new Array();			
			var straightFlushClub:Array = new Array();			
			var straightFlushHeart:Array = new Array();			
			var straightFlushSpade:Array = new Array();			
			var flushDiamond:Array = new Array();			
			var flushClub:Array = new Array();			
			var flushHeart:Array = new Array();			
			var flushSpade:Array = new Array();			
			var straight:Array = new Array();			
			var fourOfAKind:Array = new Array();//铁支
			var four:Array = new Array();//所有四条
			var threeOfAKind:Array = new Array();//萌芦
			var three:Array = new Array();//所有三条
			var twoOfAKind:Array = new Array();//对子
			var two:Array = new Array();//所有对
			var single:Array = new Array();
			var oolong:Array = new Array();			
			// 检查同花顺
			
			var i_straight:Number = 0;			
			var i_straightFlush:Number = 0;// 所有花色			
			var i_straightFlushDiamond:Number = 0;			
			var i_straightFlushClub:Number = 0;			
			var i_straightFlushHeart:Number = 0;			
			var i_straightFlushSpade:Number = 0;			
			var i_flush:Number = 0;// 记录最大点数的同花			
			var i_flushDimond:Number = 0;// 同花牌张数记录			
			var i_flushClub:Number = 0;// 同上			
			var i_flushHeart:Number = 0;// 同上			
			var i_flushSpade:Number = 0;// 同上			
			var i_four:Number = 0;// 铁支点数			
			var i_three:Number = 0;// 三条点数
			var i_threeOnly:Boolean = false;// 三条
			var i_threeOfAKind:Boolean = false;// 葫芦	
			var i_dualPair:Boolean = false;// 两对
			var i_onePair:Boolean = false;// 一对
			var i_two:Number = 0;// 对子点数					
			var i_oolong:Number = 0;// 乌龙张数
			
			// 倒序检测同花顺		
			for (var i:Number = playerCardSequence.length - 1; i >= 0; --i) {				
				switch (CARDPATTERN[playerCardSequence[i]]) {					
					case 0:							
						if (i_straightFlushDiamond > 0) {							
							if (CARDPOINT[straightFlushDiamond[(i_straightFlushDiamond - 1)%5]] != CARDPOINT[playerCardSequence[i]] + 1) {// 与前一张不为顺序重新计算									
								i_straightFlushDiamond = 0;									
							}
						}
						straightFlushDiamond[i_straightFlushDiamond++%5] = playerCardSequence[i];

						if (i_straightFlushDiamond > 4 && i_straightFlushDiamond < 9 ) {//保证是同花顺又不出相公
							secondCluster(straightFlushDiamond);
						}
						
						//A2345 fix me Other Pattern!!!!
						if( i_straightFlushDiamond > 3){
							trace(playerCardSequence[i]+"_"+CARDPOINT[playerCardSequence[12]]);
							if (CARDPOINT[playerCardSequence[i]] == 1 && CARDPOINT[playerCardSequence[12]] == 13) {//最后（大）一张是A
								straightFlushDiamond[i_straightFlushDiamond++%5] = playerCardSequence[12];
								secondCluster(straightFlushDiamond);
							}
						}
						break;
					case 1:										
						if (i_straightFlushClub > 0) {								
							if (CARDPOINT[straightFlushClub[(i_straightFlushClub - 1)%5]] != CARDPOINT[playerCardSequence[i]] + 1) {// 与前一张不为顺序重新计算									
								i_straightFlushClub = 0;									
							}								
						}							
						straightFlushClub[i_straightFlushClub++] = playerCardSequence[i];					
						if (i_straightFlushClub > 4 && i_straightFlushClub < 9 ) {//保证是同花顺又不出相公
								secondCluster(straightFlushClub);
						}
						break;					
					case 2:								
						if (i_straightFlushHeart > 0) {								
							if (CARDPOINT[straightFlushHeart[(i_straightFlushHeart - 1)%5]] != CARDPOINT[playerCardSequence[i]] + 1) {// 与前一张不为顺序重新计算							
								i_straightFlushHeart = 0;									
							}								
						}							
						straightFlushHeart[i_straightFlushHeart++] = playerCardSequence[i];							
						if (i_straightFlushHeart > 4 && i_straightFlushHeart < 9 ) {//保证是同花顺又不出相公
							secondCluster(straightFlushHeart);
						}					
						break;					
					case 3:				
						if (i_straightFlushSpade > 0) {								
							if (CARDPOINT[straightFlushSpade[(i_straightFlushSpade - 1)%5]] != CARDPOINT[playerCardSequence[i]] + 1) {// 与前一张不为顺序重新计算								
								i_straightFlushSpade = 0;									
							}								
						}							
						straightFlushSpade[i_straightFlushSpade++] = playerCardSequence[i];					
						if (i_straightFlushDiamond > 4 && i_straightFlushDiamond < 9 ) {//保证是同花顺又不出相公
							secondCluster(straightFlushSpade);
						}						
						break;					
				}				
				//顺		
				if (i_straight < 5) {					
					if (i_straight > 0) {// i为倒数第5张			
						if (CARDPOINT[straight[(i_straight - 1) % 5]] != CARDPOINT[playerCardSequence[i]] + 1) {// 前后两张牌点数为顺					
							i_straight = 0;							
						}						
					}					
					straight[i_straight++] = playerCardSequence[i];					
				}				
			}
			if(i_straightFlushDiamond>4||i_straightFlushClub>4||i_straightFlushHeart>4||i_straightFlushSpade>4){
				return;
			}
			
			// 第一次遍确保所有牌型最大化 铁支,同花,葫芦	
			for (var i:Number = 0; i < playerCardSequence.length; ++i) {							
				// 铁支
				if (i < playerCardSequence.length - 3) {// i为倒数第4张				
					if (CARDPOINT[playerCardSequence[i + 1]] == CARDPOINT[playerCardSequence[i]]) {// 前后两张牌点数相同					
						if (CARDPOINT[playerCardSequence[i + 2]] == CARDPOINT[playerCardSequence[i]]) {							
							if (CARDPOINT[playerCardSequence[i + 3]] == CARDPOINT[playerCardSequence[i]]) {								
								fourOfAKind[0] = playerCardSequence[i];								
								fourOfAKind[1] = playerCardSequence[i + 1];								
								fourOfAKind[2] = playerCardSequence[i + 2];								
								fourOfAKind[3] = playerCardSequence[i + 3];							
								i_four = CARDPOINT[playerCardSequence[i]];
								//统计所有四条
								four.push(playerCardSequence[i]);
								four.push(playerCardSequence[i+1]);
								four.push(playerCardSequence[i+2]);
								four.push(playerCardSequence[i+3]);
							}
						}
					}					
				}				
				// 三条				
				if (i < playerCardSequence.length - 2) {// i为倒数第3张				
					if (CARDPOINT[playerCardSequence[i + 1]] == CARDPOINT[playerCardSequence[i]]) {// 前后两张牌点数相同					
						if (CARDPOINT[playerCardSequence[i + 2]] == CARDPOINT[playerCardSequence[i]]) {	
							if(i_four != CARDPOINT[playerCardSequence[i]]){//排除4条
								threeOfAKind[0] = playerCardSequence[i];							
								threeOfAKind[1] = playerCardSequence[i + 1];							
								threeOfAKind[2] = playerCardSequence[i + 2];							
								i_three = CARDPOINT[playerCardSequence[i]];
								//统计所有三条
								three.push(playerCardSequence[i]);
								three.push(playerCardSequence[i+1]);
								three.push(playerCardSequence[i+2]);
							}
						}
					}
				}
				// 最大一对	
				if (i < playerCardSequence.length - 1) {// i为倒数第2张				
					if (CARDPOINT[playerCardSequence[i + 1]] == CARDPOINT[playerCardSequence[i]]) {// 前后两张牌点数相同					
						if(i_four != CARDPOINT[playerCardSequence[i]] && i_three != CARDPOINT[playerCardSequence[i]]){
							twoOfAKind[0] = playerCardSequence[i];
							twoOfAKind[1] = playerCardSequence[i + 1];
							i_two = CARDPOINT[playerCardSequence[i]];
							//统计所有对子
							two.push(playerCardSequence[i]);
							two.push(playerCardSequence[i+1]);
						}
					}					
				}

				if(i_four != CARDPOINT[playerCardSequence[i]] && i_three != CARDPOINT[playerCardSequence[i]] && i_two != CARDPOINT[playerCardSequence[i]]){
					single.push(playerCardSequence[i]);
				}
				
				oolong[i_oolong++ %5] = playerCardSequence[i];	
				
			}
			//trace(four);trace(three);trace(two);trace(single);
			// 第二遍 组牌 铁支 葫芦		
			if (i_four > 0) {// 算入铁支	
				if(single.length>0){
					fourOfAKind[4] = single.shift();
				}else if(two.length>0){
					fourOfAKind[4] = two.shift();
				}else if(three.length>0){
					fourOfAKind[4] = three.shift();
				}
			}

			if (i_three > 0) {
				if(two.length>0){// 算入葫芦
					threeOfAKind[3] = two.shift();
					threeOfAKind[4] = two.shift();
					i_threeOfAKind = true;
				}else if(single.length>0){//算入三条
					threeOfAKind[3] = single.shift();
					threeOfAKind[4] = single.shift();
					i_threeOnly = true;
				}else if(three.length>0){//算入葫芦
					threeOfAKind[3] = three.shift();
					threeOfAKind[4] = three.shift();
					i_threeOfAKind = true;
				}
			}			
			
			if (i_two > 0) {	
				if(two.length>0){// 算入两对
					twoOfAKind[2] = two.shift();
					twoOfAKind[3] = two.shift();
					if(single.length>0){//算入一对
						twoOfAKind[4] = single.shift();
					}
					i_dualPair = true;
				}else if(single.length>0){//算入一对
					twoOfAKind[2] = single.shift();
					twoOfAKind[3] = single.shift();
					twoOfAKind[4] = single.shift();
					i_onePair = true;
				}
			}
			
			// 铁支返回		
			if (i_four > 0) {
				secondCluster(fourOfAKind);	
				return;
			}			
			// 葫芦返回		
			if (i_threeOfAKind) {
				secondCluster(threeOfAKind);
				return;
			}			
			// 同花最大的返回
			//for (var i:Number = 0; i < playerCardSequence.length; ++i) {
			for (var i:Number = playerCardSequence.length - 1; i >= 0; --i) {
				// 同花				
				switch (CARDPATTERN[playerCardSequence[i]]) {					
					case 0:
						if(flushDiamond[4]==undefined){
							flushDiamond[4] = playerCardSequence[i];//最后一张最大
						}else{
							flushDiamond[i_flushDimond++ % 4] = playerCardSequence[i];
						}
						if(i_flushDimond>3 && i_flushDimond<8){
							secondCluster(flushDiamond);
						}
						break;					
					case 1:	
						if(flushClub[4]==undefined){
							flushClub[4] = playerCardSequence[i];
						}else{
							flushClub[i_flushClub++ % 4] = playerCardSequence[i];
						}
						if(i_flushClub>3 && i_flushClub<8){
							secondCluster(flushDiamond);
						}
						break;					
					case 2:
						if(flushHeart[4]==undefined){
							flushHeart[4] = playerCardSequence[i];
						}else{
							flushHeart[i_flushHeart++ % 4] = playerCardSequence[i];	
						}
						if(i_flushHeart>3 && i_flushHeart<8){
							secondCluster(flushDiamond);
						}
						break;					
					case 3:
						if(flushSpade[4]==undefined){
							flushSpade[4] = playerCardSequence[i];
						}else{
							flushSpade[i_flushSpade++ % 4] = playerCardSequence[i];	
						}
						if(i_flushSpade>3 && i_flushSpade<8){
							secondCluster(flushDiamond);
						}
						break;					
				}
			}
			if(i_flushDimond>4||i_flushClub>4||i_flushHeart>4||i_flushSpade>4){
				return;
			}			
			// 顺返回		
			if (i_straight > 4) {
				secondCluster(straight);
				return ;
			}			
	
			// 三条返回			
			if (i_threeOnly) {				
				secondCluster(threeOfAKind);
				return;
			}
			// 两对返回
			if (i_dualPair) {				
				secondCluster(twoOfAKind);
				return;
			}			
			// 一对返回	
			if (i_two) {				
				secondCluster(twoOfAKind);
				return;
			}			
			secondCluster(oolong);		
		}		

		
		private function cardAIMax(playerCardSequence:Array):Array
		{
			
			playerCardSequence.sort(Array.NUMERIC);			
			var straightFlushDiamond:Array = new Array();			
			var straightFlushClub:Array = new Array();			
			var straightFlushHeart:Array = new Array();			
			var straightFlushSpade:Array = new Array();			
			var flushDiamond:Array = new Array();			
			var flushClub:Array = new Array();			
			var flushHeart:Array = new Array();			
			var flushSpade:Array = new Array();			
			var straight:Array = new Array();			
			var fourOfAKind:Array = new Array();//铁支
			var four:Array = new Array();//所有四条
			var threeOfAKind:Array = new Array();//萌芦
			var three:Array = new Array();//所有三条
			var twoOfAKind:Array = new Array();//对子
			var two:Array = new Array();//所有对
			var single:Array = new Array();
			var oolong:Array = new Array();			
			// 检查同花顺
			
			var i_straight:Number = 0;			
			var i_straightFlush:Number = 0;// 所有花色			
			var i_straightFlushDiamond:Number = 0;			
			var i_straightFlushClub:Number = 0;			
			var i_straightFlushHeart:Number = 0;			
			var i_straightFlushSpade:Number = 0;			
			var i_flush:Number = 0;// 记录最大点数的同花			
			var i_flushDimond:Number = 0;// 同花牌张数记录			
			var i_flushClub:Number = 0;// 同上			
			var i_flushHeart:Number = 0;// 同上			
			var i_flushSpade:Number = 0;// 同上			
			var i_four:Number = 0;// 铁支点数			
			var i_three:Number = 0;// 三条点数
			var i_threeOnly:Boolean = false;// 三条
			var i_threeOfAKind:Boolean = false;// 葫芦	
			var i_dualPair:Boolean = false;// 两对
			var i_onePair:Boolean = false;// 一对
			var i_two:Number = 0;// 对子点数					
			var i_oolong:Number = 0;// 乌龙张数
			
			// 倒序检测同花顺		
			for (var i:Number = playerCardSequence.length - 1; i >= 0; --i) {				
				switch (CARDPATTERN[playerCardSequence[i]]) {					
					case 0:							
						if (i_straightFlushDiamond > 0) {								
							if (CARDPOINT[straightFlushDiamond[(i_straightFlushDiamond - 1)%5]] != CARDPOINT[playerCardSequence[i]] + 1) {// 与前一张不为顺序重新计算									
								i_straightFlushDiamond = 0;									
							}
						}
						straightFlushDiamond[i_straightFlushDiamond++%5] = playerCardSequence[i];
						if(i_straightFlushDiamond>5){
							return straightFlushDiamond;
						}
						break;					
					case 1:										
						if (i_straightFlushClub > 0) {								
							if (CARDPOINT[straightFlushClub[(i_straightFlushClub - 1)%5]] != CARDPOINT[playerCardSequence[i]] + 1) {// 与前一张不为顺序重新计算									
								i_straightFlushClub = 0;									
							}								
						}							
						straightFlushClub[i_straightFlushClub++] = playerCardSequence[i];
						if(i_straightFlushDiamond>5){
							return straightFlushClub;
						}
						break;					
					case 2:								
						if (i_straightFlushHeart > 0) {								
							if (CARDPOINT[straightFlushHeart[(i_straightFlushHeart - 1)%5]] != CARDPOINT[playerCardSequence[i]] + 1) {// 与前一张不为顺序重新计算							
								i_straightFlushHeart = 0;									
							}								
						}							
						straightFlushHeart[i_straightFlushHeart++] = playerCardSequence[i];	
						if(i_straightFlushDiamond>5){
							return straightFlushHeart;
						}
						break;					
					case 3:				
						if (i_straightFlushSpade > 0) {								
							if (CARDPOINT[straightFlushSpade[(i_straightFlushSpade - 1)%5]] != CARDPOINT[playerCardSequence[i]] + 1) {// 与前一张不为顺序重新计算								
								i_straightFlushSpade = 0;									
							}								
						}							
						straightFlushSpade[i_straightFlushSpade++] = playerCardSequence[i];	
						if(i_straightFlushDiamond>5){
							return straightFlushSpade;
						}
						break;					
				}				
				//顺		
				if (i_straight < 5) {					
					if (i_straight > 0) {// i为倒数第5张			
						if (CARDPOINT[straight[(i_straight - 1) % 5]] != CARDPOINT[playerCardSequence[i]] + 1) {// 前后两张牌点数为顺					
							i_straight = 0;							
						}						
					}					
					straight[i_straight++] = playerCardSequence[i];					
				}				
			}
			
			// 第一次遍确保所有牌型最大化 铁支,同花,葫芦	
			for (var i:Number = 0; i < playerCardSequence.length; ++i) {							
				// 铁支
				if (i < playerCardSequence.length - 3) {// i为倒数第4张				
					if (CARDPOINT[playerCardSequence[i + 1]] == CARDPOINT[playerCardSequence[i]]) {// 前后两张牌点数相同					
						if (CARDPOINT[playerCardSequence[i + 2]] == CARDPOINT[playerCardSequence[i]]) {							
							if (CARDPOINT[playerCardSequence[i + 3]] == CARDPOINT[playerCardSequence[i]]) {								
								fourOfAKind[0] = playerCardSequence[i];								
								fourOfAKind[1] = playerCardSequence[i + 1];								
								fourOfAKind[2] = playerCardSequence[i + 2];								
								fourOfAKind[3] = playerCardSequence[i + 3];							
								i_four = CARDPOINT[playerCardSequence[i]];
								//统计所有四条
								four.push(playerCardSequence[i]);
								four.push(playerCardSequence[i+1]);
								four.push(playerCardSequence[i+2]);
								four.push(playerCardSequence[i+3]);
							}
						}
					}					
				}				
				// 三条				
				if (i < playerCardSequence.length - 2) {// i为倒数第3张				
					if (CARDPOINT[playerCardSequence[i + 1]] == CARDPOINT[playerCardSequence[i]]) {// 前后两张牌点数相同					
						if (CARDPOINT[playerCardSequence[i + 2]] == CARDPOINT[playerCardSequence[i]]) {	
							if(i_four != CARDPOINT[playerCardSequence[i]]){//排除4条
								threeOfAKind[0] = playerCardSequence[i];							
								threeOfAKind[1] = playerCardSequence[i + 1];							
								threeOfAKind[2] = playerCardSequence[i + 2];							
								i_three = CARDPOINT[playerCardSequence[i]];
								//统计所有三条
								three.push(playerCardSequence[i]);
								three.push(playerCardSequence[i+1]);
								three.push(playerCardSequence[i+2]);
							}
						}
					}
				}
				// 最大一对	
				if (i < playerCardSequence.length - 1) {// i为倒数第2张				
					if (CARDPOINT[playerCardSequence[i + 1]] == CARDPOINT[playerCardSequence[i]]) {// 前后两张牌点数相同					
						if(i_four != CARDPOINT[playerCardSequence[i]] && i_three != CARDPOINT[playerCardSequence[i]]){
							twoOfAKind[0] = playerCardSequence[i];
							twoOfAKind[1] = playerCardSequence[i + 1];
							i_two = CARDPOINT[playerCardSequence[i]];
							//统计所有对子
							two.push(playerCardSequence[i]);
							two.push(playerCardSequence[i+1]);
						}
					}					
				}
				
				if(i_four != CARDPOINT[playerCardSequence[i]] && i_three != CARDPOINT[playerCardSequence[i]] && i_two != CARDPOINT[playerCardSequence[i]]){
					single.push(playerCardSequence[i]);
				}
				
				oolong[i_oolong++ %5] = playerCardSequence[i];	
				
			}
			//trace(four);trace(three);trace(two);trace(single);
			// 第二遍 组牌 铁支 葫芦		
			if (i_four > 0) {// 算入铁支	
				if(single.length>0){
					fourOfAKind[4] = single.shift();
				}else if(two.length>0){
					fourOfAKind[4] = two.shift();
				}else if(three.length>0){
					fourOfAKind[4] = three.shift();
				}
			}
			
			if (i_three > 0) {
				if(two.length>0){// 算入葫芦
					threeOfAKind[3] = two.shift();
					threeOfAKind[4] = two.shift();
					i_threeOfAKind = true;
				}else if(single.length>0){//算入三条
					threeOfAKind[3] = single.shift();
					threeOfAKind[4] = single.shift();
					i_threeOnly = true;
				}else if(three.length>0){//算入葫芦
					threeOfAKind[3] = three.shift();
					threeOfAKind[4] = three.shift();
					i_threeOfAKind = true;
				}
			}			
			
			if (i_two > 0) {	
				if(two.length>0){// 算入两对
					twoOfAKind[2] = two.shift();
					twoOfAKind[3] = two.shift();
					if(single.length>0){//算入一对
						twoOfAKind[4] = single.shift();
					}
					i_dualPair = true;
				}else if(single.length>0){//算入一对
					twoOfAKind[2] = single.shift();
					twoOfAKind[3] = single.shift();
					twoOfAKind[4] = single.shift();
					i_onePair = true;
				}
			}
			
			// 铁支返回		
			if (i_four > 0) {
				return fourOfAKind;	
			}			
			// 葫芦返回		
			if (i_threeOfAKind) {
				return threeOfAKind;
			}			
			// 同花最大的返回
			for (var i:Number = 0; i < playerCardSequence.length; ++i) {
				// 同花				
				switch (CARDPATTERN[playerCardSequence[i]]) {					
					case 0:
						if(flushDiamond[4]==undefined){
							flushDiamond[4] = playerCardSequence[i];//最后一张最大
						}else{
							flushDiamond[i_flushDimond++ % 4] = playerCardSequence[i];
						}
						break;					
					case 1:	
						if(flushClub[4]==undefined){
							flushClub[4] = playerCardSequence[i];
						}else{
							flushClub[i_flushClub++ % 4] = playerCardSequence[i];
						}
						break;					
					case 2:
						if(flushHeart[4]==undefined){
							flushHeart[4] = playerCardSequence[i];
						}else{
							flushHeart[i_flushHeart++ % 4] = playerCardSequence[i];	
						}
						break;					
					case 3:
						if(flushSpade[4]==undefined){
							flushSpade[4] = playerCardSequence[i];
						}else{
							flushSpade[i_flushSpade++ % 4] = playerCardSequence[i];	
						}
						break;					
				}
			}
			if(i_flushDimond>3 ){
				return flushDiamond;
			}
			if(i_flushClub>3 ){
				return flushClub;
			}			
			if(i_flushHeart>3 ){
				return flushHeart;
			}			
			if(i_flushSpade>3 ){
				return flushSpade;
			}
			
			// 顺返回		
			if (i_straight > 4) {
				return straight;
			}			
			
			// 三条返回			
			if (i_threeOnly) {				
				return threeOfAKind;
			}
			// 两对返回
			if (i_dualPair) {				
				return twoOfAKind;
			}			
			// 一对返回	
			if (i_two) {				
				return twoOfAKind;
			}	
			return oolong;
		}		
		
		
		
		
		
		private function secondCluster(card:Array):void{
			
			explain(card);
			var card8:Array = new Array();			
			var eight:Number = 8;			
			for (var i:Number = 0; i < playerCardSequence.length; ++i) {				
				if (eight > 0) {					
					if (card.indexOf(playerCardSequence[i]) < 0) {// 该牌不在上墩牌中
						
						card8[--eight] = playerCardSequence[i];						
					}					
				}				
			}
			
			playerCardSequence2 = cardAIMax(card8);
			explain(playerCardSequence2);			
			var three:Number = 3;			
			for (var i:Number = 0; i < card8.length; ++i) {				
				if (three > 0) {					
					if (playerCardSequence2.indexOf( card8[i]) < 0) {// 该牌不在上墩牌中
						
						playerCardSequence1[--three] = card8[i];						
					}					
				}				
			}			
			explain(playerCardSequence1);
			trace("second cluster end!!!!!!!!!!!!!!");
		}
		
		private function explain(card:Array):void{			
			var str:String = "";			
			for(var i:Number=0;i<card.length;++i){				
				str += CARDPATTERN_NAME[CARDPATTERN[card[i]]] + (CARDPOINT[card[i]]+1) + ",";				
			}			
			trace(str);			
		}		
	}	
}