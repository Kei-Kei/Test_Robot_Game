/*-------------------------------------------------------------------------------------------------
ゲームのデータのロードを行うクラス。
プリローダーの機能も持つが見た目は別途スキンで用意する予定
-------------------------------------------------------------------------------------------------*/
package{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.*;
	
	public class PreLoader extends Sprite{
		//ファイルローダー
		private var loader_SWF:fileLoader = new fileLoader();
		private var loader_Weapon:xmlLoader = new xmlLoader();
		private var loader_Bullet:xmlLoader = new xmlLoader();
		private var loader_Parts:xmlLoader = new xmlLoader();
		private var loader_Player:xmlLoader = new xmlLoader();
		private var loader_Enemy:xmlLoader = new xmlLoader();
		private var loader_Map:xmlLoader = new xmlLoader();
		private var loader_City:xmlLoader = new xmlLoader();
		
		//ゲームデータ
		private var Datas:Data_Game;
		
		//スキン
		public var text_Load:MyText = new MyText(200 , 200 , "CENTER");
		
		public function PreLoader( datas:Data_Game ){
			
			Datas = datas;
			
			//swf本体
			loader_SWF.Load("AS3_test01.swf");

			//XMLファイル
			loader_Weapon.Load("data/BaseData/Weapon_Data.xml");
			loader_Bullet.Load("data/BaseData/Bullet_Data.xml");
			loader_Parts.Load("data/BaseData/Parts_Data.xml");
			loader_Player.Load("data/BaseData/Player_Data.xml");
			loader_Enemy.Load("data/BaseData/Enemy_Data.xml");
			loader_Map.Load("data/BaseData/Map_Data.xml");
			loader_City.Load("data/BaseData/City_Data.xml");
			
			this.addChild(text_Load);
		}
		
		public function dispLoading(){
			//総進行状況を取得
			var loadeds,totals:int;
			loadeds = 0;
			loadeds += loader_SWF.Loaded;
			loadeds += loader_Weapon.Loaded;
			loadeds += loader_Bullet.Loaded;
			loadeds += loader_Parts.Loaded;
			loadeds += loader_Player.Loaded;
			loadeds += loader_Enemy.Loaded;
			loadeds += loader_Map.Loaded;
			loadeds += loader_City.Loaded;
			totals = 0;
			totals += loader_SWF.Total;
			totals += loader_Weapon.Total;
			totals += loader_Bullet.Total;
			totals += loader_Parts.Total;
			totals += loader_Player.Total;
			totals += loader_Enemy.Total;
			totals += loader_Map.Total;
			totals += loader_City.Total;
			
			text_Load.dispText( "Loading:" + loadeds + " bytes / " + totals +" bytes");
			
			//ロードが完了したかを確認
			if( loader_SWF.Complete &&
			    loader_Weapon.Complete &&
			    loader_Bullet.Complete &&
				loader_Parts.Complete &&
				loader_Player.Complete &&
				loader_Enemy.Complete &&
				loader_Map.Complete &&
				loader_City.Complete){
				//データを構築する
				cD_Weapon();
				cD_Bullet();
				cD_Parts();
				cD_Player();
				cD_Enemy();
				cD_Map();
				cD_City();
				return true;
			}
			return false;
		}

		//武器データの構築
		private function cD_Weapon(){
			var xmlData:XML = loader_Weapon.retData();
			var i:int;
			for(i=0 ; i<xmlData.Weapon.length() ; i++){
				Datas.Weapons[i] = new Data_Weapon();
				Datas.Weapons[i].Build( xmlData.Weapon[i] );
			}
		}
		
		//弾丸データの構築
		private function cD_Bullet(){
			var xmlData:XML = loader_Bullet.retData();
			var i:int;
			for(i=0 ; i<xmlData.Bullet.length() ; i++){
				Datas.Bullets[i] = new Data_Bullet();
				Datas.Bullets[i].Build( xmlData.Bullet[i] );
			}
		}
		
		//パーツデータの構築
		private function cD_Parts(){
			var xmlData:XML = loader_Parts.retData();
			var i:int;
			for(i=0 ; i<xmlData.Parts.length() ; i++){
				Datas.XParts[i] = new Data_Parts();
				Datas.XParts[i].Build( xmlData.Parts[i] );
			}
		}
		
		//自機データの構築（仮
		private function cD_Player(){
			var xmlData:XML = loader_Player.retData();
			var i:int;
			for(i=0 ; i<xmlData.Player.length() ; i++){
				Datas.Players[i] = new Data_Player();
				Datas.Players[i].Build( xmlData.Player[i] );
			}
		}		
		
		//敵データの構築
		private function cD_Enemy(){
			var xmlData:XML = loader_Enemy.retData();
			var i:int;
			for(i=0 ; i<xmlData.Enemy.length() ; i++){
				Datas.Enemys[i] = new Data_Enemy();
				Datas.Enemys[i].Build( xmlData.Enemy[i] );
			}
		}

		//地形データの構築
		private function cD_Map(){
			var xmlData:XML = loader_Map.retData();
			var i:int;
			for(i=0 ; i<xmlData.Map.length() ; i++){
				Datas.Maps[i] = new Data_Map();
				Datas.Maps[i].Build( xmlData.Map[i] );
			}
		}
		
		//都市データの構築
		private function cD_City(){
			var xmlData:XML = loader_City.retData();
			var i:int;
			for(i=0 ; i<xmlData.City.length() ; i++){
				Datas.Cities[i] = new Data_City();
				Datas.Cities[i].Build( xmlData.City[i] );
			}
		}
	}
}