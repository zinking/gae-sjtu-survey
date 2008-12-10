package net.isurvey.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	
	import component.SurveyUI.Module.ManageSurveyModule;
	import component.SurveyUI.Module.SurveyRenderModule;
	
	import mx.controls.Alert;
	import mx.modules.ModuleLoader;
	import mx.rpc.IResponder;
	import mx.rpc.events.*;
	
	import net.isurvey.business.*;
	import net.isurvey.event.ControlPanelEvent;
	import net.isurvey.event.ManageSurveyEvent;
	import net.isurvey.model.*;
	import util.Localizator;   
	public class ManageSurveyCommand implements ICommand, IResponder{
		private var survey:SurveyData;
		private var md:SurveyModelLocator = SurveyModelLocator.getInstance();
		private var bodyLoader:ModuleLoader = SurveyModelLocator.getInstance().bodyloader;
		[Bindable]   
       	private var localizator : Localizator = Localizator.getInstance(); 		
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
					delegate.getSurvey( currentevent.surveyrender.survey_description );
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
				case ManageSurveyEvent.CHECK_SURVEY:
					delegate.checkSurveyDescription( evt.surveydescripton );
					break;	
				case ManageSurveyEvent.DEFAULT_SURVEY:
					delegate.getDefaultSurvey();
					break;	
			}


		}
	
		public function result( event : Object ) : void{
			var evt:ResultEvent= event as ResultEvent;
			var r:Boolean;//Result
			var headlist:*;
			switch( currentevent.surveytype ){
				case ManageSurveyEvent.ADD_SURVEY:
					 r = evt.result.AddResult;
					if ( r ) Alert.show(localizator.getText('manage_command_alert_sec'));
					switch2ViewSurvey();
					break;	
				case ManageSurveyEvent.GET_SURVEY:
					var surveydata:SurveyData = new SurveyData();
					surveydata.parseData( evt.result.Survey );
					var hasvote:Boolean = evt.result.HasVoted;
					currentevent.surveyrender.renderSurvey( surveydata,hasvote );
					break;
				case ManageSurveyEvent.CHECK_SURVEY:
					var sr:ManageSurveyModule = md.managesurveymodule;
					if ( ! evt.result.Result ){//ALREADY EXITST
						sr.isDescritpionValid = false;
						sr.setInfo(localizator.getText('manage_command_alert_exist'));
					}
					else{
						sr.isDescritpionValid = true;
						sr.setInfo(localizator.getText('manage_command_alert_available'));
					}
					break;
					
				case ManageSurveyEvent.DELETE_SURVEY:
					 r = evt.result.DeleteResult;
					if( r ){
						md.surveyrendermodule.deleteSelectedSurvey();
						Alert.show(localizator.getText('manage_command_alert_delete'));
					}
					switch2ViewSurvey();
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
					if ( addresult ) Alert.show(localizator.getText('manage_command_alert_modify'));
					switch2ViewSurvey();
					break;	
					
				case ManageSurveyEvent.SEARCH_SURVEY:
					headlist = evt.result.HeadList;
					md.totalpagenumber = evt.result.Count;
					md.surveyheadlist = headlist;
					loadModule( SurveyModelLocator.VIEWSURVEY_MODULE );
					break;	
					
				case ManageSurveyEvent.DEFAULT_SURVEY:
					headlist = evt.result.HeadList;
					md.currentpagemode = ManageSurveyEvent.DEFAULT_SURVEY;
					md.totalpagenumber 		= 1;
					md.currentpagenumber 	= 1;
					md.surveyheadlist = headlist;
					loadModule( SurveyModelLocator.VIEWSURVEY_MODULE );
					break;				
			}
			md.controlpanel_status = currentevent.surveytype;
			md.controlpanel.switchAdminView( currentevent.surveytype );

		}
		

	
		public function fault( event : Object ) : void
		{
			var faultEvent : FaultEvent = FaultEvent( event );
			Alert.show( localizator.getText('manage_command_alert_error') );
			trace(faultEvent.fault.faultDetail);
			trace(faultEvent.fault.faultString);
		}
		
		
		private function loadModule( moduleurl:String):void{	
			bodyLoader.unloadModule();
			bodyLoader.url = moduleurl;
	 		bodyLoader.loadModule();	
		}
		
		private function switch2ViewSurvey():void{
			var evt:ControlPanelEvent = new ControlPanelEvent( ControlPanelEvent.VIEW_SURVEY);
			CairngormEventDispatcher.getInstance().dispatchEvent( evt );
		}

	}
}