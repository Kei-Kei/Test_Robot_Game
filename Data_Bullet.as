package{
	public class Data_Bullet{
		//命中系
		public var Power:int;				//威力
		public var Penet_Flag:Boolean;		//貫通するかどうか
		public var Penet_Num:int;			//貫通可能回数
		public var Explode_Power:int;		//爆風威力
		public var Explode_Rad:int;			//爆風半径
		public var Proximity_Flag:Boolean;	//近接信管　ON　OFF
		public var Proximity_Rad:int;		//近接信管の半径
		public var Explode_Hit:int;			//命中時の爆発画像
		public var Explode_Hit_Size:Number;	//命中時の爆発画像のサイズ
		public var Explode_Erase:int;		//消滅時の爆発画像
		public var Explode_Erase_Size:Number;//消滅時の爆発画像のサイズ
		public var Sound_Hit:Boolean;		//命中時の音
		public var Sound_Hit_Size:Boolean;	//命中時の音の大きさ
		//移動系
		public var WallSlide:Boolean;		//壁滑り　ON　OFF
		public var WallReflect:Boolean;		//壁反射　ON　OFF
		public var Horming_Flag:Boolean;	//誘導　ON　OFF
		public var Horming_Power:Number;	//誘導の強さ
		public var Horming_Start:int;		//誘導を開始する時間
		public var Horming_End:int;			//誘導が終了する時間
		public var Gravity_Flag:Boolean;	//重力の影響　ON　OFF
		public var Gravity_Accel:int;		//落下加速度
		public var Gravity_MaxSpeed:int;	//最高落下速度
		public var Thrust:Number;			//推力
		public var Thrust_Start:int;		//噴射開始時間
		public var Thrust_End:int;			//噴射終了時間
		public var AirRegist:Number;		//減速係数（空気抵抗などによるもの）
		public var Breaking:Number;			//制動力
		public var Bullet_Life:int;			//弾の持続時間
		public var Bullet_Graphic:int;		//弾のグラフィック
		public var Bullet_Slave_Num:int;	//弾の子の数
		
		//コンストラクタ
		public function Data_Bullet(){
		}
		
		//データの構築
		public function Build( newdata:XML ){
			//命中系
			Power = newdata.Power;						//威力
			Penet_Flag = Utils.itoB(newdata.Penet_Flag);//貫通するかどうか
			Penet_Num = newdata.Penet_Num;				//貫通可能回数
			Explode_Power = newdata.Explode_Power;		//爆風威力
			Explode_Rad = newdata.Explode_Rad;			//爆風半径
			Proximity_Flag = Utils.itoB(newdata.Proximity_Flag);	//近接信管　ON　OFF
			Proximity_Rad = newdata.Proximity_Rad;		//近接信管の半径
			Explode_Hit = newdata.Explode_Hit;			//命中時の爆発画像
			Explode_Hit_Size = newdata.Explode_Hit_Size;//命中時の爆発画像のサイズ
			Explode_Erase = newdata.Explode_Erase;		//消滅時の爆発画像
			Explode_Erase_Size = newdata.Explode_Erase_Size;//消滅時の爆発画像のサイズ
			Sound_Hit = newdata.Sound_Hit;				//命中時の音
			Sound_Hit_Size = newdata.Sound_Hit_Size;	//命中時の音の大きさ
			//移動系
			WallSlide = Utils.itoB(newdata.WallSlide);			//壁滑り　ON　OFF
			WallReflect = Utils.itoB(newdata.WallReflect);		//壁反射　ON　OFF
			Horming_Flag = Utils.itoB(newdata.Horming_Flag);	//誘導　ON　OFF
			Horming_Power = newdata.Horming_Power * Math.PI / 180;	//誘導の強さ
			Horming_Start = newdata.Horming_Start;		//誘導を開始する時間
			Horming_End = newdata.Horming_End;			//誘導が終了する時間
			Gravity_Flag = Utils.itoB(newdata.Gravity_Flag);	//重力の影響　ON　OFF
			Gravity_Accel = newdata.Gravity_Accel;		//落下加速度
			Gravity_MaxSpeed = newdata.Gravity_MaxSpeed;//最高落下速度
			Thrust = newdata.Thrust;					//推力
			Thrust_Start = newdata.Thrust_Start;		//噴射開始時間
			Thrust_End = newdata.Thrust_End;			//噴射終了時間
			AirRegist = 1.0 - newdata.AirRegist;		//減速係数（空気抵抗などによるもの）
			Breaking = 1.0 - newdata.Breaking;			//制動力
			Bullet_Life = newdata.Bullet_Life;			//弾の持続時間
			Bullet_Graphic = newdata.Bullet_Graphic;	//弾のグラフィック
			Bullet_Slave_Num = newdata.Bullet_Slave_Num;//弾の子の数
		}
		
		//ランダムセット
		public function RandomSet(){
			//命中系
			Power = Math.floor(Math.random()*300);						//威力
			Penet_Flag = Utils.itoB( Math.floor(Math.random()*2) );		//貫通するかどうか
			Penet_Num = Math.floor(Math.random()*5);					//貫通可能回数
			Explode_Power = Math.floor(Math.random()*100);				//爆風威力
			Explode_Rad = Math.floor(Math.random()*10);					//爆風半径
			Proximity_Flag = Utils.itoB( Math.floor(Math.random()*2) );	//近接信管　ON　OFF
			Proximity_Rad = Math.floor(Math.random()*10);				//近接信管の半径
			Explode_Hit = Math.floor(Math.random()*4)+1;				//命中時の爆発画像
			Explode_Hit_Size = Math.random()*2.0;						//命中時の爆発画像のサイズ
			Explode_Erase = Math.floor(Math.random()*4)+1;				//消滅時の爆発画像
			Explode_Erase_Size =  Math.random()*2.0;					//消滅時の爆発画像のサイズ
			Sound_Hit = -1;												//命中時の音
			Sound_Hit_Size = 0.0;										//命中時の音の大きさ
			//移動系
			WallSlide = Utils.itoB( Math.floor(Math.random()*2) );		//壁滑り　ON　OFF
			WallReflect = Utils.itoB( Math.floor(Math.random()*2) );	//壁反射　ON　OFF
			Horming_Flag = Utils.itoB( Math.floor(Math.random()*2) );	//誘導　ON　OFF
			Horming_Power = Math.floor(Math.random()*180) * Math.PI / 180;	//誘導の強さ
			Horming_Start = Math.floor(Math.random()*30);				//誘導を開始する時間
			Horming_End = Horming_Start + Math.floor(Math.random()*100);		//誘導が終了する時間
			Gravity_Flag = Utils.itoB( Math.floor(Math.random()*2) );	//重力の影響　ON　OFF
			Gravity_Accel = Math.floor(Math.random()*0);				//落下加速度
			Gravity_MaxSpeed = Math.floor(Math.random()*0);			//最高落下速度
			Thrust = Math.random()*30.0;								//推力
			Thrust_Start = Math.floor(Math.random()*30);				//噴射開始時間
			Thrust_End = Thrust_Start + Math.floor(Math.random()*100);	//噴射終了時間
			AirRegist = Math.random();									//減速係数（空気抵抗などによるもの）
			Breaking = Math.random();									//制動力
			Bullet_Life = Math.floor(Math.random()*150);		//弾の持続時間
			Bullet_Graphic = Math.floor(Math.random()*5)+1;		//弾のグラフィック
			Bullet_Slave_Num = Math.floor(Math.random()*10);	//弾の子の数
		}
	}
}