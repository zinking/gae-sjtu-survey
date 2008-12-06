package net.isurvey.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.*;
	
	import net.isurvey.model.*;
	
	
	public class SurveyDelegate{
		private var md:SurveyModelLocator = SurveyModelLocator.getInstance();
		
		public function SurveyDelegate( responder : IResponder ){
			this.service = ServiceLocator.getInstance().getRemoteObject( "surveyGateway" );
	      	this.responder = responder;	
		}
		
		public function getDefaultSurvey():void{
			var call : Object = service.getDefaultSurvey( );
			call.addResponder( responder );
		}
		
		public function getSurveyHeadList():void{
			var pagesize:int = md.pagesize;
			var offset:int = ( md.currentpagenumber-1 ) * pagesize;
			var call : Object = service.getAllSurveyHead( offset , pagesize);
			call.addResponder( responder );
		}
		public function checkSurveyDescription( des:String ):void{
			var call : Object = service.checkSurveyDescription( des );
			call.addResponder( responder );
		}
		
		public function getSurveyHistoryHeadList():void{
			var pagesize:int = md.pagesize;
			var offset:int = ( md.currentpagenumber-1 ) * pagesize;
			var username:String = md.user.name;	
			var call : Object = service.getUserHistorySurveyHeads( username,offset , pagesize);
			call.addResponder( responder );		
		}
		
		public function searchSurveyHeads( des:String ):void{
			var pagesize:int = md.pagesize;
			var offset:int = ( md.currentpagenumber-1 ) * pagesize;
			var call : Object = service.searchSurveyHeads( des, offset , pagesize);
			call.addResponder( responder );	
		}
		
		public function addSurvey( surveydata:SurveyData):void{
			var call:Object = service.addQuery( surveydata );
			call.addResponder( responder );
		}
		
		public function getSurvey( des:String ):void{
			var usrname:String = md.user.name;
			var call:Object = service.getQuery( des , usrname );
			call.addResponder( responder );
		}
		
		public function deleteSurvey( des:String ):void{
			var call:Object = service.deleteSurvey( des );
			call.addResponder( responder );
		}
		public function updateVote( vd:SurveyData ):void{
			var username:String = md.user.name; 
			var call:Object = service.updateQueryVote( vd,username );
			call.addResponder( responder );
		}
		
		
		
	    private var responder : IResponder;
	    private var service : Object;		

	}
}