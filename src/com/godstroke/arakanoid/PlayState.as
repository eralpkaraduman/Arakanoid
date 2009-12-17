package com.godstroke.arakanoid
{
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxBlock;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxState;
	import com.adamatomic.flixel.FlxText;
	
	import flash.geom.Point;
	

	public class PlayState extends FlxState
	{
		
		[Embed(source="../../../data/metalBlock.png")] private var _metalBlock:Class;
		[Embed(source="../../../data/gibs.png")] private var ImgGibs:Class;
		[Embed(source="../../../data/explosion_arak.mp3")] private var snd_explosion:Class;
		private var _vessel:Vessel;
		private var _cannonArray:FlxArray;
		private var levelManager:LevelManager;
		
		private var display_level:FlxText;
		
		
		private var _explosion:FlxEmitter;
		private var _boundingBoxes:FlxArray;
		
		public function PlayState()
		{
			super();
			
			//game objects
			
			//vessel
			_vessel = new Vessel();
			this.add(_vessel);
			vesselToCenter();
			_vessel.y = 425;
			
			//callons
			_cannonArray = new FlxArray();
			addCannonBall(true);
			
			_boundingBoxes = new FlxArray();
			makeBoundingBoxes();
			
			_explosion = add(new FlxEmitter(0,0,0,0,null,-1.5,-150,150,-200,0,-720,720,400,0,ImgGibs,60,true)) as FlxEmitter;
			
			// levels
			var levelPosition:Point = new Point();
			levelPosition.x = 32;
			levelPosition.y = levelPosition.x;
			levelManager = new LevelManager(this,levelPosition);
			
			levelManager.makeNextLevel(); // create level
			
			//display
			display_level = new FlxText(0,0,100,20,"LIVES: 3",0xFFFFFF,null,8);
			display_level.y = FlxG.height - display_level.height;
			display_level.x = 25;
			add(display_level);
			updateDisplay();
		}
		
		private function vesselToCenter():void{
			_vessel.x = FlxG.width/2 - _vessel.width/2;
		}
		
		private function updateDisplay():void{
			display_level.setText("lives: "+_vessel.lives);
		}
		
		private function makeBoundingBoxes():void{
			var margin:uint = 0;
			var overlap:Number = -2;
			var firstRowBoxCount:uint = 24;
			var columnCount:uint = 28;
			
			// first row
			
			var i:Number;
			for(i=0;i<firstRowBoxCount ; i++){
				//var metalBlock:FlxSprite = new FlxSprite(_metalBlock,0,0,false,false,15,15);
				var metalBlock:FlxBlock = new FlxBlock(0,0,19+overlap,19,_metalBlock);
				metalBlock.x = i*(metalBlock.width+margin+overlap)+margin;
				metalBlock.y = margin;
				add(metalBlock);
				_boundingBoxes.add(metalBlock);
			}
			
			for(i=0 ; i<columnCount-1 ; i++){
				var metalBlockLeft:FlxBlock = new FlxBlock(0,0,19,19+overlap,_metalBlock);
				var metalBlockRight:FlxBlock = new FlxBlock(0,0,19,19+overlap,_metalBlock);
				
				metalBlockLeft.x = margin;
				metalBlockRight.x = FlxG.width - margin - metalBlockRight.width;
				metalBlockLeft.y = metalBlockRight.y = i*(metalBlockLeft.height+margin+overlap)+margin + (metalBlockLeft.height + margin +overlap);
				
				add(metalBlockLeft);
				add(metalBlockRight);
				_boundingBoxes.add(metalBlockLeft);
				_boundingBoxes.add(metalBlockRight);
			}
		}
		
		private function addCannonBall(_docked:Boolean):CannonBall{
			var cb:CannonBall = new CannonBall(_vessel);
			cb.docked = _docked;
			add(cb);
			_cannonArray.add(cb);
			return cb;
		}
		
		public function continueGame():void{
			
			_vessel.visible = true;
			vesselToCenter();
			addCannonBall(true);
		}
		
		override public function update():void{
			//dockable
			super.update();
			FlxG.collideArrays(_boundingBoxes,_cannonArray);
			FlxG.overlapArrays(_cannonArray,levelManager.array,onCannonHitsBreakable);
			FlxG.overlapArray(_cannonArray,_vessel,onCannonsHitVessel);
		}
		
		private function onCannonHitsBreakable(can:CannonBall,brk:Breakable):void{
			var brkLeft:Number = brk.center.x - brk.width/2;
			var brkRight:Number = brk.center.x + brk.width/2;
			var brkTop:Number = brk.center.y - brk.height/2;
			var brkBottom:Number = brk.center.y + brk.height/2;
			
			var left:Boolean = false;
			var right:Boolean = false;
			
			var top:Boolean = false;
			var bottom:Boolean = false;
			
			if(can.center.x <= brkLeft)left=true;
			if(can.center.x > brkRight)right = true;
			
			if(can.center.y <= brk.y+brk.height)bottom = true;
			if(can.center.y > brk.y)top = true;
		
			if(!left && !right){ 
				if(!top && bottom){  //bottom
					can.hitFloor_Breakable(brk);
					brk.hit();
				}else if(top && !bottom){ //top
					can.hitCeiling_Breakable();
					brk.hit();
				}else{ // inside
					return;
				}
			}
			else{ // cannonball did hit sides of breakable
				can.hitWall_Breakable(brk,left);
				brk.hit();
			}
		}
		
		private function onCannonsHitVessel(can:CannonBall,ves:Vessel):void{
			var difX:Number = (can.center.x - ves.center.x);
			can.reflectFromVessel(difX);
		}
		
		public function onGameOver():void{
			FlxG.switchState(MenuState);
		}
		
		public function destroyCannonBall(can:CannonBall):void{
			can.visible = false;
			_cannonArray.remove(can,true);
			if(_cannonArray.length<=0){ // all cannonballs lost
				//quake
				FlxG.quake(0.005,0.35);
				// vessel explodes
				_explosion.x = _vessel.center.x;
				_explosion.y = _vessel.center.y;
				_vessel.visible = false;
				_explosion.reset();
				FlxG.play(snd_explosion);
				
				_vessel.loseLife();
				updateDisplay();
			}
		}
		
		public function levelClear():void{
			// win sound
			levelManager.makeNextLevel();
		}
		
	}
}