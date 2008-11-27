package net.isurvey.model{
	import flash.utils.ByteArray;
	import mx.collections.ArrayCollection;
	
	public class ProblemData
	{
		public var description:String;
		//option 包括optionname & pollcount
		public var optionlist:ArrayCollection;
		
		
		public function ProblemData( /* des:String, list:ArrayCollection */){
/* 			description = des;
			optionlist = list; */
			optionlist = new ArrayCollection;
		}
		
		public function parseData( result:*):void{
			description = result.description as String;
			//这其实是个Option的List
			optionlist  = result.optionlist as ArrayCollection;
		}
		
		public static function clone(obj:Object):* {
            var copier:ByteArray = new ByteArray();
            copier.writeObject(obj);
            copier.position = 0;
            return copier.readObject();
		}

	}
}