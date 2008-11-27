package net.isurvey.model
{
	import mx.collections.ArrayCollection;
	
	public class SurveyData
	{
		public var createdate:Date;
		public var expiredate:Date;
		
		public var username:String;
		public var description:String;
		
		public var problemlist:ArrayCollection;
		
		public var pollcount:int;
		public var problemcount:int;
		
		
		public function SurveyData(){
			problemlist = new ArrayCollection();
		}
		
		public function parseData( result:*):void{
			description = result.description as String;
			createdate	= result.createdate;
			expiredate  = result.expiredate;
			username	= result.username;
			problemlist = result.problemlist;
			pollcount 	= result.pollcount;
			description	= result.description;
			problemcount = result.problemcount;
			
			problemlist = result.problemlist;
			
			/* var problemHash:* = result.problemlist as ArrayCollection;
			
			for each ( var item:* in problemHash ){
				var pbD:problemData = new problemData();
				problemlist.addItem( pbD.parseData( item ));
			} */
		}

	}
}