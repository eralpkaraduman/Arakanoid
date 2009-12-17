package com.godstroke.arakanoid
{
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;
	
	import flash.geom.Point;

	public class Breakable extends FlxSprite
	{
		[Embed(source="../../../data/breakBlock_1.mp3")] private var snd_break_1:Class;
		[Embed(source="../../../data/breakBlock_2.mp3")] private var snd_break_2:Class;
		private var _color:Number;
		private var _lives:Number;
		private var _LevelManager:LevelManager;
		
		public function Breakable(graphic:Class,lives:Number,color:Number,levelManager:LevelManager)
		{
			_LevelManager = levelManager;
			_lives = lives;
			super(graphic,0,0,false,false,30,10);
		}
		
		public function get center():Point{
			return new Point(this.x+this.width/2,this.y+this.height/2);
		}
		
		public function hit():void{
			_lives--;
			
			if(_lives<=0){
				_LevelManager.killBlock(this);
				
				// random break sound.
				if(Math.round(Math.random()*1)==0){
					FlxG.play(snd_break_1);
				}else{
					FlxG.play(snd_break_2);
				}
				// make dead
				dead = true;
				visible = false;
			}
		}
		
	}
}