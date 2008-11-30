from pyamf.remoting.gateway.django import DjangoGateway
from google.appengine.ext import db


from model.QueryModel import User;

def userAuthenticate(request,user ):

    #u = User(name="wang",password="123456");
    #u.put();
    result = User.hasUser(user.name, user.password) 
    return {
     'AuthResult':result['AuthResult'],
     'User':result['User']
    }
    
def adminAuthenticate( request,user ):
    
    #u = User(name="wang",password="123456",type="ADMIN");
    #u.put();  
    result = User.hasAdmin(user.name, user.password) 
    return {
     'AuthResult':result['AuthResult'],
     'User':result['User']
    }  
    
    
       
def addUser( request, user ):
    User.submitUser( user.name , user.password);
    
    return{
           'AddResult':True
           }

def checkUserAvailable( request, username ):
    
    return{
           'HasUsername':User.hasUsername( username )
           }


    

userGateway = DjangoGateway({
    'iSurvey.userAuthenticate': userAuthenticate,
    'iSurvey.addUser':addUser,
    'iSurvey.checkUserAvailable':checkUserAvailable,
    'iSurvey.adminAuthenticate':adminAuthenticate
    #'getAllDepartments':getAllDepartments,
    #'updateUser':updateUser
})
