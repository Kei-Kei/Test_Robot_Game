package BattleSet{
	import flash.display.Sprite;
	
	public class Player extends Battle_Object{
		public var mc_Reticle:Reticle = new Reticle();
		
		public function Player(){
		}
		
		//初期化
		public function Init( parts_data:Array , weapon_data:Array , player_data:Data_Player ){
			this.addChild(mc_Reticle);
			
			BO_Init( parts_data , weapon_data , player_data.Parts );
			
			//位置関係パラメーター
			Pos_X = 0;
			Pos_Y = 0;
			Speed_X = 0;
			Speed_Y = 0;
			DownSpeed = 0.80;
			
		}
		
		//入力に対する処理---------------------------------------------------------------------------------------
		//キー入力時の処理
		public function inputKey( drec:int , dash:Boolean , boost:Boolean ){
			
			var sqrt2_2:Number = Math.SQRT2 / 2;
			switch( drec ){
				case 7:		
					Thrust_Drec.x = -sqrt2_2;
					Thrust_Drec.y = -sqrt2_2;
					break;
				case 9:
					Thrust_Drec.x = sqrt2_2;
					Thrust_Drec.y = -sqrt2_2;
					break;
				case 1:
					Thrust_Drec.x = -sqrt2_2;
					Thrust_Drec.y = sqrt2_2;
					break;
				case 3:
					Thrust_Drec.x = sqrt2_2;
					Thrust_Drec.y = sqrt2_2;
					break;
				case 8:
					Thrust_Drec.x = 0.0;
					Thrust_Drec.y = -1.0;
					break;
				case 2:
					Thrust_Drec.x = 0.0;
					Thrust_Drec.y = 1.0;
					break;
				case 4:
					Thrust_Drec.x = -1.0;
					Thrust_Drec.y = 0.0;
					break;
				case 6:
					Thrust_Drec.x = 1.0;
					Thrust_Drec.y = 0.0;
					break;
				default:
					Thrust_Drec.x = 0.0;
					Thrust_Drec.y = 0.0;
					break;
			}
			
			if( drec != -1 ){
				CalcThrust( dash , boost );
			}else{
				Thrust = 0;
			}
			
			mc_Machine.SetPose( Thrust , Thrust_Drec , Boost , Speed_X , Speed_Y , Aim_Drec , Gun_Drec );
		}
		
		//マウス入力時の処理
		public function inputMouse(){
			if( !ShotMode ){
				ShotTime = 0;
				ShotMode = true;
			}
		}
		
		//照準関連-------------------------------------------------------------------------------------------
		//照準の初期化
		public function InitReticle(){
			mc_Reticle.RockInit( Target );
		}
		
		//照準の表示
		public function DispReticle(){
			mc_Reticle.SetSize( Weapons[SelectWeapon].Rock_Range , Weapons[SelectWeapon].Rock_Drec );
			mc_Reticle.SetDrec( Reticle_Drec );
			
			var i:int;
			for(i=0 ; i<Target.length ; i++){
				mc_Reticle.DispTarget( i , Target[i].Pos_X - Pos_X , Target[i].Pos_Y - Pos_Y , Target[i].InSight , Target[i].Time , Target[i].Rocked );
			}
			
			mc_Reticle.SetVector( SetNearTarget() , 0);
		}
		
		//照準距離を返す
		public function RetRange():int{
			return Weapons[SelectWeapon].Rock_Range;
		}
	}
}