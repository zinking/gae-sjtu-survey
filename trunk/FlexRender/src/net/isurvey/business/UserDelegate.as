package net.isurvey.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.*;
	
	import net.isurvey.model.*;

	
	
	public class UserDelegate{

		
		public function UserDelegate( responder : IResponder ){
	      this.service = ServiceLocator.getInstance().getRemoteObject( "userGateway" );
	      this.responder = responder;			
		}
		
	   public function validateUser( usr:UserData ) : void
	   {  
		   	var call : Object ;
		   	if ( usr.type == UserData.USER ) call = service.userAuthenticate( usr );
		   	else call = service.adminAuthenticate( usr );
			call.addResponder( responder );
	   }
	   
	   public function checkUserAvailable( username:String ):void{
	   		var call : Object = service.checkUserAvailable( username );
			call.addResponder( responder );   	
	   }
	   
	   public function addUser( usr:UserData ) : void
	   {  
		   var call : Object = service.addUser( usr );
			call.addResponder( responder );
	   }
	   
	
	   private var responder : IResponder;
	   private var service : Object;		

	}
}