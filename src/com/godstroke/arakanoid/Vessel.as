package com.godstroke.arakanoid
{
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;
	
	import flash.geom.Point;
	import flash.utils.setTimeout;

	public class Vessel extends FlxSprite
	{
		[Embed(source="../../../data/vessel.png")] private var _vessel:Class;
		
		
		private var _lives:Number = 5;
		
		public function Vessel()
		{
			super(_vessel, 0, 0,true,false,80,10);
		
			// bounding box
			width = 80;
			height = 10;
			
			//physics
			var runspeed:uint = 220;
			drag.x = runspeed*8;
			acceleration.y = 0;
			maxVelocity.x = runspeed;
			maxVelocity.y = 0;
			
			//animations
			addAnimation("idle", [0]);
			super.update();
		}
		
		public function get lives():Number{
			return _lives;
		}
		
		public function get center():Point{
			return new Point(this.x+this.width/2,this.y+this.height/2);
		}
		
		public function loseLife():void{
			_lives-=1;
			
			if(_lives<=0){
				setTimeout(function():void{PlayState(FlxG.state).onGameOver();},2500);
			}
			else
			setTimeout(function():void{PlayState(FlxG.state).continueGame();},2000);
		}
		
		override public function update():void{
			var wallHit:Boolean = false;
			
			//wall check
			if(x<18){
				acceleration.x = 0;
				velocity.x = 0;
				//acceleration.x += drag.x;
				x = 18;
				wallHit = true;
			}else if(x+width>FlxG.width-18){
				acceleration.x = 0;
				velocity.x = 0;
				//acceleration.x -= drag.x;
				x = FlxG.width-width-18;
				wallHit = true;
			}
			
			
			//movement
			if(!wallHit){
				acceleration.x = 0;
				if(FlxG.kLeft){
					acceleration.x -= drag.x;
				}
				else if(FlxG.kRight){
					acceleration.x += drag.x;
				}	
			}
			
			super.update();
			
		}
	}
}