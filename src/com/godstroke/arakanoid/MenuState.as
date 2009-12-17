package com.godstroke.arakanoid
{
	import com.adamatomic.flixel.FlxButton;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;
	import com.adamatomic.flixel.FlxState;
	import com.adamatomic.flixel.FlxText;
	
	import flash.ui.Mouse;
	

	public class MenuState extends FlxState
	{
		[Embed(source="../../../data/cursor.png")] private var ImgCursor:Class;
		[Embed(source="../../../sounds/start_snd.mp3")] private var SndHit2:Class;
		
		protected var start_btn:FlxButton;
		
		public function MenuState()
		{
			/*
			graphics.lineStyle(0,0xFF0000,1);
			graphics.moveTo(FlxG.width/2,0);
			graphics.lineTo(FlxG.width/2,700);
			*/
			
			var game_title:FlxText = new FlxText(0,0,129,36,"ARAK",0xFFFFFF,null,40);
			var game_title_2:FlxText = new FlxText(0,0,116,40,"ANOID",0xFFFFFF,null,32);
			
			game_title.x = Math.round(FlxG.width/2 - game_title.width/2)+1;
			game_title.y = 100;
			add(game_title);
			
			game_title_2.x = Math.round(FlxG.width/2 - game_title_2.width/2);
			game_title_2.y = game_title.y + game_title.height+2 ;
			add(game_title_2);
			
			var versionNote:FlxText = new FlxText(0,0,105,36,"Version: Pre-Aplha 1",0xFFFFFF,null,8);
			versionNote.x = Math.round(FlxG.width/2 - versionNote.width/2);
			versionNote.y = game_title_2.y + game_title_2.height ;
			add(versionNote);
			
			var instructions:FlxText = new FlxText(0,0,250,100,"Press X to launch canonball\nLeft + Right to move vessel\n\nJust another Arkanoid Clone by Eralp Karaduman\nSound effects are created using SFXR\n\nThis game was built to try out Flixel Framework\nNow I'm sure to say IT ROCKS!",0xFFFFFF,null,8);
			instructions.x = Math.round(FlxG.width/2 - instructions.width/2);
			instructions.y = Math.round(versionNote.y + versionNote.height);
			add(instructions);
			
			// start button
			var b_f_size:Number=16;
			var b_height:Number= 25;
			var b_width:Number = 104;
			
			var btn_up:FlxSprite = new FlxSprite(null,0,0,false,false,b_width,b_height,0xff3a5c39);
			var btn_down:FlxSprite = new FlxSprite(null,0,0,false,false,b_width,b_height,0xff729954);
			var btn_txt:FlxText = new FlxText(0,1,b_width,b_height,"START",0x729954,null,b_f_size,"center");
			var btn_txt_down:FlxText = new FlxText(0,1,b_width,b_height,"START",0xd8eba2,null,b_f_size,"center");
			start_btn = new FlxButton(Math.round(FlxG.width/2-btn_up.width/2),game_title_2.y + game_title_2.height + 20,btn_up,onStart,btn_down,btn_txt,btn_txt_down);
			start_btn.y = instructions.y + instructions.height;
			//start_btn.x = FlxG.width/2 + start_btn.width/2;
			
			add(start_btn);
			flash.ui.Mouse.show();
			//FlxG.setCursor(ImgCursor);
		}
		
		
		
		
		private function onStart():void{
			start_btn.active = false;
			FlxG.play(SndHit2);
			
			FlxG.flash(0xff000000,0.5);
			FlxG.fade(0xff201E11,1,onFade);
		}
		
		private function onFade():void{
			trace("fade done");
			FlxG.switchState(PlayState);
		}
		
	}
}