/*-------------------------------------------------------------------------------------------------
エフェクトパーツ、拡大する図形
-------------------------------------------------------------------------------------------------*/
package BattleSet.Effects{
	import flash.display.Sprite;
	
	public class EfPrimitive extends Sprite{
		private var mc_Ring:Sprite;
		
		//爆発に関するパラメーター
		private var Time:int;
		private var MaxTime:int;
		private var Size:Number;
		private var Per2:Number;
		
		//コンストラクタ
		public function EfPrimitive( type:int , size:Number , max:int ){
			//MCの初期化
			switch( type ){
				case 1:	mc_Ring = new Explode_Core01();	break;
				case 2:	mc_Ring = new Explode_Core02();	break;
				case 3:	mc_Ring = new Explode_Core03();	break;
				case 4:	mc_Ring = new Explode_Core04();	break;
				case 5:	mc_Ring = new Explode_Core05();	break;
				case 6:	mc_Ring = new Explode_Core06();	break;
			}
			this.addChild(mc_Ring);
			mc_Ring.visible = false;
			
			Size = size;
			
			MaxTime = max;
			
			//爆発終了時間から展開速度を逆算
			Per2 = 1 - Math.pow( 10 , Math.log(0.05) / MaxTime );
		}
		//初期化
		public function Init(){
			mc_Ring.scaleX = 0;
			mc_Ring.scaleY = 0;
			mc_Ring.alpha = 1.0;
			mc_Ring.visible = true;
			
			Time = 0;
		}
		//爆発の展開
		public function moveExplode():Boolean{
			if( Time <= MaxTime ){
				mc_Ring.scaleX += ( Size - mc_Ring.scaleX ) * Per2;
				mc_Ring.scaleY += ( Size - mc_Ring.scaleY ) * Per2;
				mc_Ring.alpha -= 1.0/MaxTime;
				
				if( Time > MaxTime ){
					removeExplode();
					return false;
				}
				Time++;
				return true;
			}
			return false;
		}
		//爆発の削除
		public function removeExplode(){
			mc_Ring.visible = false;
		}
	}
}