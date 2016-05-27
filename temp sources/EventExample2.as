package {
	import flash.display.Sprite;
	import flash.events.*;
	
	public class EventExample2 extends Sprite {
		public function EventExample2():void {
			var parentSprite:Sprite = createSprite("parentSprite",200);
			var childSprite:Sprite = createSprite("childSprite",100);
			var childOfChildSprite:Sprite = createSprite("childOfChildSprite",50);
			
			trace(":: Adding to Stage ::");
			this.addChild(parentSprite);
			trace(":: Adding to Stage ::");
			parentSprite.addChild(childSprite);
			trace(":: Adding to Stage ::");
			childSprite.addChild(childOfChildSprite);
		}
		private function createSprite(name:String,size:uint):Sprite {
			trace(":: Creating Sprite ::");
			var newSprite:Sprite = new Sprite();
			newSprite.name = name;
			newSprite.graphics.beginFill(0xFFFFFF * Math.random(),1);
			newSprite.graphics.drawRect(0,0,size,size);
			newSprite.graphics.endFill();
			newSprite.addEventListener(Event.ADDED, spriteAdded);
			newSprite.addEventListener(Event.ADDED_TO_STAGE, spriteAddedToStage);
			newSprite.addEventListener(Event.REMOVED, spriteRemoved);
			newSprite.addEventListener(Event.REMOVED_FROM_STAGE, spriteRemovedFromStage);
			newSprite.addEventListener(MouseEvent.CLICK, remove);
			return newSprite;
		}
		private function remove(event:Event) {
			if(event.target == event.currentTarget) {
				trace(":: Removing Clicked Sprite ::");
				var target:Sprite = Sprite(event.target);
				target.parent.removeChild(target);
			}
		}
		private function spriteRemovedFromStage(event:Event):void {
			trace("REMOVED_FROM_STAGE: " + event.target.name + " : " + event.currentTarget.name);
		}
		private function spriteRemoved(event:Event):void {
			trace("REMOVED: " + event.target.name + " from " + event.currentTarget.name);
		}
		private function spriteAddedToStage(event:Event):void {
			trace("ADDED_TO_STAGE: " + event.target.name + " : " + event.currentTarget.name);
		}
		private function spriteAdded(event:Event):void {
			trace("ADDED: " + event.target.name + " within " + event.currentTarget.name);
		}
	}
}

