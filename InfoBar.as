package{
	import flash.display.Sprite;
	import flash.text.*;
	
	public class InfoBar extends Sprite{
		public var mc_Back:InterFace_Bar_Dn = new InterFace_Bar_Dn();
		
		public var Text:TextField = new TextField();
		
		public function InfoBar(){
			this.addChild( mc_Back );
			
			setText("ぬるぽぬるぽんるもても");
		}
		
		public function setText( tx:String ){
			mc_Back.Line_Text.text = tx;
		}
	}
}