package Maps.Backs{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.*;
	import Backs.*;
	
	public class Back extends Sprite{

		private var BackSample:BitmapData;
		private var map_Back:Bitmap;
		
		private var Size_X:int,Size_Y:int;
		
		private const Sample_X:int=200,Sample_Y:int=200;
		
		public function Back(){
		}
		
		//初期化
		public function Init(){
			var i:int,j:int;
			
			var backlib:BackSkinLib = new BackSkinLib();
			BackSample = backlib.retBack( 2 );
			
			var x_Size:int = (int)(Utils.Width*2 / Sample_X)+2;
			var y_Size:int = (int)(Utils.Height*2 / Sample_Y)+2;

			try{
				var back:BitmapData = new BitmapData( x_Size * Sample_X , y_Size * Sample_Y , true , 0xFFFFFFFF);
			}catch( e:ArgumentError ){
				trace("Failed");
			}
			//背景を敷き詰める
			for(i=0 ; i<y_Size ; i++){
				for(j=0 ; j<x_Size ; j++){
					back.copyPixels( BackSample ,
									 new Rectangle( 0 , 0 , Sample_X , Sample_Y ),
									 new Point( j * Sample_X , i * Sample_Y ) );
				}
			}
			map_Back = new Bitmap( back );
			this.addChild( map_Back );
			
			Size_X = Math.floor( (map_Back.bitmapData.width/2)/200 )*200;
			Size_Y = Math.floor( (map_Back.bitmapData.height/2)/200 )*200;
		}
		
		//終了処理
		public function Close(){
			this.removeChild( map_Back );
			
		}
		
		//表示
		public function Disp( gap_x:int , gap_y:int ){
			map_Back.x = gap_x % Sample_X - Utils.Width;
			map_Back.y = gap_y % Sample_Y - Utils.Height;
		}
	}
}