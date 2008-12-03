from google.appengine.ext import db
from model.DataModelUtil import *;

class User(db.Model):
    name = db.StringProperty(required = True);#UNIQUE
    password = db.StringProperty(default = "#123" );
    type = db.StringProperty(default = "USER" );
    
    @staticmethod
    def getUser(name ):
         q = db.GqlQuery("SELECT * FROM User WHERE name = :1 ",
                    name );
         results = q.fetch(1);
         return results[0];
     
     
    @staticmethod
    def submitUser( username,password ):
         newuser = User( name = username,
                         password = password );
         newuser.put();
         
    @staticmethod
    def hasUsername( username ):
        q = User.gql( "WHERE name = :1", username );
        
        return q.count() != 0;
           
    @staticmethod
    def hasUser(name,password):
        q = db.GqlQuery("SELECT * FROM User WHERE name = :1 AND password = :2",
                    name, password );
        if ( q.count() > 0 ):
             return {
                     'AuthResult':True,
                     'User':q.fetch(1)[0]
                     }
        else:
            return {
                     'AuthResult':False,
                     'User':''
                     }
        
    @staticmethod
    def hasAdmin(name,password):
        q = User.gql( "WHERE name = :1 AND password = :2 AND type = :3", 
                      name,password,'ADMIN' );
        if ( q.count() > 0 ):
            return {
                     'AuthResult':True,
                     'User':q.fetch(1)[0]
                     }
        else: 
            return {
                     'AuthResult':False,
                     'User':''
                     }
        
#--------------------------------------------------------------------------------------------    
#-------------------------------------------------------------------------------------------- 
#--------------------------------------------------------------------------------------------          

class QueryPaper(db.Model):
    description  = db.StringProperty( required = True);#Primary Key Unique
    problemcount = db.IntegerProperty ( required = True );
    pollcount    = db.IntegerProperty ( required = True );
    creator = db.ReferenceProperty(User, required = True );
    createtime = db.DateTimeProperty( required = True);
    expiretime = db.DateTimeProperty( required = True);
   
    
    @staticmethod
    def submitQuery( queryData ):
        newquery = QueryPaper( description = queryData.description,
                               problemcount = queryData.questioncount,
                               pollcount = queryData.pollcount ,
                               creator = User.getUser(queryData.username),
                               createtime = queryData.createdate,
                               expiretime = queryData.expiredate);
        newquery.put();
        
        for i in range(len( queryData.questionlist )) :
            problemData = queryData.questionlist[i];
            QueryProblem.submitProblem(problemData, newquery.key());

    @staticmethod
    def updateQueryVote( queryData):
        q = QueryPaper.gql("WHERE description = :1", queryData.description );
        results = q.fetch(1);
        updatequery = results[0];
        updatequery.pollcount = updatequery.pollcount + 1;
        updatequery.put();#UPDATE SURVEY POLLCOUNT
        for i in range(len( queryData.questionlist )) :
            problemData = queryData.questionlist[i];
            QueryProblem.updateProblemVote(problemData, updatequery.key());
    
    @staticmethod
    def deleteSurveyData( description ): 
        q = QueryPaper.gql("WHERE description = :1", description );
        deletequery = q.fetch(1)[0];#
        questiondeletequery = QueryProblem.gql("WHERE querypaper = :1", deletequery.key() );
        questioncount = questiondeletequery.count();
        questionlist = questiondeletequery.fetch( questioncount );
        for question in questionlist:
            optiondeletequery = ProblemOption.gql("WHERE queryproblem = :1", question.key() );
            optioncount = optiondeletequery.count();
            optionlist = optiondeletequery.fetch( optioncount );
            for option in optionlist:
                option.delete();
            question.delete();
        deletequery.delete();
               
            
    @staticmethod
    def retrieveAllSurveyHead(pagesize,offset):
        AllQuerys = QueryPaper.all();
        headlist = AllQuerys.fetch(pagesize,offset);
        return headlist;
    
    @staticmethod
    def searchSurvey(critia,pagesize,offset):
        AllQuerys = QueryPaper.all();
        headlist = AllQuerys.fetch( AllQuerys.count() );
        critifiedlist = [];
        for survey in headlist:
            if (survey.description.find( critia ) != -1 ):
                critifiedlist.append( survey );
        #put all searched survey into a list
        #implemented page mechannism for survey
        pagedlist = [];
        critified_len = len(critifiedlist)
        for i in range( pagesize ):
            if ( offset + i < critified_len ):
                pagedlist.append( critifiedlist[offset + i] );
                
        pagecount = PAGE.getPageCount( critified_len, pagesize );
        
        return {
                'slist':pagedlist,
                'count':pagecount
                }
                
                
    
    @staticmethod
    def retrieveHistroySurveyHead( descriptionlist ):
        historysurveylist = [];
        for i in range( len( descriptionlist )):
            des = descriptionlist[i];
            q = QueryPaper.gql("WHERE description = :1", des.surveydescription );
            if( q.count() == 0 ):
                continue;
            survey = q.fetch(1)[0];
            historysurveylist.append(survey);
        return historysurveylist;
        
    @staticmethod
    def retrieveAllQuery():
        AllQuerys = QueryPaper.all();
        #retrieve more than 20 records caused a timeout error
        #page system in need
        querylist = AllQuerys.fetch( 5 ,4 );#TODO:pagesystem
        
        query_model_list = [];                   
        for i in range( len( querylist )):
            item = querylist[i];
            item.problemlist = QueryProblem.retrieveProblem( item.key());
            item.username = item.creator.name;
            
            # test--------------------
            query_model_item = QueryModelMap.AssignDBQuery(item);
            query_model_list.append( query_model_item );
            # test--------------------
        
        #return querylist;
        return query_model_list;

    @staticmethod
    def retrieveQuery( des ):
        q = QueryPaper.gql("WHERE description = :1", des );
        results = q.fetch(1);
        query = results[0];
        query.problemlist = QueryProblem.retrieveProblem( query.key());
        query.username = query.creator.name;
        
        query_model = QueryModelMap.AssignDBQuery(query);
        
        return query_model;      
