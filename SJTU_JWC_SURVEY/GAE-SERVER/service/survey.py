import pyamf
from pyamf.remoting.gateway.django import DjangoGateway

from google.appengine.ext import db
from model.QueryModel import *;


def AddQuery(request,qdata):
    U = User(
    name        = qdata.username,
    classid     = qdata.classid,
    suggestion1 = qdata.suggestion1,
    suggestion2 = qdata.suggestion2,
    bachelor_start_year     = qdata.userinfo.startBYear,
    bachelor_last           = qdata.userinfo.lastBYear,
    bachelor_major          = qdata.userinfo.bMajor,
    graduate_start_year     = qdata.userinfo.startGYear,
    graduate_last           = qdata.userinfo.lastGYear,
    graduate_major          = qdata.userinfo.gMajor,
    has_foreign_study_exp   = qdata.userinfo.hasForeignStudy,
    foreign_start_year      = qdata.userinfo.adEduStartYear,
    foreign_last            = qdata.userinfo.adEduLast,
    foreign_school          = qdata.userinfo.adEduSchool,
    work_experience         = qdata.userinfo.experience,
    level                   = qdata.userinfo.level,
    duty                    = qdata.userinfo.duty
    );
    U.put();
    for i in range(len( qdata.selfevaluate )) :
         evluate_data = qdata.selfevaluate[i];
         if ( evluate_data.Importance=='' or
              evluate_data.SelfEvaluate=='' or
              evluate_data.AffectionSource=='' ):
             continue;
         E = EvaluationData(
                        id              = evluate_data.ID,
                        importance      = evluate_data.Importance,
                        selfevaluate    = evluate_data.SelfEvaluate,
                        creater         = U,
                        affectionsource = evluate_data.AffectionSource
                        );
         E.put();
         
    
    
    
    return {
            "AddResult":True
            }
            
            
def ViewSuggestions(request,index):
    suggestions = [];
    ulist = User.all().fetch(10);
    for i in range( len( ulist ) ):
        user = ulist[i];
        if ( index == 3 ):
            suggestions.append( user.suggestion1);
        if ( index == 2 ):
            suggestions.append( user.suggestion2);
        
    return {
            "Suggestions":suggestions
            }
    
    
    


    

    
    

surveyGateway = DjangoGateway({
    'qSurvey.AddQuery': AddQuery,
    'qSurvey.ViewSuggestions':ViewSuggestions,
})
