from model.QueryModel import *;
from datetime import datetime;



class PAGE():
    @staticmethod
    def getPageCount( totalnumber, pagesize ):
        pagecount = 0;
        if ( totalnumber % pagesize == 0 ):
            pagecount = totalnumber /pagesize ;
        else:
            pagecount = totalnumber /pagesize + 1;
            
        return pagecount;


class DMU():
          
    @staticmethod
    def AssignQuery( dbQuery ):

        obQuery =OBJ();
        obQuery.description = dbQuery.description;
        obQuery.problemcount= dbQuery.problemcount;
        obQuery.username = dbQuery.creator.name;
        obQuery.createtime = dbQuery.createtime;
        obQuery.expiretime = dbQuery.expiretime;
        obQuery.problemlist= dbQuery.problemlist;
        obQuery.key = dbQuery.key();
        
        return obQuery;
     
    @staticmethod   
    def AssignProblem(dbProblem ):
        obProblem = OBJ();
        obProblem.description = dbProblem.description;
        obProblem.optionlist = dbProblem.optionlist;
        
        return obProblem;
        
        
    @staticmethod   
    def AssignOption(dbOption ):
        obOption.description = dbOption.description;
        obOption.pollcount = dbOption.pollcount;
        
        return obOption;
    
class QueryModelMap():
    description  = '';
    problemcount = 0;
    pollcount    = 0;
    #creator = model.QueryModel.User;
    createtime = datetime.now();
    expiretime = datetime.now();
    problemlist = [];
    
    @staticmethod
    def AssignDBQuery( dbQuery ):
        obQuery =QueryModelMap();
        obQuery.description = dbQuery.description;
        obQuery.problemcount= dbQuery.problemcount;
        obQuery.username = dbQuery.creator.name;
        obQuery.createtime = dbQuery.createtime;
        obQuery.expiretime = dbQuery.expiretime;
        obQuery.creator = dbQuery.creator;
        #-------not sure whether needed
        obQuery.problemlist = dbQuery.problemlist;
        return obQuery;
    
        
class ProblemModelMap():
    description = '';
    optionlist =[];
    
    @staticmethod   
    def AssignDBProblem( dbProblem ):
        obProblem = ProblemModelMap();
        obProblem.description = dbProblem.description;
        
        obProblem.optionlist = dbProblem.optionlist;
        return obProblem;
    
    
class OptionModelMap():
    description = '';
    pollcount = 0;
    
       
        
        
        