package{
	import flash.display.Sprite;
	import PartsSkins.*;
	
	public class PartsSkinLib{
		
		public function PartsSkinLib(){
		}
		
		public function retSkin( num:int ){
			var mc_Skin:Sprite;
			switch( num ){
				case 1:		mc_Skin = new PartsSkin_01();	break;
				case 2:		mc_Skin = new PartsSkin_02();	break;
				case 3:		mc_Skin = new PartsSkin_03();	break;
				case 4:		mc_Skin = new PartsSkin_04();	break;
				case 5:		mc_Skin = new PartsSkin_05();	break;
				case 6:		mc_Skin = new PartsSkin_06();	break;
				case 7:		mc_Skin = new PartsSkin_07();	break;
				case 8:		mc_Skin = new PartsSkin_08();	break;
				case 9:		mc_Skin = new PartsSkin_09();	break;
				case 10:	mc_Skin = new PartsSkin_10();	break;
				case 11:	mc_Skin = new PartsSkin_011();	break;
				case 12:	mc_Skin = new PartsSkin_012();	break;
				case 13:	mc_Skin = new PartsSkin_013();	break;
				case 14:	mc_Skin = new PartsSkin_014();	break;
				case 15:	mc_Skin = new PartsSkin_015();	break;
			}
			return mc_Skin;
		}
	}
}