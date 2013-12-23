package{
	import flash.display.Sprite;
	
	public class TextBox_Up extends ButtonObj{
		public var mc_DeActive:Sprite = new TextBox_Scroll_Up_de();
		
		private var Active:Boolean;	//ボタンが使用可能かどうか？
		
		public function TextBox_Up(){
		}
		
		public function Init( active:Boolean ){
			Active = active;
			if( !Active ){
				this.addChild( mc_DeActive );
			}else{
				ButtonInit( new TextBox_Scroll_Up , 0 , 0 );
			}
		}
		public function Close(){
			if( !Active )	this.removeChild( mc_DeActive );
			else			ButtonClose();
		}
		
		override public function Clicked():Boolean{
			if( Click ){
				Click = false;
				return true;
			}else{
				return false;
			}
		}
	}
}