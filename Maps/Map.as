package Maps{
	import flash.display.Sprite;
	import Maps.Backs.*;
	import MiniObj.*;
	
	import BattleSet.Field_Object;
	
	public class Map extends Sprite{
		//ステージの大きさ
		private var stage_x_size:int = 400;
		private var stage_y_size:int = 300;
		
		//背景
		public var BackGround:Sprite;
		//近景
		public var mc_Front:Sprite;
		public var mc_Front_Unit = new Array();
		public var mc_Tips:Array = new Array();
		//分割サイズ
		private var U_Size:int = 500;
		
		//壁判定
		public var Walls:Array = new Array()
		
		public function Map(){
			//背景
			BackGround = new Back();
			this.addChild( BackGround );
			
			mc_Front = new Sprite();
			this.addChild( mc_Front );
			
			var i:int,j:int;
			var loop:int = 20000/U_Size;
			for( i=0 ; i<loop ; i++ ){
				mc_Front_Unit[i] = new Array();
				for( j=0 ; j<loop ; j++ ){
					mc_Front_Unit[i][j] = new Sprite();
				}
			}
		}
		
		//初期化
		public function Init( map_data:Data_Map ){
			//背景の追加
			BackGround.Init();
			
			var i:int,j:int;
			//前景の追加
			//前景パーツを一定サイズごとのブロックに分配する
			for( i=0 ; i<map_data.Tips.length ; i++ ){
				var maplib:MapSkinLib = new MapSkinLib();
				mc_Tips[i] = maplib.retMap( map_data.Tips[i].Skin );
				mc_Tips[i].x = map_data.Tips[i].Pos_X;
				mc_Tips[i].y = map_data.Tips[i].Pos_Y;
				mc_Front.addChild( mc_Tips[i] );
			}
			
			//壁の追加
			for( i=0 ; i<map_data.Walls.length ; i++ ){
				Walls[i] = map_data.Walls[i];
			}
		}
		
		//終了処理
		public function Close(){
			BackGround.Close();
			var loop:int = 20000/U_Size;
			for( i=0 ; i<loop ; i++ ){
				for( j=0 ; j<loop ; j++ ){
					while( mc_Front_Unit[i][j].numChildren > 0 ){
						mc_Front_Unit[i][j].removeChildAt( 0 );
					}
				}
			}
			while( mc_Front.numChildren > 0 ){
				mc_Front.removeChildAt(0);
			}
		}
		
		//表示
		public function Disp( gap_x:int , gap_y:int ){
			BackGround.Disp( gap_x , gap_y );
			
			mc_Front.x = gap_x;
			mc_Front.y = gap_y;
		}
		
		//壁とオブジェクトの当たり判定の計算
		public function calcHit_Wall( f_obj:Field_Object ):WallHit{
			var i:int;
			var c_hit:WallHit = new WallHit();
			for( i=0 ; i<Walls.length ; i++ ){
				c_hit = Walls[i].CalcHit( f_obj );
				if( c_hit.Hit ) break;
			}
			if( !c_hit.Hit )	f_obj.Move();
			return c_hit;
		}
		
	}
}