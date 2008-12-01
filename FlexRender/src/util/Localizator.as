package util {    
        
    import flash.events.EventDispatcher;    
    import flash.events.IEventDispatcher;    
    import flash.events.Event;    
    import mx.resources.ResourceBundle;    
        
    public class Localizator extends EventDispatcher {    
            
        //采用单例模式    
        private static var _instance : Localizator;    
            
        private var _language : String;    
            
        //这里的resource名应与.properties文件名相同    
        [ResourceBundle("en_US")]    
        private var lang_en_US:ResourceBundle;    
            
        [ResourceBundle("zh_CN")]    
        private var lang_zh_CN:ResourceBundle;    
            
        [Bindable]    
        private var currRes:ResourceBundle;    
            
        public function Localizator(language : String = "en_US") {    
            selectLanguage(language);    
        }    
            
        public static function getInstance(language : String = "en_US"):Localizator {    
            if (_instance == null) {    
                _instance = new Localizator(language);    
            }    
            return _instance;    
        }    
            
        private function selectLanguage(language : String):void {    
            this._language = language;    
                
            if (_language == "en_US") {    
                this.currRes = lang_en_US;    
            } else if (_language == "zh_CN") {    
                this.currRes = lang_zh_CN;    
            } else {    
                this.currRes = lang_en_US;    
            }    
        }    
            
        [Bindable(event="languageChange")]    
        public function getText(key:String):String {    
            return this.currRes.getString(key);   
        }    
            
        public function get language():String {    
            return this._language;    
        }    
            
        public function set language(language : String):void {    
            if (this._language != language) {    
                selectLanguage(language);    
                dispatchEvent(new Event("languageChange"));    
            }    
        }    
    }    
}