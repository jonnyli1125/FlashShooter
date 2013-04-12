package  {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.*;
	
	public class Enemy extends MovieClip {
		public static var TotalCount:int = 0;
		public static var Killed:uint = 0;
		public var Velocity:int;
		public var Player:MovieClip;
		public var _Stage:Stage;
		
		public function Enemy(velocity:int, player:MovieClip, _start:Point, _stage:Stage) {
			if (Utils.gameOver == true) return;
			Velocity = velocity;
			Player = player;
			x = _start.x;
			y = _start.y;
			alpha = 1;
			_Stage = _stage;
			_Stage.addChild(this);
			TotalCount++;
		}
		
		private function _move(e:Event):void {
			if (Utils.gameOver) { die(false); return; }
			if (!Utils.gamePaused) {
				var angle:Number = Math.atan2(Player.y - y, Player.x - x);
				y += Math.sin(angle) * Velocity;
				x += Math.cos(angle) * Velocity;
			}
		}
		
		public function go():void {
			addEventListener(Event.ENTER_FRAME, _move);
		}
		
		public function die(spawnMore:Boolean = true):void {
			if (spawnMore && (TotalCount < 10 || Utils.randomInt(0, 4) >= (TotalCount > 400 ? 3 : 1))) {
				for (var i:int = 0; i < 2; i++) {
					setTimeout(function() {
						var xx = Math.round(Math.random()) == 1;
						new Enemy(Velocity, Player, new Point(xx ? (Math.round(Math.random()) == 1 ? _Stage.stageWidth : 0) : Math.random() * _Stage.stageWidth, xx ? Math.random() * _Stage.stageHeight : (Math.round(Math.random()) == 1 ? _Stage.stageHeight : 0)), _Stage).go();
					}, 40 * TotalCount);
				}
			}
			removeEventListener(Event.ENTER_FRAME, _move);
			if (_Stage != null) _Stage.removeChild(this);
			if (!Utils.gameOver) {
				TotalCount--;
				Killed++;
			}
		}
	}
	
}
