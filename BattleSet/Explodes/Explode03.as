package BattleSet.Explodes{
	import flash.display.Sprite;
	import BattleSet.Effects.*;
	
	public class Explode03 extends Sprite{
		public var mc_Core:Sprite;
		public var mc_RingA:Array = new Array();	//表リング
		public var mc_RingB:Array = new Array();	//裏リング
		
		//爆発に関するパラメーター
		public var Pos_X,Pos_Y:int;
		public var Time:int = 0;
		private var MaxTime:int = 30;
		private var RingNum:int = 3;
		
		//コンストラクタ
		public function Explode03(){
			//MCの初期化
			var i:int;
			for( i=0 ; i<RingNum ; i++ ){
				mc_RingB[i] = new EfPrimitive( 4 , 1.0 , 25 );
				this.addChild(mc_RingB[i]);
				mc_RingB[i].visible = false;
			}
			
			mc_Core = new EfParticle( 1 , 15 , 15 , 4 , 1.0);
			this.addChild(mc_Core);
			mc_Core.visible = false;
			
			for( i=0 ; i<RingNum ; i++ ){
				mc_RingA[i] = new EfPrimitive( 4 , 1.0 , 25 );
				this.addChild(mc_RingA[i]);
				mc_RingA[i].visible = false;
			}
			
		}
		//初期化
		public function Init( pos_x:int , pos_y:int ){
			
			mc_Core.Init();
			mc_Core.visible = true;
			
			for( i=0 ; i<RingNum ; i++ ){
				var rot:int = (int)(Math.random()*90);
				var size:Number = Math.random()*0.5 + 0.75;
				mc_RingA[i].Init();
				mc_RingA[i].visible = true;
				mc_RingA[i].scaleX = size*2.0;
				mc_RingA[i].scaleY = -size*0.5;
				mc_RingA[i].rotation = 45-rot;
				mc_RingB[i].Init();
				mc_RingB[i].visible = true;
				mc_RingB[i].scaleX = size*2.0;
				mc_RingB[i].scaleY = size*0.5;
				mc_RingB[i].rotation = 45-rot;
			}
			
			Pos_X = pos_x;
			Pos_Y = pos_y;
			
			Time = 0;
		}
		//爆発の展開
		public function moveExplode():Boolean{
			
			mc_Core.moveExplode();
			
			for( i=0 ; i<RingNum ; i++ ){
				mc_RingA[i].moveExplode();
				mc_RingB[i].moveExplode();
			}
			
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
			for( i=0 ; i<RingNum ; i++ ){
				mc_RingA[i].visible = false;
				mc_RingB[i].visible = false;
			}
		}
	}
}