package Maps.Backs{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class BackSkinLib{
		
		public function BackSkinLib(){
		}
		
		public function retBack( num:int ){
			var backtip:BitmapData;
			switch( num ){
				case  1:
					backtip = new Back_01(202, 202);	break;
				case  2:
					backtip = new Back_02(202, 202);	break;
			}
			return backtip;
		}
	}
}