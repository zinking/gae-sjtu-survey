package net.isurvey.command
{
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import component.SurveyUI.Module.*;
	import component.UserUI.ControlPanel;
	
	import flash.events.Event;
	
	import mx.controls.*;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;
	import mx.rpc.*;
	import mx.rpc.events.*;
	
	import net.isurvey.business.SurveyDelegate;
	import net.isurvey.event.ControlPanelEvent;
	import net.isurvey.model.SurveyModelLocator;

	/*FIEXED潜在的问题ADMIN在显示SURVEY与ADDSURVEY模块之间来回切换的时候，会造成数据加载时的空对象问题*/
	
	public class ControlPanelCommand implements ICommand,IResponder{
		private var bodyLoader:ModuleLoader;
		private var currentEvent:ControlPanelEvent;
		private var mdLocator:SurveyModelLocator = SurveyModelLocator.getInstance();
		private var cpl:ControlPanel = mdLocator.controlpanel;
		
		
		private var headloaded:Boolean = false;
		
		public function ControlPanelCommand(){
			//初始化MODULE体装载函数
			bodyLoader = SurveyModelLocator.getInstance().bodyloader;
		}
		
		public function execute( event : CairngormEvent ): void{
			var evt:ControlPanelEvent = event as ControlPanelEvent;
			currentEvent = evt;
			var delegate:SurveyDelegate;
			switch( currentEvent.operation_type ){
				//对于有异步远程数据调用的事件在事件处理的时候必须屏蔽一些操作
				//防止，数据取回后已经切换到其他的控制面板
					case ControlPanelEvent.VIEW_SURVEY:
						loadModule( SurveyModelLocator.VIEWSURVEY_MODULE );
						delegate = new SurveyDelegate(this);
						cpl.enabled = false;//远程方法调用的时候禁止一切操作
						delegate.getSurveyHeadList();	
					break;
					
					case ControlPanelEvent.MANAGE_SURVEY:
						loadModule( SurveyModelLocator.MANAGESURVEY_MODULE );
					break;
					
					case ControlPanelEvent.PAGE_UPDATE:
						delegate = new SurveyDelegate(this);
						cpl.enabled = false;//远程方法调用的时候禁止一切操作
						delegate.getSurveyHeadList();	
					break;
			}
			SurveyModelLocator.getInstance().controlpanel_status = evt.operation_type;
			
					
		}
		private function onModuleLoadReady(event:Event):void{
			var srm:SurveyRenderModule; 
			srm = bodyLoader.child as SurveyRenderModule;
			srm.addEventListener(FlexEvent.CREATION_COMPLETE,onModuleLoadComplete);
		}
		private function onModuleLoadComplete( event:Event ):void{
			var srm:SurveyRenderModule; 
			srm = bodyLoader.child as SurveyRenderModule;
			srm.displayAllSurveyHeads(  );	
		}
		
		private function loadModule( moduleurl:String):void{
			
			bodyLoader.unloadModule();
			bodyLoader.url = moduleurl;
	 		bodyLoader.loadModule();
	 		this.headloaded = true;
	 		
		}
		
		public function result( event : Object ) : void{
			var evt:ResultEvent = event as ResultEvent;
			var headlist:*;
			bodyLoader.addEventListener( ModuleEvent.READY,onModuleLoadReady );
			//根据控制面板不同的子类事件对BODY模块进行处理
			switch( currentEvent.operation_type ){
					case ControlPanelEvent.VIEW_SURVEY:
						headlist = evt.result.HeadList;
						//设置总的页数
						mdLocator.totalpagenumber = evt.result.Count;
						mdLocator.surveyheadlist = headlist;
						//装载所有的SURVEY HEAD
						//srm = bodyLoader.child as SurveyRenderModule;
						//srm.surveyheadlist = headlist;
						//srm.displayAllSurveyHeads( headlist );
						
					break;
					
					case ControlPanelEvent.PAGE_UPDATE:
						headlist = evt.result.HeadList;
						//设置总的页数
						mdLocator.totalpagenumber = evt.result.Count;
						mdLocator.surveyheadlist = headlist;
						//装载所有的SURVEY HEAD
						//srm = bodyLoader.child as SurveyRenderModule;
						////srm.displayAllSurveyHeads( headlist );
						//srm.surveyheadlist = headlist;
					break;
					
			}	
			//这只能算是个TRICK来解决MODULE异步加载的问题
			if ( !this.headloaded ) {
				var srm:SurveyRenderModule;
				srm = bodyLoader.child as SurveyRenderModule;
				srm.surveyheadlist = headlist;
				srm.displayAllSurveyHeads(  );
			}
	
				
			cpl.enabled = true;
	   
		}
		
	
		public function fault( event : Object ) : void
		{
			var faultEvent : FaultEvent = FaultEvent( event );
			Alert.show( "Sever Cannot be achieved at the moment" );
			trace(faultEvent.fault.faultDetail);
			trace(faultEvent.fault.faultString);			
		}
		
		
	


	}
}