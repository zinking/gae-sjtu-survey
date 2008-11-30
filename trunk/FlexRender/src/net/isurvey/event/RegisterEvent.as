package net.isurvey.event
{

	import com.adobe.cairngorm.control.CairngormEvent;
	import component.UserUI.RegisterModule;
	import flash.events.Event;
	import net.isurvey.model.*;
	

	public class RegisterEvent extends CairngormEvent{
		public static const REGISTER:String = "register";
		public static const CHECKUSER_AVAILBLE:int = 2;
    	public static const REGISTER_USER:int = 3;
    	
		public var user:UserData;
		public var register_type:int;
		public var register_module:RegisterModule;
		
		public function RegisterEvent( type:int/* usr:UserData */ ){
			register_type = type;
			super(REGISTER);
		}
		
		override public function clone():Event{
			return new RegisterEvent(register_type);
		}

	}
}