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
	import util.Localizator;   
	public class RegisterCommand implements ICommand, IResponder{
		private var user:UserData;
		[Bindable]   
       	private var localizator : Localizator = Localizator.getInstance(); 
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
				
				case RegisterEvent.GET_PASSWORD:
					var username:String = evt.user.name;
					delegate.sendPasswordEmail( username );
				break;
				
			}
			
			
		}
		
		public function result( event : Object ) : void{
			var evt:ResultEvent= event as ResultEvent;
			
			
			switch ( current_event.register_type ){
				case RegisterEvent.CHECKUSER_AVAILBLE:
					if ( evt.result.HasUsername ){  
						current_event.register_module.setWarningInfo(localizator.getText('register_command_alert_exist'));
						current_event.register_module.isValidUsername = false;
					}
					else{
						current_event.register_module.setWarningInfo(localizator.getText('register_command_alert_available'));
						current_event.register_module.isValidUsername = true;
					}
				break;
				
				case RegisterEvent.REGISTER_USER:
					if ( evt.result.AddResult ){
						Alert.show(localizator.getText('register_command_alert_registersu'));
						md = SurveyModelLocator.getInstance();
						md.mainframeLoad( SurveyModelLocator.LOGIN_MODULE );
					}
				break;
				
				case RegisterEvent.GET_PASSWORD:
					if ( evt.result.GetResult ){
						Alert.show(localizator.getText('register_command_alert_password'));
						current_event.forgetpassword.onGetSuccess();
					}
					else{
						Alert.show(localizator.getText('register_command_alert_check'));
					}
				break;
			}
	   
		}
		
		public function fault( event : Object ) : void
		{
			var faultEvent : FaultEvent = FaultEvent( event );
			Alert.show(localizator.getText('login_command_alert_server') );
			trace(faultEvent.fault.faultDetail);
			trace(faultEvent.fault.faultString);
		}


	}
}