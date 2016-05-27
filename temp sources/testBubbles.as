

package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class testBubbles extends Sprite {
		
		public function testBubbles() {
			var square_0:Square = new Square(300, 0x336633);
			addChild(square_0);
			
			var square_1:Square = new Square(250, 0x669966);
			square_0.addChild(square_1);
			
			var square_2:Square = new Square(200, 0x66CC66);
			square_1.addChild(square_2);
			
			var square_3:Square = new Square(150, 0xAA0000);
			square_3.shouldBubble = false;//不冒泡
			square_2.addChild(square_3);
			
			var square_4:Square = new Square(100, 0x66FF66);
			square_3.addChild(square_4);
			
			var square_5:Square = new Square(50, 0xCC0000);
			square_5.shouldBubble = false;// 不冒泡哦
			square_4.addChild(square_5);
			
			this.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:Event):void {
			trace(">> stage: " + e.type + " event from " + e.target.name + " called on " + this.name);
			trace(">> --------------------------------------------");
		}
	}
}

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

class Square extends Sprite {
	private var sideLen:int;
	private var color:Number;
	public var shouldBubble:Boolean = true;
	
	public function Square(sideLen:int, color:Number) {
		this.sideLen = sideLen;
		this.color = color;
		init();
		draw();
	}
	
	private function init():void {
		buttonMode = true;
		this.addEventListener(MouseEvent.CLICK, firstClickHandler);
		this.addEventListener(MouseEvent.CLICK, secondClickHandler);
		this.addEventListener(MouseEvent.CLICK, thirdClickHandler);
	}
	
	private function draw():void {
		this.graphics.beginFill(color);
		this.graphics.drawRect(0, 0, sideLen, sideLen);
	}
	
	private function firstClickHandler(e:Event):void {
		trace(">> 1e: " + e.type + " event from " + e.target.name + " called on " + this.name);
		if(!shouldBubble) {
			e.stopPropagation();//防止对事件流中所有后续节点中的事件侦听器进行处理。 
		}
	}
	
	private function secondClickHandler(e:Event):void {
		trace(">> 2e: " + e.type + " event from " + e.target.name + " called on " + this.name);
		if(!shouldBubble) {
			e.stopImmediatePropagation();//防止对事件流中!!!!当前节点中(thirdHandle不执行了)!!!!!和所有后续节点中的事件侦听器进行处理。 
			trace(">> --------------------------------------------");
		}
	}
	
	private function thirdClickHandler(e:Event):void {
		trace(">> 3e: " + e.type + " event from " + e.target.name + " called on " + this.name);
	}
}