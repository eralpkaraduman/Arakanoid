package {
	import com.adamatomic.flixel.FlxGame;
	import com.godstroke.arakanoid.MenuState;
	
	[SWF(width="410",height="478",backgroundColor="#201E11")]
	[Frame(factoryClass="Preloader")]

	public class Arakanoid extends FlxGame
	{
		public function Arakanoid()
		{
			
			super(410,480,MenuState,1,0xff201E11,true,0xffffffff);
			
			help("Fire", "Nothing", "Nothing","Move Vessel");
		}
	}
}
