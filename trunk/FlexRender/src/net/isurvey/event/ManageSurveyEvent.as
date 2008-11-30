package net.isurvey.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import component.SurveyUI.Render.SurveyRender;
	
	import flash.events.Event;
	
	import net.isurvey.model.SurveyData;
	
	public class ManageSurveyEvent extends CairngormEvent{
		
		public static const MANAGESURVEY_EVENT:String = "managesurvey";
		
		public static const ADD_SURVEY:int = 100;
		public static const GET_SURVEY:int = 101;
		public static const DELETE_SURVEY:int = 102;
		public static const MODIFY_SURVEY:int = 103;
		public static const SEARCH_SURVEY:int = 104;
		
		public var surveytype:int 
		public var surveydata:SurveyData;
		public var surveyrender:SurveyRender;
		public var surveydescripton:String;
		
		public function ManageSurveyEvent( type:int ) {
			super( MANAGESURVEY_EVENT );	
			this.surveytype = type;
		}
		
		override public function clone():Event{
			return new ManageSurveyEvent( surveytype);
		}

	}
}