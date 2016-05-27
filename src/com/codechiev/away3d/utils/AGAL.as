package com.codechiev.away3d.utils
{

    public class AGAL extends Object
    {

        public function AGAL()
        {
            return;
        }// end function

        public static function dp3(param1:String, param2:String, param3:String) : String
        {
            return "dp3 " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function dp4(param1:String, param2:String, param3:String) : String
        {
            return "dp4 " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function sat(param1:String, param2:String) : String
        {
            return "sat " + param1 + ", " + param2 + "\n";
        }// end function

        public static function normalize(param1:String, param2:String) : String
        {
            return "nrm " + param1 + ", " + param2 + "\n";
        }// end function

        public static function mul(param1:String, param2:String, param3:String) : String
        {
            return "mul " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function div(param1:String, param2:String, param3:String) : String
        {
            return "div " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function add(param1:String, param2:String, param3:String) : String
        {
            return "add " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function sub(param1:String, param2:String, param3:String) : String
        {
            return "sub " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function cross(param1:String, param2:String, param3:String) : String
        {
            return "crs " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function mov(param1:String, param2:String) : String
        {
            return "mov " + param1 + ", " + param2 + "\n";
        }// end function

        public static function pow(param1:String, param2:String, param3:String) : String
        {
            return "pow " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function sample(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String) : String
        {
            var _loc_7:String = null;
            switch(param5)
            {
                case "trilinear":
                {
                    _loc_7 = "linear,miplinear";
                    break;
                }
                case "bilinear":
                {
                    _loc_7 = "linear";
                    break;
                }
                case "nearestMip":
                {
                    _loc_7 = "nearest,mipnearest";
                    break;
                }
                case "nearestNoMip":
                {
                    _loc_7 = "nearest";
                    break;
                }
                case "centroid":
                {
                    _loc_7 = "centroid";
                    break;
                }
                default:
                {
                    break;
                }
            }
            return "tex " + param1 + ", " + param2 + ", " + param4 + " <" + param3 + "," + _loc_7 + "," + param6 + ">\n";
        }// end function

        public static function m34(param1:String, param2:String, param3:String) : String
        {
            return "m34 " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function m33(param1:String, param2:String, param3:String) : String
        {
            return "m33 " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function m44(param1:String, param2:String, param3:String) : String
        {
            return "m44 " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function step(param1:String, param2:String, param3:String) : String
        {
            return "sge " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function lessThan(param1:String, param2:String, param3:String) : String
        {
            return "slt " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function fract(param1:String, param2:String) : String
        {
            return "frc " + param1 + ", " + param2 + "\n";
        }// end function

        public static function rcp(param1:String, param2:String) : String
        {
            return "rcp " + param1 + ", " + param2 + "\n";
        }// end function

        public static function neg(param1:String, param2:String) : String
        {
            return "neg " + param1 + ", " + param2 + "\n";
        }// end function

        public static function abs(param1:String, param2:String) : String
        {
            return "abs " + param1 + ", " + param2 + "\n";
        }// end function

        public static function sqrt(param1:String, param2:String) : String
        {
            return "sqt " + param1 + ", " + param2 + "\n";
        }// end function

        public static function exp(param1:String, param2:String) : String
        {
            return "exp " + param1 + ", " + param2 + "\n";
        }// end function

        public static function greaterOrEqualTo(param1:String, param2:String, param3:String) : String
        {
            return "sge " + param1 + ", " + param2 + ", " + param3 + "\n";
        }// end function

        public static function kill(param1:String) : String
        {
            return "kil " + param1 + "\n";
        }// end function

        public static function sin(param1:String, param2:String) : String
        {
            return "sin " + param1 + ", " + param2 + "\n";
        }// end function

        public static function cos(param1:String, param2:String) : String
        {
            return "cos " + param1 + ", " + param2 + "\n";
        }// end function

    }
}
