import os

_basedir = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))

class LocalConfig(object):

    DEBUG = False
    SECRET_KEY = 

    SOLRQUERY_URL = 

    MONGOALCHEMY_SERVER = 
    MONGOALCHEMY_USER = 
    MONGOALCHEMY_PASSWORD = 

    ADSDATA_MONGO_HOST  = 

    LOGGING_LOG_LEVEL = 
    
    COOKIE_ADSABS2_NAME = 
    COOKIE_ADS_CLASSIC_NAME = 
    COOKIES_CONF = {COOKIE_ADS_CLASSIC_NAME :{
                         "domain": ("dev.localhost",".dev.localhost"),
                         "max_age": 31356000
                         },  
                     COOKIE_ADSABS2_NAME :{
                         "domain": ("dev.localhost",".dev.localhost"),
                         "max_age": 31356000
                         },  
                     }
    
    RECAPTCHA_PUBLIC_KEY = 
    RECAPTCHA_PRIVATE_KEY = 
    
    ACCOUNT_VERIFICATION_SECRET = 
    ADS_LOGIN_URL = 

    ADSDATA_MONGO_USER = 
    ADSDATA_MONGO_PASSWORD = 

    API_SIGNUP_SPREADSHEET_KEY = 
    API_SIGNUP_SPREADSHEET_LOGIN = 

    METRICS_MONGO_USER = 
    METRICS_MONGO_PASSWORD = 

    MONGODB_SETTINGS= {"HOST" : "mongodb://", "DB":""}

    ASSETS_DEBUG = 
