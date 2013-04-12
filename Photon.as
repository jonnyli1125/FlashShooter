package  {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Photon extends MovieClip {
		public static var Bomb:Number = 0;
		private static var BombSize:Number = 0;
		public var Velocity:int;
		public var Angle:Number;
		public var _Stage:Stage;
		public var IsBomb:Boolean;
		
		public function Photon(velocity:int, angle:Number, _start:Point, _stage:Stage, isBomb:Boolean = false) {
			Velocity = velocity;
			Angle = angle;
			IsBomb = isBomb;
			x = _start.x;
			y = _start.y;
			alpha = 0.75;
			_Stage = _stage;
			_Stage.addChild(this);
		}
		
		private function _move(e:Event):void {
			if (IsBomb && Bomb > 0) {
				if (BombSize == 0) {
					BombSize = Bomb * 3;
					Bomb = 0;
				}
				if (width < BombSize) width += 3;
				if (height < BombSize) height += 3;
			}
			y -= Math.sin(Angle) * Velocity;
			x += Math.cos(Angle) * Velocity;
			for (var i:int = 0; i < stage.numChildren; i++) {
				var obj = stage.getChildAt(i);
				if (hitTestObject(obj)) {
					if (obj is Enemy) {
						(obj as Enemy).die();
						if (!IsBomb) Bomb += (Photon.Bomb < 100 ? 1 : 0.1);
					}
				}
			}
			if (Utils.gameOver || (((this.y <= 0 || this.x <= 0) || this.y >= _Stage.stageHeight) || this.x >= _Stage.stageWidth)) die();
		}
		
		public function shoot():void {
			addEventListener(Event.ENTER_FRAME, _move);
		}
		
		public function die() {
			if (IsBomb) BombSize = 0;
			removeEventListener(Event.ENTER_FRAME, _move);
			_Stage.removeChild(this);
		}
	}
	
}
