package BattleSet{
	import flash.display.Sprite;
	
	public class Reticle extends Sprite{
		
		public var mc_Radius:Sprite = new Reticle_Radius();
		public var mc_Side1:Sprite = new Reticle_Side();
		public var mc_Side2:Sprite = new Reticle_Side();
		public var mc_Vector:Sprite = new Reticle_Vector();
		public var mc_Rock_00:Array = new Array();
		public var Rock_00_Use:Array = new Array();
		
		private var Target:Array = new Array();
		
		public var Use:Boolean;
		
		public var Drec:int;
		
		private var Wide:int;
		
		//初期化
		public function Reticle(){
			this.addChild( mc_Radius );
			mc_Radius.alpha = 0.3;
			this.addChild( mc_Side1 );
			mc_Side1.alpha = 0.3;
			this.addChild( mc_Side2 );
			mc_Side2.alpha = 0.3;
			this.addChild( mc_Vector );
			
			Use = false;
		}
		
		//ロックオン表示の初期化
		public function RockInit( target:Array ){
			Target = target;
			
			var i:int;
			for(i=0 ; i<Target.length ; i++){
				mc_Rock_00[i] = new Rock_00();
				this.addChild( mc_Rock_00[i] );
				mc_Rock_00[i].alpha = 0.5;
				mc_Rock_00[i].visible = false;
				Rock_00_Use[i] = false;
			}
		}
		
		//
		public function Reset(){
			var i:int;
			for(i=0 ; i<Target.length ; i++){
				mc_Rock_00[i].visible = false;
			}
		}
		
		//ロックオン範囲の変更
		public function SetSize( radius:int , wide:int ){
			mc_Radius.scaleX = (int)(radius / 50);
			mc_Radius.scaleY = (int)(radius / 50);
			mc_Side1.scaleX = (int)(radius / 50);
			mc_Side2.scaleX = (int)(radius / 50);
			
			Wide = wide;
			mc_Side1.rotation = Wide;
			mc_Side2.rotation = -Wide;
			
			var e_radius = radius;
			if( e_radius < Utils.Width/2 ){
				e_radius = Utils.Width/2;
			}else if( e_radius > Utils.Width*0.9 ){
				e_radius = Utils.Width*0.9;
			}
			for( i=0 ; i<Target.length ; i++){
				mc_Rock_00[i].scaleX = (int)(e_radius / 120);
				mc_Rock_00[i].scaleY = (int)(e_radius / 120);
			}
		}
		
		//ロックオン角の変更
		public function SetDrec( drec:int ){
			Drec = drec;
			mc_Side1.rotation = Drec + Wide;
			mc_Side2.rotation = Drec - Wide;
		}
		
		public function DispTarget( gap_x:Number , gap_y:Number ){
			for( i=0 ; i<Target.length ; i++){
				mc_Rock_00[i].x = Target[i].retX() + gap_x;
				mc_Rock_00[i].y = Target[i].retY() + gap_y;
				mc_Rock_00[i].visible = true;
				mc_Rock_00[i].alpha = 0.5;
				
				if( Target[i].Rocked ){
					mc_Rock_00[i].Rocked.visible = true;
					mc_Rock_00[i].Rocking.visible = false;
					mc_Rock_00[i].Insight.visible = false;
					mc_Rock_00[i].alpha = 0.8;
				}else if( Target[i].Time != -1 ){
					mc_Rock_00[i].Rocked.visible = false;
					mc_Rock_00[i].Rocking.visible = true;
					mc_Rock_00[i].Rocking.Circle.rotation += 10;
					mc_Rock_00[i].Insight.visible = false;
				}else if( Target[i].InSight ){
					mc_Rock_00[i].Rocked.visible = false;
					mc_Rock_00[i].Rocking.visible = false;
					mc_Rock_00[i].Insight.visible = true;
				}else{
					mc_Rock_00[i].visible = false;
				}
			}
		}
		
		//敵位置指定ベクトルの表示
		public function SetVector( drec:int , dist:Number ){
			mc_Vector.rotation = drec;
		}
	}
}