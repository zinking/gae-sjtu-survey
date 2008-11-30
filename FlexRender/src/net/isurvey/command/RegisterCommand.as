package net.isurvey.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.controls.Alert;
	import mx.modules.ModuleLoader;
	import mx.rpc.IResponder;
	import mx.rpc.events.*;
	
	import net.isurvey.business.UserDelegate;
	import net.isurvey.event.RegisterEvent;
	import net.isurvey.model.*;
	
	public class RegisterCommand implements ICommand, IResponder{
		private var user:UserData;
		
		private var mainLoader:ModuleLoader = 
				SurveyModelLocator.getInstance().mainloader;
		private var modelLocator:SurveyModelLocator =
				SurveyModelLocator.getInstance();
		
		public function RegisterCommand(){
		}
		
		public function execute( event : CairngormEvent ): void{
			var evt:RegisterEvent = event as RegisterEvent;
			user = evt.user;
			
			var delegate:UserDelegate = new UserDelegate(this);
			delegate.addUser( user );
		}
		
		public function result( event : Object ) : void{
			var evt:ResultEvent= event as ResultEvent;
			//var usr:* = evt.result.User ;
			
			if ( evt.result.AuthResult ){
				Alert.show("Register failed");
				return;
			}
			Alert.show("Register Successful");
			trace("Register Successful");
			modelLocator.user = user;
			loadMainFrame();
	   
		}
		
		public function fault( event : Object ) : void
		{
			var faultEvent : FaultEvent = FaultEvent( event );
			Alert.show( "Sever Cannot be achieved at the moment" );
			trace(faultEvent.fault.faultDetail);
			trace(faultEvent.fault.faultString);
		}

		private function loadMainFrame():void{
			mainLoader.unloadModule();
			mainLoader.url = SurveyModelLocator.MAINFRAME_MODULE;
			mainLoader.loadModule();
		}
	}
}