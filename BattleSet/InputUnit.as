package BattleSet{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.getTimer;
	import flash.ui.*;
	
	public class InputUnit extends Sprite{
		
		//キー入力モード
		private var key_up:Boolean = false;
		private var key_down:Boolean = false;
		private var key_left:Boolean = false;
		private var key_right:Boolean = false;
		//キー入力状態
		public var keydrec:int;
		private var old_keydrec:Array = new Array();
		private var new_keydrec:Array = new Array();
		//ダッシュ検出用
		private var numStack:int = 3;	//キーの保存数
		private var numNewkey:int;		//離した後に入力されたキー数
		private var keyOntime:int;
		private var keyOfftime:int;
		private var keyQuiq:Boolean;
		public var Dash:Boolean;
		public var Boost:Boolean;
		public var SecondDash:Boolean = false;
		//マウス入力モード
		public var mouse_down:Boolean = false;
		public var mouse_x:int = 0;
		public var mouse_y:int = 0;
		public var Cursor:Sprite = new Cursor01();
		//武器変更
		public var C_Wep:Boolean = false;
		
		//ヴァーチャルマウスモード
		private var VirtualMouse:Boolean = false;
		
		//コンストラクタ
		public function InputUnit(){
			var i:int;
			for( i=0 ; i<numStack ; i++ ){
				old_keydrec[i] = -1;
				new_keydrec[i] = -1;
			}
		}
		
		//入力初期化------------------------------------------------------------------------------------------
		public function Init(){
			stage.addEventListener(KeyboardEvent.KEY_DOWN , keydown);
			stage.addEventListener(KeyboardEvent.KEY_UP , keyup);
			stage.addEventListener(MouseEvent.MOUSE_DOWN , mousedown);
			stage.addEventListener(MouseEvent.MOUSE_UP , mouseup);
			stage.addEventListener(MouseEvent.MOUSE_MOVE , mousemove);
			
			//カーソルの変更
			this.addChild(Cursor);
			//Cursor.cacheAsBitmap = true;
			Mouse.hide();
			
			numNewkey = 0;
		}
		
		//終了処理-------------------------------------------------------------------------------------------
		public function Close(){
			//イベントリスナの破棄
			stage.removeEventListener(KeyboardEvent.KEY_DOWN , keydown);
			stage.removeEventListener(KeyboardEvent.KEY_UP , keyup);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN , mousedown);
			stage.removeEventListener(MouseEvent.MOUSE_UP , mouseup);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE , mousemove);
			
			//マウス表示を元に戻す
			Mouse.show();
			this.removeChild(Cursor);
		}
		
		//入力管理-------------------------------------------------------------------------------------------
		//キーボードが押されたときの処理
		private function keydown(e:KeyboardEvent){
			if( e.keyCode == Keyboard.UP || e.keyCode == 87 ) key_up = true;		//上
			if( e.keyCode == Keyboard.DOWN || e.keyCode == 83 ) key_down = true;	//下
			if( e.keyCode == Keyboard.LEFT || e.keyCode == 65 ) key_left = true;	//左
			if( e.keyCode == Keyboard.RIGHT || e.keyCode == 68 ) key_right = true;	//右
			if( e.keyCode == Keyboard.CONTROL || e.keyCode == 81 ) C_Wep = true;	//武器変更
			
			//仮想マウス
			if( VirtualMouse ){
				if( e.keyCode == 84 ){	mouse_x = 160;	mouse_y = 110;}	//左上
				if( e.keyCode == 89 ){	mouse_x = 200;	mouse_y = 110;}	//上
				if( e.keyCode == 85 ){	mouse_x = 240;	mouse_y = 110;}	//右上
				if( e.keyCode == 71 ){	mouse_x = 160;	mouse_y = 150;}	//左
				if( e.keyCode == 74 ){	mouse_x = 240;	mouse_y = 150;}	//右
				if( e.keyCode == 66 ){	mouse_x = 160;	mouse_y = 190;}	//左下
				if( e.keyCode == 78 ){	mouse_x = 200;	mouse_y = 190;}	//下
				if( e.keyCode == 77 ){	mouse_x = 240;	mouse_y = 190;}	//右下
				Cursor.x = mouse_x;
				Cursor.y = mouse_y;
				//仮想マウスボタン
				if( e.keyCode == 72 )	mouse_down = true;
			}
			
			//仮想マウス切り替え
			if(e.keyCode == 80){
				if( VirtualMouse )	VirtualMouse = false;
				else				VirtualMouse = true;
			}
		}
		
		//キーボードが離されたときの処理
		private function keyup(e:KeyboardEvent){
			if( e.keyCode == Keyboard.UP || e.keyCode == 87 ) key_up = false;		//上
			if( e.keyCode == Keyboard.DOWN || e.keyCode == 83 ) key_down = false;	//下
			if( e.keyCode == Keyboard.LEFT || e.keyCode == 65 ) key_left = false;	//左
			if( e.keyCode == Keyboard.RIGHT || e.keyCode == 68 ) key_right = false;	//右
			
			//仮想マウスボタン
			if( VirtualMouse ){
				if( e.keyCode == 72 )	mouse_down = false;
			}
		}
		
		//マウスを押したときの処理（射撃）
		private function mousedown(e:MouseEvent){
			if( !VirtualMouse ){
				mouse_down = true;
				mouse_x = e.stageX;
				mouse_y = e.stageY;
				Cursor.x = e.stageX;
				Cursor.y = e.stageY;
			}
		}
		
		//マウスを離したときの処理
		private function mouseup(e:MouseEvent){
			if( !VirtualMouse ){
				mouse_down = false;
			}
		}
		
		//マウスが移動したときの処理
		private function mousemove(e:MouseEvent){
			if( !VirtualMouse ){
				mouse_x = e.stageX;
				mouse_y = e.stageY;
				Cursor.x = e.stageX;
				Cursor.y = e.stageY;
			}
		}
		
		//データ取得------------------------------------------------------------------------------------------
		//キー入力の方向を返す
		public function SetKeyDrec(){

			var i,j:int;
			
			if( key_up && key_left )		keydrec = 7	//左上
			else if( key_up && key_right )	keydrec = 9	//右上
			else if( key_down && key_left ) keydrec = 1	//左下
			else if( key_down && key_right )keydrec = 3	//右下
			else if( key_up )				keydrec = 8	//上
			else if( key_down )				keydrec = 2	//下
			else if( key_left )				keydrec = 4	//左
			else if( key_right )			keydrec = 6	//右
			else							keydrec = -1//入力なし
			
			
			var keyoff:int = 10;	//二回押しの間に許容されるラグ
			//キー2回押しで新たに押されたキーのログを採りはじめる
			if( keyOfftime > 0 && keyOfftime <= keyoff && keyQuiq ){
				new_keydrec[0] = keydrec;
				numNewkey = 1;
			}
			
			//新たに入力されたキーのログを採る
			if( numNewkey != 0 ){
				new_keydrec[numNewkey] = keydrec;
				numNewkey++;
			}
			
			//新たに入力されたキーのログが一定数に達したら2回押しの判定をする
			if( numNewkey == numStack ){
				for( i=0 ; i<numStack ; i++ ){
					for( j=0 ; j<numStack ; j++ ){
						if( old_keydrec[i] == new_keydrec[j] ){
							Dash = true;
							break;
						}
					}
				}
				numNewkey = 0;
			}
			
			//キーを押したタイミングを調整
			if( keydrec != -1 ){
				//キーを離す前数個分のキー入力を保存
				if( numNewkey == 0 ){
					for( i=numStack - 1 ; i>0 ; i-- ){
						old_keydrec[i] = old_keydrec[i-1];
					}
					old_keydrec[0] = keydrec;
				}
				//二次ダッシュ起動
				if( SecondDash ){
					Dash = true;
					Boost = true;
					SecondDash = false;
				}
				//キー入力時間の確保
				keyOntime++;
				keyOfftime = 0;
				keyQuiq = false;
			}else{
				//キーが一瞬だけ押されたのを検知
				if( keyOntime > 0 && keyOntime <= 6 ){
					keyQuiq = true;
				}
				//キー入力時間の確保
				keyOntime = 0;
				keyOfftime++;
				//二次ダッシュの時間計測
				if( Boost )	SecondDash = true;
				if( keyOfftime > keyoff )	SecondDash = false;
				Boost = false;
			}
		}
		
	}
}