//class Test
package 
{
    import flash.display.*;
    import flash.events.*;
    import sliz.miniui.*;
    import sliz.miniui.layouts.*;
    import sliz.utils.*;
    
    public class Test extends flash.display.Sprite
    {
        public function Test()
        {
            super();
            Wonderfl.capture(stage);
            this.p = new sliz.miniui.Panel(this, 100, 100);
            this.p.add(new sliz.miniui.Button("1"));
            this.p.add(new sliz.miniui.Button("2"));
            this.p.add(new sliz.miniui.Button("3"));
            this.p.add(new sliz.miniui.Button("4"));
            this.p.setLayout(new sliz.miniui.layouts.BoxLayout(this.p, 0, 5));
            this.p.doLayout();
            new sliz.miniui.Button("click me", 10, 10, this, this.dolayout);
            sliz.utils.UIUtils.changeStage(stage);
            new sliz.miniui.Checkbox("fds", 300, 10, this);
            new sliz.miniui.Input("fds", "i", this, null, 300, 30);
            new sliz.miniui.Label("fds", this, 300, 50);
            new sliz.miniui.LabelInput("fds", "i", this, 300, 70);
            new sliz.miniui.Link("fds", "", 300, 90, this);
            new sliz.miniui.Menu(["fds"], 300, 110, 100, this);
            new sliz.miniui.Radio("fds", 300, 130, this);
            new sliz.miniui.RadioGroup([]);
            new sliz.miniui.RichTextField("fds", this, 300, 150);
            new sliz.miniui.ScrollBar(300, 170, this);
            new sliz.miniui.TabPanel(["dfs", "dsf"], 300, 190, this);
            new sliz.miniui.TextList(["fsd"], 300, 210, 100, this);
            new sliz.miniui.ToggleButton("fds", 300, 230, this);
            new sliz.miniui.Silder(300, 250, this);
            var loc1:*=new sliz.miniui.Window(this, 300, 270);
            loc1.setWH(100, 100);
            return;
        }

        internal function dolayout(arg1:flash.events.Event):void
        {
            var loc1:*=sliz.miniui.layouts.BoxLayout(this.p.getLayout());
            if (loc1.axis != 0) 
            {
                loc1.axis = 0;
            }
            else 
            {
                loc1.axis = 1;
            }
            this.p.doLayout();
            return;
        }

        internal var p:sliz.miniui.Panel;
    }
}