#--------------------------------------------------------------------------------------------    
#-------------------------------------------------------------------------------------------- 
#--------------------------------------------------------------------------------------------  


     
class QueryProblem(db.Model):
    description = db.StringProperty( required = True );#
    querypaper = db.ReferenceProperty(QueryPaper, required = True);#The two make up primary key
    
    
    @staticmethod
    def submitProblem( problemData, querykey):
        newproblem = QueryProblem( description = problemData.description,
                                   querypaper = querykey);
        newproblem.put();
        iterlist = range( len(problemData.optionlist))
        for i in  iterlist:
            optionData = problemData.optionlist[i];
            ProblemOption.submitOption(optionData, newproblem.key());
            
    @staticmethod
    def updateProblemVote( problemData, querykey):
        q = QueryProblem.gql("WHERE description = :1 AND querypaper = :2 "
                             ,problemData.description ,querykey );
        results = q.fetch(1);
        updateproblem = results[0];#GET THE PROBLEM KEY TO UPDATE THE PROBLEM
        iterlist = range( len(problemData.optionlist))
        for i in  iterlist:
            optionData = problemData.optionlist[i];
            ProblemOption.updateOptionVote(optionData, updateproblem.key());
            
    @staticmethod       
    def retrieveProblem( querykey ):
        problems = db.GqlQuery("SELECT * FROM QueryProblem WHERE querypaper = :1 ",
                    querykey );
        problemlist = problems.fetch(problems.count());
        
        # test--------------------
        problem_model_list = [];
        # test--------------------
        
        for i in range( len(problemlist)) :
            item = problemlist[i];
            item.optionlist = ProblemOption.retrieveOption(item.key());
            
            # test--------------------
            problem_model_item = ProblemModelMap.AssignDBProblem( item );
            problem_model_list.append( problem_model_item);
            # test--------------------
            
       # return problemlist;
        return problem_model_list;
            
   
#--------------------------------------------------------------------------------------------    
#-------------------------------------------------------------------------------------------- 
#--------------------------------------------------------------------------------------------          
    
class ProblemOption(db.Model):
    description = db.StringProperty(required = True );
    pollcount = db.IntegerProperty( required = True );
    queryproblem = db.ReferenceProperty(QueryProblem, required = True );
    
    @staticmethod
    def submitOption( optionData, problemkey ):
        newoption = ProblemOption( description = optionData.optionname,
                                   pollcount = optionData.pollcount,
                                   queryproblem = problemkey
                                  );
        newoption.put();
        
    @staticmethod#UPDATE ALL THE OPTION ITERATELY
    def updateOptionVote( optionData, problemkey ):
        q = ProblemOption.gql("WHERE description = :1 AND queryproblem = :2 "
                             ,optionData.description ,problemkey );
        results = q.fetch(1);
        updateoption = results[0];
        updateoption.pollcount = updateoption.pollcount + optionData.pollcount;
        updateoption.put();
        
    @staticmethod
    def retrieveOption( problemkey ):
        options = db.GqlQuery("SELECT * FROM ProblemOption WHERE queryproblem = :1 ",
                    problemkey );
        optionlist = options.fetch(options.count());
        return optionlist;

#--------------------------------------------------------------------------------------------    
#-------------------------------------------------------------------------------------------- 
#--------------------------------------------------------------------------------------------  
class UserSurveyHistory( db.Model ):
    username = db.StringProperty(required = True );
    surveydescription = db.StringProperty(required = True );
    
    @staticmethod
    def getUserSurvey( username, offset , pagesize ):
        q = UserSurveyHistory.gql("WHERE username = :1 ", username  ); 
        totalcount = q.count()/pagesize + 1;
        historylist = q.fetch(  pagesize , offset );
        pagecount = PAGE.getPageCount( totalcount, pagesize );
        return {
                "hlist":historylist,
                "count":pagecount
                }  
        
    @staticmethod
    def deleteHistory( surveydescription ):
        q = UserSurveyHistory.gql("WHERE surveydescription = :1 ", surveydescription  ); 
        historylist = q.fetch( q.count() );
        for histroy in historylist:
            histroy.delete();
        
        
class UserPollHistory( db.Model):
    user = db.ReferenceProperty( User, required = True );
    problem = db.ReferenceProperty( QueryPaper, required = True );
    @staticmethod
    def hasPollHistory( userkey,problemkey):
        q = db.GqlQuery("SELECT * FROM UserPollHistory WHERE user = :1 AND problem = :2",
                    userkey, problemkey );
        if ( q.count() > 0 ):
             return True;
        else:
            return False;        
        
class UserOptionHistory( db.Model):
    user = db.ReferenceProperty( User, required = True );
    option = db.ReferenceProperty( ProblemOption, required = True );
    @staticmethod
    def hasOtpionHistory( userkey,optionkey):
        q = db.GqlQuery("SELECT * FROM UserOptionHistory WHERE user = :1 AND option = :2",
                    userkey, optionkey );
        if ( q.count() > 0 ):
             return True;
        else:
            return False; 
    
    