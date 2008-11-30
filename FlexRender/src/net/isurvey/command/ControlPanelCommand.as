package net.isurvey.command
{
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import component.SurveyUI.Module.*;
	import component.UserUI.ControlPanel;
	
	import mx.controls.*;
	import mx.modules.ModuleLoader;
	import mx.rpc.*;
	import mx.rpc.events.*;
	
	import net.isurvey.business.SurveyDelegate;
	import net.isurvey.event.ControlPanelEvent;
	import net.isurvey.model.SurveyModelLocator;

	/*FIEXED潜在的问题ADMIN在显示SURVEY与ADDSURVEY模块之间来回切换的时候，会造成数据加载时的空对象问题*/
	
	public class ControlPanelCommand implements ICommand,IResponder{

		private var currentEvent:ControlPanelEvent;
		private var md:SurveyModelLocator = SurveyModelLocator.getInstance();
		private var cpl:ControlPanel = md.controlpanel;
		
		
		//private var headloaded:Boolean = false;
		
		public function ControlPanelCommand(){
			
		}
		
		public function execute( event : CairngormEvent ): void{
			var evt:ControlPanelEvent = event as ControlPanelEvent;
			currentEvent = evt;
			var delegate:SurveyDelegate;
			cpl.enabled = false;
			delegate = new SurveyDelegate(this);
			
			switch( currentEvent.operation_type ){
				//对于有异步远程数据调用的事件在事件处理的时候必须屏蔽一些操作
				//防止，数据取回后已经切换到其他的控制面板
					case ControlPanelEvent.VIEW_SURVEY:
						delegate.getSurveyHeadList();
						md.currentpagemode = ControlPanelEvent.VIEW_SURVEY;
					break;
					
					case ControlPanelEvent.MANAGE_SURVEY:
						md.bodyframeLoad( SurveyModelLocator.MANAGESURVEY_MODULE );
						cpl.enabled = true;
					break;
					
					case ControlPanelEvent.PAGE_UPDATE:
						//delegate.getSurveyHeadList();提供对三种查看视图
						UpdateCorrespondingPage();	
					break;
					
					case ControlPanelEvent.VOTE_SURVEY:
						delegate.updateVote( md.surveyrendermodule.getCurrentVoteData() );
					break;
					
					case ControlPanelEvent.VIEW_HISTORY:
						delegate.getSurveyHistoryHeadList();
						md.currentpagemode = ControlPanelEvent.VIEW_SURVEY;
					break;
			}
			
			SurveyModelLocator.getInstance().controlpanel_status = evt.operation_type;
			md.controlpanel.switchAdminView( evt.operation_type );
					
		}
		
		public function UpdateCorrespondingPage():void{
			var delegate:SurveyDelegate = new SurveyDelegate(this);
			switch( md.currentpagemode ){
				case ControlPanelEvent.VIEW_SURVEY:
					delegate.getSurveyHeadList();
				break;
				
				case ControlPanelEvent.VIEW_HISTORY:
					delegate.getSurveyHistoryHeadList();
				break;
			}
		}
		

		
		public function result( event : Object ) : void{
			var evt:ResultEvent = event as ResultEvent;
			var headlist:*;
			switch( currentEvent.operation_type ){
					case ControlPanelEvent.VIEW_SURVEY:
						headlist = evt.result.HeadList;
						md.totalpagenumber = evt.result.Count;
						md.surveyheadlist = headlist;
						md.bodyframeLoad( SurveyModelLocator.VIEWSURVEY_MODULE );
					break;
					
					case ControlPanelEvent.PAGE_UPDATE:
						headlist = evt.result.HeadList;
						md.totalpagenumber = evt.result.Count;
						md.surveyheadlist = headlist;
						md.bodyframeLoad( SurveyModelLocator.VIEWSURVEY_MODULE );
					break;
					
					case ControlPanelEvent.VOTE_SURVEY:
						if ( evt.result.UpdateResult ) Alert.show("投票成功");
						//TODO:目前还处在测试投票系统是否正常工作的过程中，在实现了同一个用户不能两次投票之后就可以把下面这行去掉
						//因为控制面板规定不能重复发出的相同的命令
						currentEvent.operation_type = ControlPanelEvent.VIEW_SURVEY;
					break;
					
					case ControlPanelEvent.VIEW_HISTORY:
						headlist = evt.result.HeadList;
						md.totalpagenumber = evt.result.Count;
						md.surveyheadlist = headlist;
						md.bodyframeLoad( SurveyModelLocator.VIEWSURVEY_MODULE );
					break;
					
			}		
			md.controlpanel_status = currentEvent.operation_type;			
			cpl.enabled = true;
	   
		}
			
		public function fault( event : Object ) : void
		{
			var faultEvent : FaultEvent = FaultEvent( event );
			Alert.show( "在处理SURVEY信息的时候服务端发生了错误" );
			trace(faultEvent.fault.faultDetail);
			trace(faultEvent.fault.faultString);			
		}
		
		

	}
}