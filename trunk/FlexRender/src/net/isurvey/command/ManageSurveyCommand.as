package net.isurvey.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.controls.Alert;
	import mx.modules.ModuleLoader;
	import mx.rpc.IResponder;
	import mx.rpc.events.*;
	
	import net.isurvey.business.*;
	import net.isurvey.event.ManageSurveyEvent;
	import net.isurvey.model.*;
	
	public class ManageSurveyCommand implements ICommand, IResponder{
		private var survey:SurveyData;
		private var md:SurveyModelLocator = SurveyModelLocator.getInstance();
		private var bodyLoader:ModuleLoader = SurveyModelLocator.getInstance().bodyloader;
				
		private var currentevent:ManageSurveyEvent;
		
		public function ManageSurveyCommand(){
		}
		
		public function execute( event : CairngormEvent ): void{
			var evt:ManageSurveyEvent = event as ManageSurveyEvent;
			var delegate:SurveyDelegate = new SurveyDelegate(this);
			currentevent = evt;
			switch( evt.surveytype ){
				case ManageSurveyEvent.ADD_SURVEY:
					delegate.addSurvey( evt.surveydata );
					break;	
				case ManageSurveyEvent.GET_SURVEY:
					delegate.getSurvey( currentevent.surveyrender.label );
					break;	
					
				case ManageSurveyEvent.DELETE_SURVEY:
					var des:String = evt.surveydescripton;
					delegate.deleteSurvey( des );
					break;	
				
				case ManageSurveyEvent.MODIFY_SURVEY:
					delegate.deleteSurvey( evt.surveydata.description );
					break;	
					
				case ManageSurveyEvent.SEARCH_SURVEY:
					delegate.searchSurveyHeads( md.search_survey_description );
					break;		
			}


		}
	
		public function result( event : Object ) : void{
			var evt:ResultEvent= event as ResultEvent;
			var r:Boolean;//Result
			switch( currentevent.surveytype ){
				case ManageSurveyEvent.ADD_SURVEY:
					 r = evt.result.AddResult;
					if ( r ) Alert.show("提交问卷成功");
					break;	
				case ManageSurveyEvent.GET_SURVEY:
					var surveydata:SurveyData = new SurveyData();
					surveydata.parseData( evt.result.Survey );
					currentevent.surveyrender.renderSurvey( surveydata );
					break;
					
				case ManageSurveyEvent.DELETE_SURVEY:
					 r = evt.result.DeleteResult;
					if( r ){
						md.surveyrendermodule.deleteSelectedSurvey();
						Alert.show("删除成功");
					}
					break;	
				case ManageSurveyEvent.MODIFY_SURVEY:
					//先获得删除的结果
					var deleteresult:Boolean =  evt.result.DeleteResult;
					if ( deleteresult ){
						var delegate:SurveyDelegate = new SurveyDelegate(this);
						delegate.addSurvey( currentevent.surveydata );
						trace("modify half done: delete finished");
						return;
					}
					var addresult:Boolean =  evt.result.AddResult;
					if ( addresult ) Alert.show("修改问卷成功");
					break;	
					
				case ManageSurveyEvent.SEARCH_SURVEY:
					var headlist:* = evt.result.HeadList;
					md.totalpagenumber = evt.result.Count;
					md.surveyheadlist = headlist;
					loadModule( SurveyModelLocator.VIEWSURVEY_MODULE );
					break;				
			}

		}
		

	
		public function fault( event : Object ) : void
		{
			var faultEvent : FaultEvent = FaultEvent( event );
			Alert.show( "管理问卷时服务端出现错误。" );
			trace(faultEvent.fault.faultDetail);
			trace(faultEvent.fault.faultString);
		}
		
		
		private function loadModule( moduleurl:String):void{	
			bodyLoader.unloadModule();
			bodyLoader.url = moduleurl;
	 		bodyLoader.loadModule();	
		}

	}
}