package{
	import flash.display.Sprite;
	import flash.events.*;
	
	public class ButtonObj extends Sprite{
		
		public var mc_Button:Sprite;
		
		public var Click:Boolean = false;
		public var On:Boolean = false;
		
		public function ButtonObj(){
		}
		//初期化
		public function ButtonInit( mc:Sprite , x:Number , y:Number ){
			mc_Button = mc;
			this.addChild( mc_Button );
			mc_Button.x = x;
			mc_Button.y = y;
			mc_Button.gotoAndStop(1);
			this.addEventListener(MouseEvent.CLICK , mE_Click );
			this.addEventListener(MouseEvent.MOUSE_OVER , mE_Mouse_Over );
			this.addEventListener(MouseEvent.MOUSE_OUT , mE_Mouse_Out );
		}
		//終了処理
		public function ButtonClose(){
			this.removeChild( mc_Button );
			this.removeEventListener(MouseEvent.CLICK , mE_Click );
			this.removeEventListener(MouseEvent.MOUSE_OVER , mE_Mouse_Over );
			this.removeEventListener(MouseEvent.MOUSE_OUT , mE_Mouse_Out );
		}
		//クリックされたかどうか
		public function Clicked():Boolean{
			if( Click ){
				Click = false;
				return true;
			}else{
				return false;
			}
		}
		//クリックされたときの処理
		public function mE_Click(e:Event){
			Click = true;
		}
		//マウスが乗ったときの処理
		public function mE_Mouse_Over(e:Event){
			Mouse_Over();
		}
		public function Mouse_Over(){
			mc_Button.gotoAndStop(2);
			On = true;
		}
		//マウスが離れたときの処理
		public function mE_Mouse_Out(e:Event){
			Mouse_Out();
		}
		public function Mouse_Out(){
			mc_Button.gotoAndStop(1);
			On = false;
		}
	}
}