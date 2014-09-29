import multiprocessing
bind = "0.0.0.0:6002"
workers = multiprocessing.cpu_count() * 2 + 1
max_requests = 200
preload_app = True
chdir = '/adsws'
daemon = True
debug = False
errorlog = '/tmp/gunicorn.error.log'
pidfile = '/tmp/gunicorn.pid'
loglevel="debug"
