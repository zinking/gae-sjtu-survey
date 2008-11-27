package net.isurvey.model{
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	public class QuestionData
	{
		public var description:String;
		//option 包括optionname & pollcount
		public var optionlist:ArrayCollection;
		
		
		public function QuestionData( /* des:String, list:ArrayCollection */){
/* 			description = des;
			optionlist = list; */
			optionlist = new ArrayCollection;
		}
		
		public function parseData( result:*):void{
			description = result.description as String;
			//这其实是个Option的List
			optionlist  = new ArrayCollection(result.optionlist) ;
		}
		
		public static function clone(obj:Object):* {
            var copier:ByteArray = new ByteArray();
            copier.writeObject(obj);
            copier.position = 0;
            return copier.readObject();
		}

	}
}