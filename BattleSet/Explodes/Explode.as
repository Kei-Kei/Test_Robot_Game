package BattleSet.Explodes{
	import flash.display.Sprite;
	
	public class Explode extends Sprite{
		
		public var mc_Explode:Sprite = new Sprite;
		
		public var Mode:int;
		
		//コンストラクタ
		public function Explode(){
			Mode = 0;
		}
		
		//爆発の生成
		public function addExplode( mode:int , pos_x:int , pos_y:int , drec:int , size:Number , type:int){
			switch( type ){
				case 1:		mc_Explode = new Explode01();	break;
				case 2:		mc_Explode = new Explode02();	break;
				case 3:		mc_Explode = new Explode03();	break;
				case 4:		mc_Explode = new Explode04();	break;
			}
			this.addChild( mc_Explode );
			
			mc_Explode.Init( pos_x , pos_y );
			mc_Explode.scaleX = size;
			mc_Explode.scaleY = size;
			mc_Explode.rotation = drec;
			mc_Explode.visible = true;
			
			Mode = mode;
		}
		
		public function moveExplode( gap_x:int , gap_y:int ):Boolean{
			if( Mode != 0 ){
				if( mc_Explode.moveExplode() ){
					mc_Explode.x = mc_Explode.Pos_X + gap_x;
					mc_Explode.y = mc_Explode.Pos_Y + gap_y;
					return true;
				}else{
					this.removeChild( mc_Explode );
					Mode = 0;
					return false;
				}
			}
		}
	}
}