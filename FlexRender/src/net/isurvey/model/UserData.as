package net.isurvey.model
{
	public class UserData extends Object
	{
		public var name:String;
		public var password:String;
		public var type:int;
		public var email:String;
		
		public static const ANONYMOUS:int = 1;
		public static const ADMIN:int = 2;
		public static const USER:int = 3;
		
		public function UserData(){
/* 			name = "hello";
			password = "world"; */
		}
		
		public static function getType( type:int ):String{
			switch( type ){
				case ANONYMOUS:
				return "Anonymous:";
				case ADMIN:
				return "Admin:";
				case USER:
				return "User:";
				default:
				trace("INVALID USER TYPE");
			}
			return "";
		}
		
		public function parseData( result:*):void{
			name = result.name as String;
			password = result.password as String;
			email = result.email as String;
		}

	}
}