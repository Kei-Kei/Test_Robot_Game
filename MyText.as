package{
	import flash.display.Sprite;
	import flash.utils.*;
	import flash.text.*;
	
	public class MyText extends Sprite{
		public var textFormat:TextFormat = new TextFormat();
		public var inner_Text:TextField = new TextField();
		
		[Embed(source="fonts/Tiny Bit.ttf" , fontName="tiny")]
		var myfont:Class;
		
		public function MyText( px:int , py:int , type){
			
			//フォントの設定
			//textFormat.font = "tiny";
			//textFormat.size = 12;
			textFormat.font = "_ゴシック";
			
			//inner_Text.embedFonts = true;
			inner_Text.defaultTextFormat = textFormat;
			
			//時間の表示
			inner_Text.text = " ";
			switch(type){
			case "LEFT":
				inner_Text.autoSize  = TextFieldAutoSize.LEFT;
				break;
			case "CENTER":
				inner_Text.autoSize  = TextFieldAutoSize.CENTER;
				break;
			}
			this.addChild(inner_Text);
			inner_Text.x = px;
			inner_Text.y = py;
		}
		
		public function setAreaSize( w , h ){
			inner_Text.width = w;
			inner_Text.height = h;
		}
		
		public function dispText( inner:String ){
			inner_Text.text = inner;
		}
	}
}