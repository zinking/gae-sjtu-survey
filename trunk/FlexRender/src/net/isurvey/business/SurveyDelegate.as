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
		
		public function getSurveyHistoryHeadList():void{
			var pagesize:int = modelLocator.pagesize;
			var offset:int = ( modelLocator.currentpagenumber-1 ) * pagesize;
			var username:String = modelLocator.user.name;	
			var call : Object = service.getUserHistorySurveyHeads( username,offset , pagesize);
			call.addResponder( responder );		
		}
		
		public function searchSurveyHeads( des:String ):void{
			var pagesize:int = modelLocator.pagesize;
			var offset:int = ( modelLocator.currentpagenumber-1 ) * pagesize;
			var call : Object = service.searchSurveyHeads( des, offset , pagesize);
			call.addResponder( responder );	
		}
		
		public function addSurvey( surveydata:SurveyData):void{
			var call:Object = service.addQuery( surveydata );
			call.addResponder( responder );
		}
		
		public function getSurvey( des:String ):void{
			var call:Object = service.getQuery( des );
			call.addResponder( responder );
		}
		
		public function deleteSurvey( des:String ):void{
			var call:Object = service.deleteSurvey( des );
			call.addResponder( responder );
		}
		public function updateVote( vd:SurveyData ):void{
			var username:String = modelLocator.user.name; 
			var call:Object = service.updateQueryVote( vd,username );
			call.addResponder( responder );
		}
		
		
		
	    private var responder : IResponder;
	    private var service : Object;		

	}
}