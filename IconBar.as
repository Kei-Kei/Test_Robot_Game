package{
	import flash.display.Sprite;
	
	public class IconBar extends Sprite{
		private var Icons:Array = new Array();
		private var Lines:Array = new Array();
		
		private var LineNow:int;	//現在の列番号
		
		public function Init(){
			LineNow = 0;
			//RETURNアイコンの追加
			Icons[0] = new ButtonObj_S();
			Icons[0].ButtonInit( new IF_Icon_Return() , 0 , 20 );
			this.addChild( Icons[0] );
			Icons[0].visible = false;
			
			//初期設定（必要に応じて変更
			AddIcon( new IF_Icon_World() );
			AddIcon( new IF_Icon_Mission() );
			AddIcon( new IF_Icon_Garage() );
			AddIcon( new IF_Icon_Garage() );
			AddIcon( new IF_Icon_Garage() );
			AddLine( -1, 1, true );
			AddLine( 0, 2, true );
			AddLine( 0, 3, true );
			AddLine( 1, 4, false );
			AddLine( 2, 5, false );
			Disp();
		}
		
		//アイコンの追加
		public function AddIcon( mc:Sprite ){
			iconnum = Icons.length;
			Icons[iconnum] = new ButtonObj_S();
			Icons[iconnum].ButtonInit( mc , 0 , 20 );
			this.addChild( Icons[iconnum] );
			Icons[iconnum].visible = false;
		}
		//メニューの追加
		public function AddLine( parent:int , iconnum:int , line:Boolean ){
			//ラインを追加
			if( line ){
				linenum = Lines.length;
				Lines[linenum] = new IconBar_Line();
				Lines[linenum].Parent = parent;
				Lines[linenum].MyIconNum = iconnum;
				if( parent != -1 ){
					Lines[parent].AddChild( linenum , iconnum);
				}
			}
			//アイコンのみ追加
			else{
				if( parent != -1 ){
					Lines[parent].AddChild( -1 , iconnum);
				}
			}
		}
		//初期表示
		public function Disp(){
			var i:int;
			for( i=0 ; i<Icons.length ; i++ ){
				Icons[i].visible = false;
			}
			Icons[Lines[LineNow].MyIconNum].visible = true;
			Icons[Lines[LineNow].MyIconNum].x = 20;
			Icons[Lines[LineNow].MyIconNum].LightOn();
			for( i=0 ; i<Lines[LineNow].IconNum.length ; i++ ){
				Icons[Lines[LineNow].IconNum[i]].LightOff();
				Icons[Lines[LineNow].IconNum[i]].visible = true;
				Icons[Lines[LineNow].IconNum[i]].x = 20;
			}
			if( Lines[LineNow].Parent != -1 ){
				Icons[0].visible = true;
				Icons[0].x = 20;
			}
		}
		
		//
		public function eF():int{
			//アニメーションさせる
			for( var i:int=0 ; i<Lines[LineNow].IconNum.length ; i++ ){
				Icons[Lines[LineNow].IconNum[i]].x += (40*i + 60 - Icons[Lines[LineNow].IconNum[i]].x) * 0.8;
			}
			if( Lines[LineNow].Parent != -1 ){
				Icons[0].x += (40*Lines[LineNow].IconNum.length + 60 - Icons[0].x) * 0.8;
			}
			var clicked:int = -1;
			//ボタンの反応を取る
			for( var i:int=0 ; i<Lines[LineNow].IconNum.length ; i++ ){
				if( Icons[Lines[LineNow].IconNum[i]].Clicked() ){
					if( Lines[LineNow].Children[i] != -1 ){
						LineNow = Lines[LineNow].Children[i];
						Disp();
					}
					clicked = i+1;
				}
			}
			if( Lines[LineNow].Parent != -1 ){
				if( Icons[0].Clicked() ){
					LineNow = Lines[LineNow].Parent;
					Disp();
					clicked = 0;
				}
			}
			return clicked;
		}
		
		//マウスオンになっているアイコン番号を返す
		public function On():int{
			for( var i:int=0 ; i<Lines[LineNow].IconNum.length ; i++ ){
				if( Icons[Lines[LineNow].IconNum[i]].On ){
					return i+1;
				}
			}
			if( Lines[LineNow].Parent != -1 ){
				if( Icons[0].On ){
					return 0;
				}
			}
			return -1;
		}
	}
}