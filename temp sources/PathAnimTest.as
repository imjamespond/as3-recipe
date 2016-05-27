
package
{
	import away3d.animators.PathAnimator;
	import away3d.containers.*;
	import away3d.entities.*;
	import away3d.materials.*;
	import away3d.paths.CubicPath;
	import away3d.primitives.*;
	import away3d.utils.*;
	
	import com.codechiev.away3d.AwayController;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Vector3D;
	
	[SWF(backgroundColor="#000000", frameRate="60", quality="LOW")]
	
	public class PathAnimTest extends Sprite
	{
		//plane texture
		[Embed(source="/../embeds/floor_diffuse.jpg")]
		public static var FloorDiffuse:Class;
	
		//Away3d controll
		private var _away3dCtl:AwayController = new AwayController();
		//
		private var pathanimator:PathAnimator;
		private var _cube:Mesh;
		private var _plane:Mesh;
		private var _progress:Number = 0;
		/**
		 * Constructor
		 */
		public function PathAnimTest()
		{
			_away3dCtl.init(this);
			//_away3dCtl.setupLookAtController();
			_away3dCtl.setupFirstPersonController();
			_cube = new Mesh(new CubeGeometry());
			_plane = new Mesh(new PlaneGeometry(700, 700), new TextureMaterial(Cast.bitmapTexture(FloorDiffuse)));
			//setup the scene
			var aPath:Vector.<Vector3D> = new <Vector3D>[new Vector3D(-100, -100, -200),
				new Vector3D(-100, 0, 0),
				new Vector3D(100, 0, 0),
				new Vector3D(100, 100, -200)];
			var p:CubicPath = new CubicPath(aPath);

			this.pathanimator = new PathAnimator(p, _cube, new Vector3D(0,100,0));
			_away3dCtl.addMeshToViewScene(_cube);
			_away3dCtl.addMeshToViewScene(_plane);
			//_away3dCtl.lookAt(_plane);
			_away3dCtl.addRenderJob(renderJob);
			
		}
		
		public function renderJob():void{
			_progress = (_progress +0.001>1)? 0 : _progress+0.001;
			this.pathanimator.updateProgress(_progress);
			//_plane.rotationY++;
		}
	}
}
