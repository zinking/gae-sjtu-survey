package net.isurvey.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.*;
	
	import net.isurvey.business.UserDelegate;
	import net.isurvey.event.RegisterEvent;
	import net.isurvey.model.*;
	
	public class RegisterCommand implements ICommand, IResponder{
		private var user:UserData;
		
		private var md:SurveyModelLocator;
		private var current_event:RegisterEvent;
		
		public function RegisterCommand(){
		}
		
		public function execute( event : CairngormEvent ): void{
			var evt:RegisterEvent = event as RegisterEvent;
			current_event = evt;
			user = evt.user;
			var delegate:UserDelegate = new UserDelegate(this);
			
			switch ( evt.register_type ){
				case RegisterEvent.CHECKUSER_AVAILBLE:
					delegate.checkUserAvailable( user.name );
				break;
				case RegisterEvent.REGISTER_USER:
					delegate.addUser( user );
				break;
			}
			
			
		}
		
		public function result( event : Object ) : void{
			var evt:ResultEvent= event as ResultEvent;
			
			
			switch ( current_event.register_type ){
				case RegisterEvent.CHECKUSER_AVAILBLE:
					if ( evt.result.HasUsername ){  
						current_event.register_module.setWarningInfo("该用户已经存在");
						current_event.register_module.isValidUsername = false;
					}
					else{
						current_event.register_module.setWarningInfo("用户名有效");
						current_event.register_module.isValidUsername = true;
					}
				break;
				
				case RegisterEvent.REGISTER_USER:
					if ( evt.result.AddResult ){
						Alert.show("注册成功，返回登陆界面");
						md = SurveyModelLocator.getInstance();
						md.mainframeLoad( SurveyModelLocator.LOGIN_MODULE );
					}
				break;
			}
	   
		}
		
		public function fault( event : Object ) : void
		{
			var faultEvent : FaultEvent = FaultEvent( event );
			Alert.show( "Sever Cannot be achieved at the moment" );
			trace(faultEvent.fault.faultDetail);
			trace(faultEvent.fault.faultString);
		}


	}
}