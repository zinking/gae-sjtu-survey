package net.isurvey.event
{

	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;
	import net.isurvey.model.*;

	public class LoginEvent extends CairngormEvent{
		public static const LOGIN:String = "login";
		public var user:UserData;
		
		public function LoginEvent( usr:UserData ){
			user = usr;
			super(LOGIN);
		}
		
		override public function clone():Event{
			return new LoginEvent(user);
		}

	}
}