package Maps{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class MapSkinLib{
		
		public function MapSkinLib(){
		}
		
		public function retMap( num:int ){
			var MapTip:BitmapData;
			switch( num ){
				case  1:	MapTip = new Map_01(0, 0);	break;
				case  2:	MapTip = new Map_02(0, 0);	break;
				case  3:	MapTip = new Map_03(0, 0);	break;
				case  4:	MapTip = new Map_04(0, 0);	break;
				case  5:	MapTip = new Map_05(0, 0);	break;
				case  6:	MapTip = new Map_06(0, 0);	break;
				case  7:	MapTip = new Map_07(0, 0);	break;
				case  8:	MapTip = new Map_08(0, 0);	break;
				case  9:	MapTip = new Map_09(0, 0);	break;
				case 10:	MapTip = new Map_10(0, 0);	break;
				case 11:	MapTip = new Map_11(0, 0);	break;
				case 12:	MapTip = new Map_12(0, 0);	break;
				case 13:	MapTip = new Map_13(0, 0);	break;
				case 14:	MapTip = new Map_14(0, 0);	break;
				case 15:	MapTip = new Map_15(0, 0);	break;
				case 16:	MapTip = new Map_16(0, 0);	break;
				case 17:	MapTip = new Map_17(0, 0);	break;
				case 18:	MapTip = new Map_18(0, 0);	break;
				case 19:	MapTip = new Map_19(0, 0);	break;
				case 20:	MapTip = new Map_20(0, 0);	break;
				case 21:	MapTip = new Map_21(0, 0);	break;
			}
			var map:Bitmap = new Bitmap( MapTip );
			if( num >= 5 && num <= 12 ){
				map.smoothing = true;
			}
			return map;
		}
	}
}