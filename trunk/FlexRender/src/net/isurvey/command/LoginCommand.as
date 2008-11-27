package net.isurvey.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.controls.Alert;
	import mx.modules.ModuleLoader;
	import mx.rpc.IResponder;
	import mx.rpc.events.*;
	
	import net.isurvey.business.UserDelegate;
	import net.isurvey.event.LoginEvent;
	import net.isurvey.model.*;
	
	public class LoginCommand implements ICommand, IResponder{
		private var user:UserData;
		
		private var mainLoader:ModuleLoader = 
				SurveyModelLocator.getInstance().mainloader;
		private var modelLocator:SurveyModelLocator =
				SurveyModelLocator.getInstance();
		
		public function LoginCommand(){
		}
		
		public function execute( event : CairngormEvent ): void{
			var evt:LoginEvent = event as LoginEvent;
			user = evt.user;
			if ( user.type == UserData.ANONYMOUS ){
				modelLocator.user = user;//保存匿名登录用户的数据到ML
				loadMainFrame();
				return;
			}
			
			var delegate:UserDelegate = new UserDelegate(this);
			delegate.validateUser( user );
		}
	
		public function result( event : Object ) : void{
			var evt:ResultEvent= event as ResultEvent;
			
			var usr:* = evt.result.User ;
			if ( !evt.result.AuthResult ){
				Alert.show("Login failed");
				return;
			}
			Alert.show("Login Successful");
			trace("Login Successful");
			modelLocator.user = user;
			loadMainFrame();
	   
		}
		
		private function loadMainFrame():void{
			mainLoader.unloadModule();
			mainLoader.url = SurveyModelLocator.MANAGESURVEY_MODULE;
			mainLoader.loadModule();
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