package com.godstroke.arakanoid
{
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;
	
	import flash.geom.Point;

	public class CannonBall extends FlxSprite
	{
		[Embed(source="../../../data/cannonBall.png")] private var _canonBall:Class;
		[Embed(source="../../../data/arak_hitMetal.mp3")] private var snd_hitMetal:Class;
		[Embed(source="../../../data/arak_hitVessel.mp3")] private var snd_hitVessel:Class;
		public var docked:Boolean = true;
		public var _lives:Number = 1; // if powerup active, ball may re-enter the game 
		public var _lost:Boolean = false // vessel missed this ball
		private var _vessel:Vessel;
		
		private var _xdirection:Number = 0; // 0 , -1 , 1
		private var _ydirection:Number = 0;
		
		private var vesselReflectCounter:Number = 0;
		private var runSpeed:Number = 240;
		
		public function CannonBall(vessel:Vessel)
		{
			super(_canonBall, 0, 0,true, false, 10, 10);
			width = 10;
			height = 10;
			
			_vessel = vessel;
			
			//physics
			drag.x = runSpeed;
			drag.y = runSpeed;
			acceleration.y = 0;
			acceleration.x = 0;
			maxVelocity.x = runSpeed;
			maxVelocity.y = runSpeed;
			
			//animations
			addAnimation("normal",[0])
		}
		
		public function get center():Point{
			return new Point(this.x+this.width/2,this.y+this.height/2);
		}
		
		
		
		public function reflectFromVessel(dif:Number):void{
			FlxG.play(snd_hitVessel);
			
			// y
			_ydirection = -1;
			
			acceleration.y = -Math.abs(acceleration.y);
			velocity.y = acceleration.y;
			this.y = _vessel.y- this.height;

			if(dif==0){
				_xdirection = 0;
				acceleration.x = 0;
				return;
			}
			
			var perc:Number = dif/(_vessel.width/2)
			var newSpeed:Number = perc*(runSpeed);
			
			_xdirection = dif/Math.abs(dif) ;
			
			fixDrags(newSpeed) // drag.x adjusted, will be fixed when hits wall or ceiling
			
			acceleration.x = _xdirection*drag.x;
			velocity.x = acceleration.x;
			//trace(_xdirection);
		}
		
		private function fixDrags(newSpeed:Number):void{
			//drag.x = drag.y = Math.abs(newSpeed); // drag.x adjusted, will be fixed when hits wall or ceiling
			drag.x = Math.abs(newSpeed);
			//maxVelocity.x = maxVelocity.y = drag.x;
			maxVelocity.x = drag.x;
		}
		
		override public function update():void{
			if(dead)return;
			
			if(FlxG.kA){
				launch();
			}
			
			if(docked){
				//trace("docked");
				acceleration.y = 0;
				acceleration.x = 0;
				
				x = _vessel.x + _vessel.width/2 - width/2;
				y = _vessel.y - height;
				
				super.update();
				return;
			}else if(_lost){
				
				if(this.y > FlxG.height || this.x > FlxG.width || this.x < 0 ){
					this.dead = true;
					PlayState(FlxG.state).destroyCannonBall(this);
				}
				
				super.update();
				return;
			}
			else{
				
				if(this.y > _vessel.y || this.x > FlxG.width || this.x < 0){
					_lost = true; // vessel missed the ball
					//trace("lost");
					//_ydirection = 1;
					//acceleration.y = Math.abs(acceleration.y);
					
					super.update();
					return;
				}else{
					acceleration.x += _xdirection*drag.x;
					acceleration.y += _ydirection*drag.y;
					
					super.update();
					return;
				}
			}
		}
		
		override public function hitFloor():Boolean{
			fixDrags(runSpeed);
			return super.hitFloor();
		}
		
		override public function hitCeiling():Boolean{
			FlxG.play(snd_hitMetal);
			fixDrags(runSpeed);
			
			acceleration.y = Math.abs(acceleration.y);
			_ydirection = -1;
			this.y+=3
			return super.hitCeiling();
		}
		
		public function hitCeiling_Breakable():void{
			fixDrags(runSpeed);
			
			acceleration.y = Math.abs(acceleration.y);
			_ydirection = -1;
			this.y+=3
		}
		
		override public function hitWall():Boolean{
			FlxG.play(snd_hitMetal);
			fixDrags(runSpeed);
			
			velocity.x = 0;
			_xdirection = -_xdirection;
			acceleration.x = _xdirection*Math.abs(acceleration.x);
			
			return super.hitWall();
		}
		
		public function hitWall_Breakable(breakable:Breakable,fromLeft:Boolean):void{
			fixDrags(runSpeed);
			
			velocity.x = 0;
			_xdirection = (fromLeft? -1 : 1);
			acceleration.x = _xdirection*Math.abs(acceleration.x);
			
			if(fromLeft){
				x = breakable.x -this.width -1;
			}else{
				x = breakable.x + breakable.width +1;
			}
			
		}
		
		public function hitFloor_Breakable(breakable:Breakable):void{
			FlxG.play(snd_hitMetal);
			fixDrags(runSpeed);
			
			velocity.y = -Math.abs(velocity.y);
			acceleration.y = -Math.abs(acceleration.y);
			_ydirection = -1;
			this.y = breakable.y-this.height-1;
		}
		
		public function launch():void{
			if(!docked)return;
			docked = false;
			
			_xdirection = 0;
			_ydirection = -1;
		}
	}
}