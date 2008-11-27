from pyamf.remoting.gateway.django import DjangoGateway
from google.appengine.ext import db


from model.QueryModel import User;

def userAuthenticate(request,user ):

    u = User(name="wang",password="123456");
    u.put();
    
    username = user.name;
    password = user.password; 
    
    return {
     'AuthResult':User.hasUser(username, password),
     'User':User(name = "wang", password="123")
    }
       


   


 
    
def userindex(request):
    html = "<H1>People</H1><HR>"
    return HttpResponse(html)

def AddData(request, data ):
    #user = User( name="wang",password ="123456");
    #user.put();
    name = data.name;
    password = data.password;
    request['user'] = "wang";
    

    

#def updateUser(request,userID,userName,depID):
    #user=User.objects.get(id=userID)
    #user.name=userName
    #user.depID=depID
    

userGateway = DjangoGateway({
    'iSurvey.userAuthenticate': userAuthenticate,
    'iSurvey.AddData':AddData
    #'getAllDepartments':getAllDepartments,
    #'updateUser':updateUser
})
