package net.isurvey.event
{

	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;
	import net.isurvey.model.*;

	public class RegisterEvent extends CairngormEvent{
		public static const REGISTER:String = "register";
		public var user:UserData;
		
		public function RegisterEvent( usr:UserData ){
			user = usr;
			super(REGISTER);
		}
		
		override public function clone():Event{
			return new RegisterEvent(user);
		}

	}
}