import multiprocessing,os
 
APP_NAME = 'metrics'
 
bind = "0.0.0.0:80"
#bind = "unix:/tmp/gunicorn-%s.sock" % APP_NAME
workers = multiprocessing.cpu_count() * 2 + 1
max_requests = 200
preload_app = True
chdir = os.path.dirname(__file__)
daemon = True
debug = False
errorlog = '/tmp/gunicorn-%s.error.log' % APP_NAME
accesslog = '/tmp/gunicorn-%s.access.log' % APP_NAME
pidfile = '/tmp/gunicorn-%s.pid' % APP_NAME
loglevel="info"
