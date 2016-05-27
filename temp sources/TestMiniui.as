package testas{
	import flash.display.*;
	import flash.events.*;
	import sliz.miniui.*;
	import sliz.miniui.layouts.*;
	import sliz.utils.*;
	
	/**
	 * ...
	 * @author sliz
	 */
	public class TestMiniui extends Sprite {
		private var p:Panel;
		
		public function TestMiniui(){
			p = new Panel(this, 100, 100);
			p.add(new Button("1"));
			p.add(new Button("2"));
			p.add(new Button("3"));
			p.add(new Button("4"));
			p.setLayout(new  BoxLayout(p,0,5));
			p.doLayout();
			new Button("click me", 10, 10, this, dolayout);
			UIUtils.changeStage(stage);
			new Checkbox("fds", 300, 10, this);
			new Input("fds", "i", this, null, 300, 30);
			new Label("fds", this, 300, 50);
			new LabelInput("fds", "i", this, 300, 70);
			new Link("fds", "", 300, 90, this);
			new Menu(["fds"], 300, 110, 100, this);
			new Radio("fds", 300, 130, this);
			new RadioGroup([]);
			new RichTextField("fds", this, 300, 150);
			new ScrollBar(300, 170, this);
			new TabPanel(["dfs", "dsf"], 300, 190, this);
			new TextList(["fsd"], 300, 210, 100, this);
			new ToggleButton("fds", 300, 230, this);
			new Silder(300, 250, this);
			var w:Window = new Window(this, 300, 270);
			w.setWH(100, 100);
		}
		
		private function dolayout(e:Event):void {
			var bl:BoxLayout = BoxLayout(p.getLayout());
			if (bl.axis==0) {
				bl.axis = 1;
			}else {
				bl.axis = 0;
			}
			p.doLayout();
		}
	}
}
