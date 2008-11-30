import pyamf
from pyamf.remoting.gateway.django import DjangoGateway
#from pyamf.remoting.gateway.google import WebAppGateway

from google.appengine.ext import db
from model.QueryModel import *;

try:
    pyamf.register_class( QueryModelMap,  'model.DataModelUtil.QueryModelMap');
    pyamf.register_class( ProblemModelMap,  'model.DataModelUtil.ProblemModelMap');
except ValueError:
    print "Classes already registered"

def addQuery(request,qdata):
    QueryPaper.submitQuery(qdata );
    
    return {
            "AddResult":True
            }
    
def getAllSurveyHead(request,offset,pagesize):
    
    headlist = QueryPaper.retrieveAllSurveyHead(pagesize,offset);
    headcount = db.Query( QueryPaper ).count();
    querycount = PAGE.getPageCount( headcount, pagesize );
    
    return {
            "HeadList":headlist,
            "Count":querycount
            }
    
def getQuery(request,querydescription):
    
    survey = QueryPaper.retrieveQuery( querydescription );  
    return{
           "Survey":survey
           }

def deleteSurvey( request,querydescription ):
    QueryPaper.deleteSurveyData( querydescription );
    return{
           "DeleteResult":True
           }

def updateQueryVote( request, qdata, username ):
    QueryPaper.updateQueryVote( qdata );
    newuserhistory = UserSurveyHistory( username = username, 
                                        surveydescription = qdata.description );
    newuserhistory.put();
    return{
           "UpdateResult":True
           }
    
    
def getUserHistorySurveyHeads( request, username, offset, pagesize ): 
    result = UserSurveyHistory.getUserSurvey(username, offset, pagesize );
    historylist = result["hlist"];
    headlist = QueryPaper.retrieveHistroySurveyHead( historylist );
    return {
            "HeadList":headlist,
            "Count":result["count"]
            }
    
def searchSurveyHeads( request, description_critia,offset, pagesize ):
    result = QueryPaper.searchSurvey( description_critia, pagesize, offset );
    return {
            "HeadList":result['slist'],
            "Count":result["count"]
            }
    
    
       
    
def getAllQuery(request,username): 
    userkey = User.getUser(username).key();
    Querys = QueryPaper.retrieveAllQuery();
    
    for i in range( len(Querys)):
        item = Querys[i];
        #item.hastaken = UserPollHistory.hasPollHistory(userkey, item.key() ); 
           
    return  {
             "Query":Querys,
             }
       

surveyGateway = DjangoGateway({
    'qSurvey.addQuery': addQuery,
    'qSurvey.getAllQuery':getAllQuery,
    'qSurvey.getAllSurveyHead':getAllSurveyHead,
    'qSurvey.getQuery':getQuery,
    'qSurvey.deleteSurvey':deleteSurvey,
    'qSurvey.updateQueryVote':updateQueryVote,
    'qSurvey.getUserHistorySurveyHeads':getUserHistorySurveyHeads,
    'qSurvey.searchSurveyHeads':searchSurveyHeads
})
