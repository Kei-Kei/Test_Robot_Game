package MiniObj{
	public class WallHit{
		public var Hit:Boolean;
		public var Pos_X:Number;
		public var Pos_Y:Number;
		public function WallHit(){}
		
		public function Set( pos_x:int , pos_y:int , hit:Boolean ){
			Pos_X = pos_x;
			Pos_Y = pos_y;
			Hit = hit;
		}
	}
}