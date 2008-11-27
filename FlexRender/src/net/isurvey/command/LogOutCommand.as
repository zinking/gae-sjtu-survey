package net.isurvey.command
{
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.modules.ModuleLoader;
	import mx.rpc.IResponder;
	
	import net.isurvey.model.SurveyModelLocator;

	
	
	public class LogOutCommand implements ICommand{
		
		public function LogOutCommand(){}
		
		public function execute( event : CairngormEvent ): void{
			
			var mainLoader:ModuleLoader = SurveyModelLocator.getInstance().mainloader;
			mainLoader.unloadModule();
			mainLoader.url = SurveyModelLocator.LOGIN_MODULE;
			mainLoader.loadModule();			

		}
	}
}