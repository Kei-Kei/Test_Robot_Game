/*-------------------------------------------------------------------------------------------------
エフェクトパーツ、パーティクル
-------------------------------------------------------------------------------------------------*/
package BattleSet.Effects{
	import flash.display.Sprite;
	
	public class EfParticle extends Sprite{
		private var Particle_Num:int;
		private var Particle_Size:Number;
		private var Type:int;
		private var mc_Particle:Array = new Array();
		//パーティクル到達点
		private var T_X:Array = new Array();
		private var T_Y:Array = new Array();
		
		private var Radius:int;
		private var Time:int;
		private var MaxTime:int;
		private var Per:Number;
		
		public function EfParticle( type:int , max:int , radius:int , p_num:int , p_size:Number ){
			Type = type;
			
			Particle_Num = p_num;
			Particle_Size = p_size;
			Radius = radius;
			MaxTime = max;
			
			//爆発終了時間から展開速度を逆算
			Per = 1 - Math.pow( 10 , Math.log(0.05) / MaxTime );
		}
		
		public function Init(){
			var i:int;
			for(i=0 ; i<Particle_Num ; i++){
				switch( Type ){
					case 1:	mc_Particle[i] = new Explode_Core01();	break;
					case 2:	mc_Particle[i] = new Explode_Core02();	break;
					case 3:	mc_Particle[i] = new Explode_Core03();	break;
					case 4:	mc_Particle[i] = new Explode_Core04();	break;
					case 5:	mc_Particle[i] = new Explode_Core05();	break;
				}
				this.addChild( mc_Particle[i] );
				mc_Particle[i].x = 0;
				mc_Particle[i].y = 0;
				mc_Particle[i].scaleX = Particle_Size;
				mc_Particle[i].scaleY = Particle_Size;
				mc_Particle[i].alpha = 0.8;
				mc_Particle[i].rotation = Math.random()*360;
				T_X[i] = int(Math.random()*Radius*2)-Radius;
				T_Y[i] = int(Math.random()*Radius*2)-Radius;
			}
			
			Time = 0;
		}
		
		public function moveExplode():Boolean{
			if( Time <= MaxTime ){
				for(i=0 ; i<Particle_Num ; i++){
					mc_Particle[i].x += (T_X[i] - mc_Particle[i].x) * Per;
					mc_Particle[i].y += (T_Y[i] - mc_Particle[i].y) * Per;
					mc_Particle[i].alpha -= 0.8/MaxTime;
				}
				
				if( Time > MaxTime ){
					removeExplode();
					return false;
				}
				Time++;
				return true;
			}
			return false;
		}
		
		public function removeExplode(){
			for(i=0 ; i<Particle_Num ; i++){
				this.removeChildAt( 0 );
			}
		}
	}
}