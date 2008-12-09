from pyamf.remoting.gateway.django import DjangoGateway
from google.appengine.ext import db
from google.appengine.api import mail

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
    
def sendPasswordEmail( request, username ):
    user = User.getUser(username );
    if ( user == None or not mail.is_email_valid( user.email)):
        return {
                'GetResult':False
                };
    else:
        sender  = "GAE_SJTU@GAE.COM";
        subject = "Your Account on GAE-SJTU SURVEY";
        to = user.name + " <" + user.email + ">";
        #to = user.email;
        body = "Dear" + to + " your Password on GAE SJTU SURVEY is:"+user.password +" Please Check it";
        #body = """congratulation on this work""";
        
        message = mail.EmailMessage(
                                    sender  = sender,                            
                                    subject = subject);
        message.to = to;
        message.body = body;
        message.send()
        
        
        #mail.send_mail(sender=sender,              
        #               to=to,              
        #               subject="Your Account on GAE-SJTU SURVEY",              
        #               body= body);
        return {
                'GetResult':True
                };
        
    
    
       
def addUser( request, user ):
    User.submitUser( user.name , user.password, user.email);
    
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
    'iSurvey.adminAuthenticate':adminAuthenticate,
    'iSurvey.sendPasswordEmail':sendPasswordEmail
    #'getAllDepartments':getAllDepartments,
    #'updateUser':updateUser
})
