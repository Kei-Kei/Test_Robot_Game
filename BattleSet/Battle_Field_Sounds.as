//バトルフィールドのサウンド管理クラス
package BattleSet{
	import flash.media.*;
	
	public class Battle_Field_Sounds{
		private var Sounds:Array = new Array();
		private var Channels:Array = new Array();
		
		private var Sounds_Num:int = 3;
		
		private var Mode:Boolean;
		
		//初期化
		public function Battle_Field_Sounds(){
			Sounds[0] = new Sound_Bomb01();
			Sounds[1] = new Sound_Shot01();
			Sounds[2] = new Sound_Bomb02();
			
			var i:int;
			for(i=0 ; i<Sounds_Num ; i++){
				Channels[i] = new SoundChannel();
			}
			Mode = false;
		}
		
		//再生
		public function Play( type:int , vol:Number ){
			if( !Mode ){
				//Channels[type].stop();
				Channels[type] = Sounds[type].play();
				var soundx = new SoundTransform(vol , 0.0);
				Channels[type].soundTransform = soundx;
				Mode = true;
			}
		}
		
		public function eF_Sound(){
			Mode = false;
		}
	}
}