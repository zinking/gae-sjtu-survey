from google.appengine.ext import db

class User(db.Model):
    name        = db.StringProperty(required = True);
    classid     = db.StringProperty(required = True );
    suggestion1 = db.TextProperty( );
    suggestion2 = db.TextProperty( );
    bachelor_start_year     = db.DateTimeProperty();
    bachelor_last           = db.IntegerProperty();
    bachelor_major          = db.StringProperty();
    graduate_start_year     = db.DateTimeProperty();
    graduate_last           = db.IntegerProperty();
    graduate_major          = db.StringProperty();
    has_foreign_study_exp   = db.BooleanProperty();
    foreign_start_year      = db.DateTimeProperty();
    foreign_last            = db.IntegerProperty();
    foreign_school          = db.StringProperty();
    work_experience         = db.StringProperty();
    level                   = db.StringProperty();
    duty                    = db.StringProperty();
    


class EvaluationData(db.Model):
    
    id           = db.IntegerProperty ( required = True );
    importance      = db.StringProperty( );
    selfevaluate    = db.StringProperty ( );
    creater         = db.ReferenceProperty(User, required = True );
    affectionsource = db.TextProperty( );
   

    
    