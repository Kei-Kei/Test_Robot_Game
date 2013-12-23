/*-----------------------------------------------
敵の行動パターンを定義
敵の種類も定義する
-----------------------------------------------*/
package{
	public class Data_AI{
		//機体の種類
		public var Type;
		
		//敵の行動
		public var B_Type:Array = new Array();
		
		public function Data_AI(){
		}
		
		//タイプの設定
		public function setType( type:int ){
			Type = type;
		}
	}
}