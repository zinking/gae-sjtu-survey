package net.isurvey.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.*;
	
	import net.isurvey.business.*;
	import net.isurvey.event.ManageSurveyEvent;
	import net.isurvey.model.*;
	
	public class ManageSurveyCommand implements ICommand, IResponder{
		private var survey:SurveyData;
		private var modelLocator:SurveyModelLocator =
				SurveyModelLocator.getInstance();
				
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
			}


		}
	
		public function result( event : Object ) : void{
			var evt:ResultEvent= event as ResultEvent;
			switch( currentevent.surveytype ){
				case ManageSurveyEvent.ADD_SURVEY:
					var r:Boolean = evt.result.AddResult;
					if ( r ) Alert.show("提交问卷成功");
					else Alert.show("问卷添加失败");
					break;	
				case ManageSurveyEvent.GET_SURVEY:
					var surveydata:SurveyData = new SurveyData();
					surveydata.parseData( evt.result.Survey );
					currentevent.surveyrender.renderSurvey( surveydata );
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