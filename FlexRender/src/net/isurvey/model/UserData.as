package net.isurvey.model
{
	public class UserData extends Object
	{
		public var name:String;
		public var password:String;
		public var type:int;
		
		public static const ANONYMOUS:int = 1;
		public static const ADMIN:int = 2;
		public static const USER:int = 3;
		
		public function UserData(){
/* 			name = "hello";
			password = "world"; */
		}
		
		public function parseData( result:*):void{
			name = result.name as String;
			password = result.password as String;
		}

	}
}