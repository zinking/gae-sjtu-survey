package net.isurvey.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import component.SurveyUI.Render.SurveyRender;
	
	import flash.events.Event;
	
	import net.isurvey.model.SurveyData;
	
	public class ManageSurveyEvent extends CairngormEvent{
		
		public static const MANAGESURVEY_EVENT:String = "managesurvey";
		
		public static const ADD_SURVEY:int = 0;
		public static const GET_SURVEY:int = 1;
		
		public var surveytype:int 
		public var surveydata:SurveyData;
		public var surveyrender:SurveyRender;
		
		public function ManageSurveyEvent( type:int ) {
			super( MANAGESURVEY_EVENT );	
			this.surveytype = type;
		}
		
		override public function clone():Event{
			return new ManageSurveyEvent( surveytype);
		}

	}
}