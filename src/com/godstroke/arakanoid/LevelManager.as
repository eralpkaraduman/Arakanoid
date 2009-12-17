package com.godstroke.arakanoid
{
	import com.adamatomic.flixel.FlxArray;
	
	import flash.geom.Point;
	
	public class LevelManager
	{
		[Embed(source="../../../data/block_red.png")] protected var _red:Class;
		[Embed(source="../../../data/block_yellow.png")] protected var _yellow:Class;
		[Embed(source="../../../data/block_blue.png")] protected var _blue:Class;
		
		private var _level:Number = -1;
		private var _position:Point;
		private var _blockArray:FlxArray;
		
		private var _game:PlayState;
		private var level0:String = 
		"0000000000-"+
		"3333333333-"+
		"3333333333-"+
		"2222222222-"+
		"2222222222-"+
		"1111111111-"+
		"1111111111";
		
		private var level1:String = 
		"0010000100-"+
		"0002002000-"+
		"0033333300-"+
		"0110110110-"+
		"3333333333-"+
		"2022222202-"+
		"3030000303-"+
		"0001001000-"+
		"0000000000-"+
		"0000000000";
		
		private var level2:String = 
		"0000300000-"+
		"0022311000-"+
		"0223331100-"+
		"2233333110-"+
		"2233333110-"+
		"2233333110-"+
		"3030303030-"+
		"0000200000-"+
		"0000200000-"+
		"0000200000-"+
		"0010100000-"+
		"0011100000-"+
		"0001000000";
		
		private var level3:String = 
		"1010101010-"+
		"0202020202-"+
		"3030303030-"+
		"0202020202-"+
		"1010101010-"+
		"0202020202-"+
		"3030303030-"+
		"0202020202-"+
		"3030303030-"+
		"0202020202-"+
		"1010101010-"+
		"0202020202";
		
		private var hiLevel:String = 
		"0000000000-"+
		"0200000001-"+
		"0300000002-"+
		"0200000303-"+
		"0300000001-"+
		"0101001203-"+
		"0230300301-"+
		"0200100102-"+
		"0300200300-"+
		"0100100203";
		
		private var testLevel:String = 
		"0000000000-"+
		"0000000000-"+
		"0000000000-"+
		"0000000000-"+
		"0000000000-"+
		"0000000000-"+
		"0000000000-"+
		"0001000000-"+
		"0000000000-"+
		"0000000000";
		
		private var levelArray:FlxArray;
		
		public function LevelManager(game:PlayState,position:Point)
		{
			levelArray = new FlxArray();
			//levelArray.add(testLevel);
			
			levelArray.add(hiLevel);
			levelArray.add(level0);
			levelArray.add(level1);
			levelArray.add(level2);
			levelArray.add(level2);
			
			_game = game;
			_position = position;
			_blockArray = new FlxArray();
			
		}
		
		public function makeNextLevel():void{
			_level++;
			if(_level>=levelArray.length){
				//_game.gameFinished();
				//return;
				_level = 0;
			}
			_blockArray = buildLevel(levelArray[_level]);
		}
		
		public function killBlock(block:Breakable):void{
			_blockArray.remove(block,true);
			
			if(_blockArray.length<=0)_game.levelClear();
			//trace("_blockArray.length "+_blockArray.length);
		}
		
		public function get level():Number{
			return _level+1;
		}
		
		public function get array():FlxArray{
			return _blockArray;
		}
		
		
		protected function buildLevel(str:String):FlxArray{
			var _array:FlxArray = new FlxArray();
			var layerDelimiter:String = "-";
			var rows:Array = str.split(layerDelimiter);
			var yindex:Number = 0;
			var xindex:Number = 0;
			var margin:Number = 5;
			
			for each(var row:String in rows){
				var blocks:Array = row.split("");
				for each(var blockCode:String in blocks){
					//--
					var breakable:*;
					switch(blockCode){
						case "3": breakable=new Breakable(_red,1,0xDD3739,this); break;
						case "2": breakable=new Breakable(_yellow,1,0xF3CB14,this); break;
						case "1": breakable=new Breakable(_blue,1,0x64899B,this); break;
						default : breakable=null; break;
					}
					if(breakable){
						breakable.x = _position.x + xindex*(breakable.width+margin);
						breakable.y = _position.y + yindex*(breakable.height+margin);
						_game.add(breakable);
						_array.add(breakable);
					}
					xindex++;
				}
				xindex = 0;
				yindex++;
			}
			
			return _array;
		}

	}
}