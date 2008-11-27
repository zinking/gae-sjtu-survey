package net.isurvey.business
{
	import mx.rpc.IResponder;
	import com.adobe.cairngorm.business.ServiceLocator;
	import mx.rpc.events.*;
	import net.isurvey.model.*;

	
	
	public class UserDelegate{

		
		public function UserDelegate( responder : IResponder ){
	      this.service = ServiceLocator.getInstance().getRemoteObject( "userGateway" );
	      this.responder = responder;			
		}
		
	   public function validateUser( usr:UserData ) : void
	   {  
		   var call : Object = service.userAuthenticate( usr );
			call.addResponder( responder );
	   }
	   
	
	   private var responder : IResponder;
	   private var service : Object;		

	}
}