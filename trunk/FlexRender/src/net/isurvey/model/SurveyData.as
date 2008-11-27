package net.isurvey.model
{
	import mx.collections.ArrayCollection;
	
	public class SurveyData
	{
		public var createdate:Date;
		public var expiredate:Date;
		
		public var username:String;
		public var description:String;
		
		public var questionlist:ArrayCollection;
		
		public var questioncount:int;
		public var pollcount:int;
		
		
		public function SurveyData(){
			questionlist = new ArrayCollection();
		}
		
		public function parseData( result:*):void{
			description = result.description as String;
			createdate	= result.createdate;
			expiredate  = result.expiredate;
			username	= result.username;
			questionlist = new ArrayCollection( result.problemlist);
			questioncount 	= result.problemcount;
			description	= result.description;
			pollcount = result.pollcount;
			
			
			/* var problemHash:* = result.problemlist as ArrayCollection;
			
			for each ( var item:* in problemHash ){
				var pbD:problemData = new problemData();
				problemlist.addItem( pbD.parseData( item ));
			} */
		}

	}
}