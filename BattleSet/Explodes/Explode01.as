package BattleSet.Explodes{
	import flash.display.Sprite;
	import BattleSet.Effects.*;
	
	public class Explode01 extends Sprite{
		public var mc_Core:Sprite;
		public var mc_Ring:Sprite;
		
		//爆発に関するパラメーター
		public var Pos_X,Pos_Y:int;
		public var Time:int = 0;
		private var MaxTime:int = 4;
		private var Per1,Per2:Number;
		
		//コンストラクタ
		public function Explode01(){
			//MCの初期化
			mc_Core = new EfPrimitive( 6 , 1.0 , 4 );
			this.addChild(mc_Core);
			
			mc_Ring = new EfPrimitive( 3 , 0.5 , 4 );
			this.addChild(mc_Ring);
		}
		//初期化
		public function Init( pos_x:int , pos_y:int ){
			
			mc_Core.Init();
			
			mc_Ring.Init();
			mc_Ring.scaleX = 0.4;
			mc_Ring.scaleY = 2.0;
			
			Pos_X = pos_x;
			Pos_Y = pos_y;
			
			Time = 0;
		}
		//爆発の展開
		public function moveExplode():Boolean{
			
			mc_Core.moveExplode();
			mc_Ring.moveExplode();
			
			if( Time > MaxTime ){
				removeExplode();
				return false;
			}
			Time++;
			return true;
		}
		//爆発の削除
		public function removeExplode(){
		}
	}
}