package com.codechiev.car
{
    import __AS3__.vec.*;
    import away3d.core.base.*;
    import away3d.entities.*;

    public class LodProcessor extends Object
    {

        public function LodProcessor()
        {
            return;
        }// end function

        public static function run(param1:Object3DTree, param2:Object3DTree) : Vector.<LodSubGeometry>
        {
            var _loc_5:String = null;
            var _loc_3:* = new Vector.<LodSubGeometry>;
            var _loc_4:* = param2.getAllPaths();
            for each (_loc_5 in _loc_4)
            {
                
                if (param2.getChildFromPath(_loc_5) is Mesh && param1.getChildFromPath(_loc_5) is Mesh)
                {
                    _handleMesh(param1.getChildFromPath(_loc_5) as Mesh, param2.getChildFromPath(_loc_5) as Mesh, _loc_3);
                }
            }
            return _loc_3;
        }// end function

        private static function _handleMesh(param1:Mesh, param2:Mesh, param3:Vector.<LodSubGeometry>) : void
        {
            var _loc_6:SubMesh = null;
            var _loc_7:LodSubGeometry = null;
            var _loc_4:* = param1.subMeshes;
            var _loc_5:* = param2.subMeshes;
            var _loc_8:int = 0;
            while (_loc_8 < _loc_4.length)
            {
                
                _loc_6 = _loc_4[_loc_8];
                _loc_7 = new LodSubGeometry();
                _loc_7.addLevel(_loc_6.subGeometry);
                _loc_7.addLevel(_loc_5[_loc_8].subGeometry);
                param3.push(_loc_7);
                _loc_6.subGeometry = _loc_7;
                _loc_8++;
            }
            return;
        }// end function

    }
}
