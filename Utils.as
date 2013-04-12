package  {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class Utils {
		public var pressedKeys:Object = new Object();
		public var isMouseDown:Boolean = false;
		public var stage:Stage;
		public var firstStartup:Boolean = true;
		public var Player:MovieClip;
		public static var thisUtils:Utils = null;
		public static var gamePaused:Boolean = false;
		public static var gameOver:Boolean = false;
		public static var mouseAngle:Number = 0;
		
		public function Utils(stage:Stage) { this.stage = stage; thisUtils = this; }
		public static function getInstance(stage:Stage) { return thisUtils || new Utils(stage); }
		
		public function startKeyboard() {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keydown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyup);
			pressedKeys = new Object();
		}
		private function keydown(e:KeyboardEvent):void { pressedKeys[e.keyCode] = true; }
		private function keyup(e:KeyboardEvent):void { pressedKeys[e.keyCode] = false; }
		public function isKeyPressed(keyCode:uint) { return pressedKeys[keyCode] != null && pressedKeys[keyCode]; }
		public function stopKeyboard() {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keydown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyup);
			pressedKeys = new Object();
		}
		
		public function startMouse() {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mousedown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseup);
		}
		private function mousedown(e:MouseEvent):void { isMouseDown = true; }
		private function mouseup(e:MouseEvent):void { isMouseDown = false; }
		public function stopMouse() {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mousedown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseup);
		}
		
		public function setColor(object:DisplayObject, color:uint) {
			var c:ColorTransform = new ColorTransform();
			c.color = color;
			object.transform.colorTransform = c;
		}
		
		public function isMoving(direction:String) {
			switch (direction.toLowerCase()) {
				case "up": return isKeyPressed(Keyboard.W) || isKeyPressed(Keyboard.UP);
				case "down": return isKeyPressed(Keyboard.S) || isKeyPressed(Keyboard.DOWN);
				case "left": return isKeyPressed(Keyboard.A) || isKeyPressed(Keyboard.LEFT);
				case "right": return isKeyPressed(Keyboard.D) || isKeyPressed(Keyboard.RIGHT);
				default: return false;
			}
		}
		
		public function startGame(movement:Number, photonVelocity:int) {
			Enemy.TotalCount = 0;
			var counter:TextField = new TextField();
			counter.defaultTextFormat = new TextFormat("consolas", 18, 0xFFFFFF);
			counter.x = 0;
			counter.y = 0;
			counter.autoSize = TextFieldAutoSize.LEFT;
			counter.multiline = true;
			stage.addChild(counter);
			
			var info:TextField = new TextField();
			info.defaultTextFormat = new TextFormat("consolas", 18, 0xFFFFFF, null, null, null, null, null, "right");
			info.y = 0;
			info.autoSize = TextFieldAutoSize.LEFT;
			info.multiline = true;
			stage.addChild(info);
			
			function a(e:Event):void {
				counter.text = "Killed: " + Enemy.Killed + "\nAlive: " + Enemy.TotalCount + "\nBomb: " + Math.round(Photon.Bomb) + "%";
				info.text = "Shooter by Jonny Li <myself@jonny.li>\nSource: https://github.com/jonnyli1125/FlashShooter\n\n";
				if (!gameOver) info.appendText(gamePaused ? "Press P to return to game.\nUse WASD to move.\nHold MOUSE1 to shoot.\nRelease SPACE for bomb.\n\nDon't let enemies touch you.\nEnemies spawn as you kill them.\nKill to build bombs." : "Press P to pause and view help.");
				info.x = stage.stageWidth - info.width;
				if (!gameOver && !gamePaused) {
					if (isMoving("up")) Player.y = (Player.y <= 0 ? 0 : Player.y - movement);
					if (isMoving("down")) Player.y = (Player.y >= stage.stageHeight ? stage.stageHeight : Player.y + movement);
					if (isMoving("left")) Player.x = (Player.x <= 0 ? 0 : Player.x - movement);
					if (isMoving("right")) Player.x = (Player.x >= stage.stageWidth ? stage.stageWidth : Player.x + movement);
					
					mouseAngle = Math.atan2(-(stage.mouseY - Player.y), (stage.mouseX - Player.x));
					Player.rotation = -mouseAngle * 180 / Math.PI + 90;
					if (isMouseDown) new Photon(photonVelocity, mouseAngle, new Point(Player.x, Player.y), stage).shoot();
				}
			}
			function b(e:KeyboardEvent):void { if (e.keyCode == Keyboard.SPACE && Photon.Bomb > 0) new Photon(photonVelocity / 6, mouseAngle, new Point(Player.x, Player.y), stage, true).shoot(); }
			if (Player == null || gameOver) {
				stage.removeEventListener(Event.ENTER_FRAME, a);
				stage.removeEventListener(KeyboardEvent.KEY_UP, b);
				return;
			}
			stage.addEventListener(Event.ENTER_FRAME, a);
			stage.addEventListener(KeyboardEvent.KEY_UP, b);
		}
		
		public static function randomInt(minNum:int, maxNum:int) { return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum); }
	}
	
}
