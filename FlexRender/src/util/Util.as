package util
{
	public class Util
	{
		public function Util()
		{
		}
		
		public static function equalDate( d1:Date,d2:Date ):Boolean{
			if ( d1 == null || d2 == null ) return false;
			if ( d1.getFullYear ()!= d2.getFullYear()  ) return false;
			if ( d1.getMonth() != d2.getMonth() ) return false;
			if ( d1.getDate() != d2.getDay() ) return false;
			return true;	
		}

	}
}