package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextField;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.Stardust;
	//import net.hires.debug.Stats;
	
	public class StardustExample extends MovieClip {
		
		//protected var stats:Stats;
		protected var container:Sprite;
		protected var emitter:Emitter;
		
		public function StardustExample() {
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			//stats = new Stats();
			//stats.x = 2;
			//stats.y = 62;
			//addChildAt(stats, 1);
			container = new Sprite();
			addChild(container);
			buildExtraObjects();
			buildParticleSystem();
			
			addEventListener(Event.ENTER_FRAME, mainLoop);
		}
		
		protected function buildExtraObjects():void {
			//abstract method
		}
		
		protected function buildParticleSystem():void {
			//abstract method
		}
		
		protected function mainLoop(e:Event):void {
			//abstract method
		}
		
		private function init(e:Event):void {
			//set stage scale mode
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//set root scroll rect
			root.scrollRect = new Rectangle(0, 0, 1024, 768);
			
			//set logo link
			/*var logo:Sprite = this["logo_mc"] as Sprite;
			logo.buttonMode = true;
			logo.addEventListener(MouseEvent.CLICK, gotoHomepage);
			
			//XML button
			var xml_btn:Sprite = this["xml_btn"] as Sprite;
			xml_btn.addEventListener(MouseEvent.CLICK, toggleXML);
			
			//XML text box
			xmlTextBox = this["xmlTextBox_mc"];
			xmlTextBox.visible = false;
			xmlTextBox["copy_btn"].addEventListener(MouseEvent.CLICK, copyXML);
			xmlText = xmlTextBox["xml_txt"];
			xmlText.wordWrap = false;
			xmlText.border = true;
			xmlText.borderColor = 0xFFFFFF;
			xmlText.selectable = true;*/
		}
		
		private function gotoHomepage(e:Event):void {
			navigateToURL(new URLRequest(Stardust.PROJECT_HOMEPAGE));
		}
		
		protected var xmlText:TextField;
		protected var xmlTextBox:Sprite;
		protected function toggleXML(e:Event):void {
			if (e.target["label"] == "Show XML") {
				e.target["label"] = "Hide XML";
				if (emitter != null) {
					xmlText.text = XMLBuilder.buildXML(emitter).toXMLString();
				}
				xmlTextBox.visible = true;
			} else {
				e.target["label"] = "Show XML";
				xmlTextBox.visible = false;
			}
		}
		
		private function copyXML(e:Event):void {
			System.setClipboard(xmlText.text);
		}
	}
}