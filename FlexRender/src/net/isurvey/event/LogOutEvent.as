package net.isurvey.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;
	
	public class LogOutEvent extends CairngormEvent{
		
		public static const LOGOUT:String = "logout";
		
		public function LogOutEvent() {
			super( LOGOUT );
			
		}
		
		override public function clone():Event{
			return new LogOutEvent();
		}

	}
}