from google.appengine.ext import db
from model.DataModelUtil import *;

class User(db.Model):
    name = db.StringProperty(required = True);#UNIQUE
    password = db.StringProperty(default = "#123" );
    
    @staticmethod
    def getUser(name ):
         q = db.GqlQuery("SELECT * FROM User WHERE name = :1 ",
                    name );
         results = q.fetch(1);
         return results[0];
        
    
    @staticmethod
    def hasUser(name,password):
        q = db.GqlQuery("SELECT * FROM User WHERE name = :1 AND password = :2",
                    name, password );
        if ( q.count() > 0 ):
             return True;
        else:
            return False;
        
#--------------------------------------------------------------------------------------------    
#-------------------------------------------------------------------------------------------- 
#--------------------------------------------------------------------------------------------          

class QueryPaper(db.Model):
    description  = db.StringProperty( required = True);
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
    def retrieveAllSurveyHead(pagesize,offset):
        AllQuerys = QueryPaper.all();
        headlist = AllQuerys.fetch(pagesize,offset);
        return headlist;
        
    @staticmethod
    def retrieveAllQuery():
        AllQuerys = QueryPaper.all();
        #retrieve more than 20 records caused a timeout error
        #page system in need
        querylist = AllQuerys.fetch( 5 ,4 );#TODO:pagesystem
        
        # test--------------------
        query_model_list = [];
        # test--------------------
                    
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
        #q = db.GqlQuery("SELECT * FROM QueryPaper WHERE description = :1 ",
        #            des );  
        p = QueryPaper.all().fetch(5);
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
    description = db.StringProperty( required = True );
    querypaper = db.ReferenceProperty(QueryPaper, required = True);
    
    
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
    
    @staticmethod
    def retrieveOption( problemkey ):
        options = db.GqlQuery("SELECT * FROM ProblemOption WHERE queryproblem = :1 ",
                    problemkey );
        optionlist = options.fetch(options.count());
        return optionlist;

#--------------------------------------------------------------------------------------------    
#-------------------------------------------------------------------------------------------- 
#--------------------------------------------------------------------------------------------  

    
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
    
    