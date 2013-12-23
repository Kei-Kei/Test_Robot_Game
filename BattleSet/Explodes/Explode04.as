package BattleSet.Explodes{
	import flash.display.Sprite;
	import BattleSet.Effects.*;
	
	public class Explode04 extends Sprite{
		public var mc_Core:Sprite;
		public var mc_Ring:Sprite;
		
		//爆発に関するパラメーター
		public var Pos_X,Pos_Y:int;
		public var Time:int = 0;
		private var MaxTime:int = 12;
		private var Per1,Per2:Number;
		
		//コンストラクタ
		public function Explode04(){
			//MCの初期化
			mc_Core = new Explode_Core05();
			this.addChild(mc_Core);
			mc_Core.visible = false;
			
			mc_Ring = new Explode_Core03();
			this.addChild(mc_Ring);
			mc_Ring.visible = false;
			
			//爆発終了時間から展開速度を逆算
			Per1 = 1 - Math.pow( 10 , Math.log(0.05) / MaxTime );
			Per2 = 1 - Math.pow( 10 , Math.log(0.05) / MaxTime );
		}
		//初期化
		public function Init( pos_x:int , pos_y:int ){
			
			mc_Core.scaleX = 0;
			mc_Core.scaleY = 0;
			mc_Core.rotation = Math.random()*360;
			mc_Core.alpha = 0.9;
			mc_Core.visible = true;
			
			mc_Ring.scaleX = 0;
			mc_Ring.scaleY = 0;
			mc_Ring.alpha = 0.6;
			mc_Ring.visible = true;
			
			Pos_X = pos_x;
			Pos_Y = pos_y;
			
			Time = 0;
		}
		//爆発の展開
		public function moveExplode():Boolean{
			
			mc_Core.scaleX += ( 1 - mc_Core.scaleX ) * Per1;
			mc_Core.scaleY += ( 1 - mc_Core.scaleY ) * Per1;
			mc_Core.alpha -= 0.9/MaxTime;
			
			mc_Ring.scaleX += ( 1 - mc_Core.scaleX ) * Per2;
			mc_Ring.scaleY += ( 1 - mc_Core.scaleY ) * Per2;
			mc_Ring.alpha -= 0.6/MaxTime;
			
			if( Time > MaxTime ){
				removeExplode();
				return false;
			}
			Time++;
			return true;
		}
		//爆発の削除
		public function removeExplode(){
			mc_Core.visible = false;
		}
	}
}