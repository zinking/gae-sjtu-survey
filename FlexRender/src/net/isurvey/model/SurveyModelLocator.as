package net.isurvey.model
{
	import com.adobe.cairngorm.model.ModelLocator;
	
	import component.SurveyUI.Module.SurveyRenderModule;
	import component.UserUI.ControlPanel;
	
	import mx.modules.ModuleLoader;
	
	[Bindable]
	public class SurveyModelLocator implements ModelLocator{
		private static var modelLocator : SurveyModelLocator;
		
		public function SurveyModelLocator(){
			if ( modelLocator != null ){
         		throw new Error( "Only one SurveyModelLocator instance should be instantiated" );	
         		}
  		}
		
		public static function getInstance():SurveyModelLocator {
      		if ( modelLocator == null ){
      			modelLocator = new SurveyModelLocator();
      		}      		
      		return modelLocator;
      	}
      	
      	public function mainframeLoad( moduleurl:String ):void{
			mainloader.unloadModule();
			mainloader.url = moduleurl;
	 		mainloader.loadModule();
      	}
      	
      	public function bodyframeLoad( bodymoduleurl:String ):void{
      		bodyloader.unloadModule();
      		bodyloader.url = bodymoduleurl;
      		bodyloader.loadModule();
      	}
      	
      	
      	
      	
      	
      	
      	
      	public var user:UserData;
      	//public var
      	
      	
      	//主界面的数据
      	public var controlpanel_status:int;
      	public var pagesize:int = 4;
      	public var currentpagenumber:int = 1;
      	public var totalpagenumber:int 	 = 0;
      	
      	public var surveyheadlist:Array;
      	//public var updatesurveydata:SurveyData;
      	

      	public var search_survey_description:String;
      	public var currentpagemode:int;
      	

      	      	
      	//主界面APPLICATION的控制元素
      	public var mainloader:ModuleLoader;
      	public var bodyloader:ModuleLoader;
      	public var controlpanel:ControlPanel;
      	public var surveyrendermodule:SurveyRenderModule;
      	
      	
      	public static const min_descritpion_length:int = 1;
      	public static const max_description_length:int = 50;      	
      	     	
      	public static const LOGIN_MODULE:String 		= "component/UserUI/LoginModule.swf";
      	public static const MAINFRAME_MODULE:String 	= "component/SurveyUI/MainFrame.swf";
      	//public static const ADDSURVEY_MODULE:String 	= "component/SurveyUI/Addsurvey/AddSurveyUIModule.swf";
      	public static const VIEWSURVEY_MODULE:String 	= "component/SurveyUI/Module/SurveyRenderModule.swf";
      	public static const MANAGESURVEY_MODULE:String	= "component/SurveyUI/Module/ManageSurveyModule.swf";
      	public static const UPDATESURVEY_MODULE:String	= "component/SurveyUI/Module/UpdateSurveyModule.swf";
      	public static const REGISTERUSER_MODULE:String	= "component/UserUI/RegisterModule.swf";
		
	}
}