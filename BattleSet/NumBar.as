package BattleSet{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	public class NumBar extends Sprite{
		private var mc_Bar:Sprite = new NumBar_x();
		private var Speed:Number;
		
		public function NumBar( x:int , y:int , width:int , r:int,g:int,b:int , spd:Number ){
			this.addChild( mc_Bar );
			mc_Bar.x = x;
			mc_Bar.y = y;
			mc_Bar.Bar.scaleX = width / 100;
			
			var colx:ColorTransform = new ColorTransform(0.0, 0.0, 0.0, 1.0, r, g, b, 0);
			mc_Bar.Bar.In_1.transform.colorTransform = colx;
			mc_Bar.Bar.In_2.transform.colorTransform = colx;
			
			Speed = spd;
		}
		
		public function SetInner( per:Number ){
			mc_Bar.Bar.In_1.scaleX = per;
			mc_Bar.Bar.In_2.scaleX -= (mc_Bar.Bar.In_2.scaleX - mc_Bar.Bar.In_1.scaleX) * Speed;
		}
		
		public function SetText( text:String ){
			mc_Bar.Text.text = text;
		}
	}
}