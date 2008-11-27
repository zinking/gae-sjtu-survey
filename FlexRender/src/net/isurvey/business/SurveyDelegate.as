package net.isurvey.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.*;
	
	import net.isurvey.model.*;
	
	
	public class SurveyDelegate{
		private var modelLocator:SurveyModelLocator = SurveyModelLocator.getInstance();
		
		public function SurveyDelegate( responder : IResponder ){
			this.service = ServiceLocator.getInstance().getRemoteObject( "surveyGateway" );
	      	this.responder = responder;	
		}
		
		public function getSurveyHeadList():void{
			var pagesize:int = modelLocator.pagesize;
			var offset:int = ( modelLocator.currentpagenumber-1 ) * pagesize;
			var call : Object = service.getAllSurveyHead( offset , pagesize);
			call.addResponder( responder );
		}
		
		
		
	    private var responder : IResponder;
	    private var service : Object;		

	}
}