//マウスオンのときにサイズが変わるボタン
package{
	public class ButtonObj_S extends ButtonObj{
		private var Light:Boolean = false;
		
		//マウスが乗ったときの処理
		override public function Mouse_Over(){
			if( !Light ){
				mc_Button.gotoAndStop(1);
				mc_Button.scaleX = 1.3;
				mc_Button.scaleY = 1.3;
				On = true;
			}
		}
		//マウスが離れたときの処理
		override public function Mouse_Out(){
			if( !Light ){
				mc_Button.gotoAndStop(1);
				mc_Button.scaleX = 1.0;
				mc_Button.scaleY = 1.0;
				On = false;
			}
		}
		//点灯させる
		public function LightOn(){
			mc_Button.gotoAndStop(2);
			mc_Button.scaleX = 1.0;
			mc_Button.scaleY = 1.0;
			Light = true;
		}
		//消灯させる
		public function LightOff(){
			mc_Button.gotoAndStop(1);
			Light = false;
		}
	}
}