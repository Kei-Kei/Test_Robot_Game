package BattleSet.Explodes{
	import flash.display.Sprite;
	import BattleSet.Effects.*;
	import flash.media.*;

	public class Explode02 extends Sprite{
		private var Particle_Num:int = 4;
		public var mc_Particle:Array = new Array();
		
		public var Pos_X,Pos_Y:int;
		private var Radius:int = 15;
		public var Time:int = 0;
		public var MaxTime:int = 15;
		private var Per:Number;
		
		public function Explode02(){		
			//爆発終了時間から展開速度を逆算
			Per = 1 - Math.pow( 10 , Math.log(0.05) / MaxTime );
		}
		
		public function Init( pos_x:int , pos_y:int ){
			var i:int;
			for(i=0 ; i<Particle_Num ; i++){
				mc_Particle[i] = new Explode_Core01();
				this.addChild( mc_Particle[i] );
				mc_Particle[i].x = 0;
				mc_Particle[i].y = 0;
				mc_Particle[i].t_x = mc_Particle[i].x + int(Math.random()*Radius*2)-Radius;
				mc_Particle[i].t_y = mc_Particle[i].y + int(Math.random()*Radius*2)-Radius;
				mc_Particle[i].alpha = 0.8;
				mc_Particle[i].rotation = Math.random()*360;
			}
			
			Pos_X = pos_x;
			Pos_Y = pos_y;
			
			Time = 0;
		}
		
		public function moveExplode():Boolean{
			if( Time <= MaxTime ){
				for(i=0 ; i<Particle_Num ; i++){
					mc_Particle[i].x += (mc_Particle[i].t_x - mc_Particle[i].x) * Per;
					mc_Particle[i].y += (mc_Particle[i].t_y - mc_Particle[i].y) * Per;
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
				this.removeChild( mc_Particle[i] );
			}
		}
	}
}