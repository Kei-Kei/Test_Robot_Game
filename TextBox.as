package{
	import flash.display.Sprite;
	import flash.utils.*;
	import flash.text.*;
	
	public class TextBox extends Sprite{
		var inner_Text:TextField = new TextField();
		
		private var TextSetType;
		private var Lines:Array = new Array;
		private var Char_X:int;					//一行の文字数
		private var Char_Y:int;					//行数
		private var TopLine:int;				//先頭の行番号
		
		private var mc_Up:Sprite = new TextBox_Up();
		private var mc_Dn:Sprite = new TextBox_Up();
		
		//背景オブジェクトとか
		private var mc_Base:TextBox_Base = new TextBox_Base();
		
		public function TextBox( sx:int , sy:int ){
			//背景の設定
			this.addChild( mc_Base );
			mc_Base.scaleX = Math.floor(sx/10);
			mc_Base.scaleY = Math.floor(sy/10);
			mc_Base.x += 0.5;
			mc_Base.y += 0.5;
			
			//フォントの設定
			var frm:TextFormat = new TextFormat();
			frm.font = "_等幅";
			frm.color = 0xFFFFFF;
			frm.size = 10;
			
			Char_X = Math.floor( sx/10 ) - 1;
			Char_Y = Math.floor( sy/10 ) - 1;
			TopLine = 0;
			
			//テキストフィールドの設定
			inner_Text.text = " ";
			inner_Text.width = sx-5;
			inner_Text.height = sy;
			inner_Text.selectable = false;
			inner_Text.defaultTextFormat = frm;
			this.addChild(inner_Text);
			
			//スクロールバーの設定
			this.addChild( mc_Up );
			mc_Up.Init( true );
			mc_Up.x = sx - 5;
			mc_Up.y = 5;
			this.addChild( mc_Dn );
			mc_Dn.Init( true );
			mc_Dn.x = sx - 5;
			mc_Dn.y = sy - 5;
			mc_Dn.scaleY = -1.0;
		}
		
		//テキストの設定
		public function setText( inner:String ){
			var xlines:Array = inner.split( "\n" );
			var i:int,j:int;
			var line_num:int = 0;
			for( i=0 ; i<xlines.length ; i++ ){
				for( j=0 ; j<Math.floor(xlines[i].length/(Char_X+1))+1 ; j++ ){
					Lines[line_num] = xlines[i].slice( j*Char_X , (j+1)*Char_X );
					line_num++;
				}
			}
			mc_Up.Close();
			mc_Dn.Close();
			if( Lines.length > Char_Y ){
				mc_Up.Init( true );
				mc_Dn.Init( true );
			}else{
				mc_Up.Init( false );
				mc_Dn.Init( false );
			}
			dispText();
		}
		
		//テキストの表示
		public function dispText(){
			var i:int;
			var minline:int;
			if( TopLine + Char_Y > Lines.length )	minline = Lines.length-TopLine;
			else									minline = Char_Y;
			inner_Text.text = "";
			for( i=0 ; i<minline ; i++ ){
				inner_Text.appendText( Lines[i+TopLine] );
				if( i < Char_Y-1 )	inner_Text.appendText( "\n" );
			}
		}
		
		//毎フレーム処理
		public function ef_TextBox(){
			var ch_top:Boolean = false;
			if( mc_Up.Clicked() && TopLine > 0 ){
				TopLine -= Char_Y;
				ch_top = true;
			}
			if( mc_Dn.Clicked() && TopLine < Lines.length - Char_Y ){
				TopLine += Char_Y;
				ch_top = true;
			}
			if( ch_top )	dispText();
		}
	}
}