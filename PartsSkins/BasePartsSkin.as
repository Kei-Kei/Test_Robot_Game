package PartsSkins{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	public class BasePartsSkin extends Sprite{
		
		public var mc_Parts:Sprite;
		public var Mode:int;
		
		public var Cen_X:int;	//パーツの中心
		public var Cen_Y:int;	//パーツの中心
		public var Rad:int;		//パーツの半径
		
		public var Drec:int;	//現在の方向
		public var Drec_LR:int;	//現在の左右の向き
		public var Pos_X:Number;//現在の位置
		public var Pos_Y:Number;//現在の位置
		public var Scale:Number;//大きさ
		public var Time:int;	//アニメーション用時間
		public var MaxTime:int;	//アニメーション用時間
		public var Layer:int;					//パーツの存在する階層
		public var Child:Array = new Array();	//パーツの子インデックス
		
		public var JointNum:int;	//ジョイントの数
		public var Joint_X:Array = new Array();	//ジョイントの位置
		public var Joint_Y:Array = new Array();	//ジョイントの位置
		protected var JointDef_Length:Array = new Array();//ジョイントの基本位置（回転軸からの距離）
		protected var JointDef_Rad:Array = new Array();	//ジョイントの基本位置（回転軸からの角度）
		
		public var WepNum:int;	//武器の数
		public var WepUse:Array = new Array();	//その武器が使用中かどうか
		public var WepDrec:Array = new Array();	//銃身の方向
		public var Wep_X:Array = new Array();	//銃口の位置
		public var Wep_Y:Array = new Array();	//銃口の位置
		protected var WepDef_Length:Array = new Array();	//銃口の基本位置（回転軸からの距離）
		protected var WepDef_Rad:Array = new Array();		//銃口の基本位置（回転軸からの角度）
		public var WepCen_X:Array = new Array();	//武器部分の回転軸
		public var WepCen_Y:Array = new Array();	//武器部分の回転軸
		protected var WepCenDef_Length:Array = new Array();	//回転軸の基本位置（回転軸からの距離）
		protected var WepCenDef_Rad:Array = new Array();		//回転軸の基本位置（回転軸からの角度）
		
		public var Muzzle:Array = new Array();	//銃口のエフェクト
		
		public var AimType:int;					//動きを親パーツに任せるか(0：任せない、1:照準を任せる、2：アクションを任せる)
		
		//コンストラクタ
		public function BasePartsSkin(){
			Mode = 0;
			Scale = 1.0;
			AimType = 0;
		}
		
		//ポーズの設定
		public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
		}
		
		//-----アクション-------------------------------------------------------------------------------------
		//アクションの設定
		public function SetAction( type:int , time:int , maxtime:int ):Boolean{
			switch( type ){
				case 0:	return	Action_Slush( time , maxtime );	break;
				case 1:	return	Action_Wait( time , maxtime );	break;
			}
		}
		//斬り動作
		public function Action_Slush( time:int , maxtime:int ):Boolean{
			return false;
		}
		//待機動作
		public function Action_Wait( time:int , maxtime:int ):Boolean{
			return false;
		}
		//-----------------------------------------------------------------------------------------------
		
		//銃口のエフェクトの追加
		public function SetMuzzle( num:int , wepnum:int , gap_x:Number , gap_y:Number , drec:int ){
		}
		
		//銃口のエフェクトの再生(p_mode：0：再生開始、1：通常再生、2：停止)
		public function PlayMuzzle( p_mode:int ){
			var i:int;
			for( i=0 ; i<Muzzle.length ; i++ ){
				switch( p_mode ){
					case 0:	
						Muzzle[i].Reset();
						Muzzle[i].Play();
						break;
					case 1:	
						Muzzle[i].Play();
						break;
					case 2:
						Muzzle[i].Stop();
						break;
				}
			}
		}
		
		//大きさの設定
		protected function SetSize( cen_x:int , cen_y:int , rad:int ){
			Cen_X = cen_x;
			Cen_Y = cen_y;
			Rad = rad;
		}
		
		//方向の設定
		public function SetDrec( drec:int , drec_LR:int ){
		
			mc_Parts.rotation = drec_LR * drec;
			mc_Parts.scaleX = Math.abs( mc_Parts.scaleX ) * drec_LR;
			
			Drec = drec;
			Drec_LR = drec_LR;
		}
		
		//パーツ位置の設定
		public function SetPos( pos_x:Number , pos_y:Number ){
			mc_Parts.x = pos_x;
			mc_Parts.y = pos_y;
			
			Pos_X = pos_x;
			Pos_Y = pos_y;
		}
		
		//パーツサイズの設定
		public function SetScale( scale:Number ){
			mc_Parts.scaleX = scale * Drec_LR;
			mc_Parts.scaleY = scale;
			
			Scale = scale;
		}
		
		//ジョイントの設定---------------------------------------------------------------------------------------
		//ジョイント位置の初期化
		public function InitJoint( num:int ){
			JointNum = num;
			var i:int;
			for( i=0 ; i<JointNum ; i++ ){
				Joint_X[i] = new Number();
				Joint_Y[i] = new Number();
				JointDef_Length[i] = new Number();
				JointDef_Rad[i] = new Number();
			}
		}
		
		//ジョイント基本位置の設定
		public function SetJointDef( num:int , pos_x:Number , pos_y:Number ){
			JointDef_Length[num] = Math.sqrt( Math.pow( pos_x , 2 ) + Math.pow( pos_y , 2 ) );
			JointDef_Rad[num] = Math.atan2( pos_y , pos_x );
		}

		//ジョイント位置の再設定
		public function SetJoint(){
			var rad = Drec * Math.PI / 180;
			
			var i:int;
			for( i=0 ; i<JointNum ; i++ ){
				Joint_X[i] = JointDef_Length[i] * Scale * Math.cos( JointDef_Rad[i] + rad ) * Drec_LR + Pos_X;
				Joint_Y[i] = JointDef_Length[i] * Scale * Math.sin( JointDef_Rad[i] + rad ) + Pos_Y;
			}
		}
		
		//火器系の設定-----------------------------------------------------------------------------------------
		//内蔵火器系の初期化
		public function InitWep( num:int ){
			WepNum = num;
			var i:int;
			for( i=0 ; i<WepNum ; i++ ){
				WepUse[i] = false;
				WepDrec[i] = new int();
				Wep_X[i] = new int();
				Wep_Y[i] = new int();
				WepDef_Length[i] = new int();
				WepDef_Rad[i] = new int();
				WepCen_X[i] = new int();
				WepCen_Y[i] = new int();
				WepCenDef_Length[i] = new int();
				WepCenDef_Rad[i] = new int();
			}
		}
		
		//内蔵火器基本位置の設定
		public function SetWepDef( num:int , pos_x:int , pos_y:int , cen_x:int , cen_y:int ){
			//銃口位置の設定
			WepDef_Length[num] = Math.sqrt( Math.pow( pos_x , 2 ) + Math.pow( pos_y , 2 ) );
			WepDef_Rad[num] = Math.atan2( pos_y , pos_x );
			//回転軸の設定
			WepCenDef_Length[num] = Math.sqrt( Math.pow(cen_x , 2 ) + Math.pow( cen_y , 2 ) );
			WepCenDef_Rad[num] = Math.atan2( cen_y , cen_x );
		}
		
		//内蔵火器方向の変更
		public function SetWepDrec( num:int , drec:int ){
			WepDrec[num] = drec;
			//方向の変更にあわせて銃口の位置も変化させる
			var rad_1 = drec * Math.PI / 180;	//内蔵火器の方向
			var rad_2 = Drec * Math.PI / 180;	//パーツ自体の方向
			//回転軸を計算
			WepCen_X[num] = WepCenDef_Length[num] * Scale *  Math.cos( WepCenDef_Rad[num] + rad_2 ) * Drec_LR + Pos_X;
			WepCen_Y[num] = WepCenDef_Length[num] * Scale * Math.sin( WepCenDef_Rad[num] + rad_2 ) + Pos_Y;
			//銃口位置の計算
			Wep_X[num] = WepDef_Length[num] * Scale * Math.cos( WepDef_Rad[num] + rad_1 ) * Drec_LR + WepCen_X[num];
			Wep_Y[num] = WepDef_Length[num] * Scale * Math.sin( WepDef_Rad[num] + rad_1 ) + WepCen_Y[num];
		}
		
		//外観の設定------------------------------------------------------------------------------------------
		protected function SetTriCol( mc:Sprite , num:int , level:int , r:int , g:int , b:int ){
			var rX:int,gX:int,bX:int;
			rX = RetCol( level , r );
			gX = RetCol( level , g );
			bX = RetCol( level , b );
			
			switch( num ){
			case 1:
				SetCol( mc.Col_1 , rX , gX , bX );
				break;
			case 2:
				SetCol( mc.Col_2 , rX , gX , bX );
				break;
			case 3:
				SetCol( mc.Col_3 , rX , gX , bX );
				break;
			}
		}
		protected function SetCol( mc:Sprite , r:int , g:int , b:int ){
			var colx:ColorTransform = new ColorTransform(1.0, 1.0, 1.0, 1, r, g, b, 0);
			if( mc != null )	mc.transform.colorTransform = colx;
		}
		//色変更用汎用関数
		protected function RetCol( level:int , val:int ):int{
			return (int)( val * 160/256 + (level+1)*24 );
		}
		
		//汎用振り子関数(周期、現在時間、速度)
		protected function RetWave( max:int , now:int , spd:Number ):int{
			var ret:int;
			if( Time < max/2 ){
				ret = (int)((Time - max/4) * spd);
			}else{
				ret = (int)((-Time + max*3/4) * spd);
			}
			return ret;
		}
	}
}