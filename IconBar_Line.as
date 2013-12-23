package{
	import flash.display.Sprite;
	
	public class IconBar_Line{
		public var Parent:int;
		public var MyIconNum:int;
		public var Children:Array = new Array();
		public var IconNum:Array = new Array();
		
		public function AddChild( child:int , iconnum:int ){
			Children[Children.length] = child;
			IconNum[IconNum.length] = iconnum;
		}
	}
}