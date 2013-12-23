package{
	
	public class Utils{
		public static var Height = 300;
		public static var Width = 480;
		
		//時間を整形する汎用関数
		public static function fixTime( time:int ):String{
			
			var min:int = (int)(time/60000);
			
			var sec:String;
			if( (time%60000)/1000 < 10 ) sec = "0" + (int)((time%60000)/1000);
			else sec = (int)((time%60000)/1000);
			
			var msec:String
			if( (time%1000) < 10 ) msec = "00" + (int)(time%1000);
			else if( (time%1000) < 100 ) msec = "0" + (int)(time%1000);
			else msec = (int)(time%1000);
			
			return min + ":" + sec + ":" + msec;
		}
		
		//int形をBoolean型にする汎用関数
		public static function itoB( a:int ):Boolean{
			if( a == 0 ) return false;
			else return true;
		}
		
		//角度を-180～180に収める
		public static function fixDrec( drec:int ):int{
			drec = drec%360;
			if( drec > 180 ){
				drec = -360 + drec;
			}else if( drec < -180 ){
				drec = 360 + drec;
			}
			
			return drec;
		}
		public static function fixDrec2( drec:Number ):Number{
			var drec2:Number = drec%(2*Math.PI);
			if( drec2 > Math.PI ){
				drec2 = -2*Math.PI + drec2;
			}else if( drec2 < -Math.PI ){
				drec2 = 2*Math.PI + drec2;
			}
			
			return drec2;
		}
		
		//左右方向による方向の変換（-180to180を-90to90に、その逆変換も可）
		public static function AdjustDrec( drec:int , drec_LR ):int{
			var ad_drec:int;
			if( drec_LR == 1 ){
				ad_drec = drec;
			}else{
				ad_drec = 180 - drec;
			}
			
			return fixDrec(ad_drec);
		}
		
		//座標変換（回転）
		public static function RotPosX( x:Number , y:Number , drec:int ):Number{
			var rad:Number = drec * Math.PI / 180;
			return x * Math.cos(rad) - y * Math.sin(rad);
		}
		public static function RotPosY( x:Number , y:Number , drec:int ):Number{
			var rad:Number = drec * Math.PI / 180;
			return x * Math.sin(rad) + y * Math.cos(rad);
		}
	}
}