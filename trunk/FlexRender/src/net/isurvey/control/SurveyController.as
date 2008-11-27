package net.isurvey.control
{
	import com.adobe.cairngorm.control.FrontController;
	import net.isurvey.event.*;
	import net.isurvey.command.*;
	
	
	public class SurveyController extends FrontController{
		public function SurveyController(){
			initialiseCommands();
		}
		
		public function initialiseCommands():void{
			addCommand( LogOutEvent.LOGOUT , LogOutCommand );
			addCommand( LoginEvent.LOGIN , LoginCommand );
			addCommand( ControlPanelEvent.CONTROL_PANEL , ControlPanelCommand);	
			addCommand( ManageSurveyEvent.MANAGESURVEY_EVENT , ManageSurveyCommand);	  
		}	
	}
}


	