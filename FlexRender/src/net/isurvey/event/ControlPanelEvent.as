package net.isurvey.event
{
	
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	import net.isurvey.model.*;

	public class ControlPanelEvent extends CairngormEvent{
		public static const CONTROL_PANEL:String = "control_panel";
    	public static const MANAGE_SURVEY:int = 2;
    	public static const VIEW_SURVEY:int = 3;
    	public static const PAGE_UPDATE:int = 4;
    	public static const VOTE_SURVEY:int = 5;
    	
		public var operation_type:int;
		
		public function ControlPanelEvent( optype:int ){
			operation_type 	= optype;
			super( CONTROL_PANEL );
		}
		
		override public function clone():Event{
			return new ControlPanelEvent(operation_type);
		}		

	}
}