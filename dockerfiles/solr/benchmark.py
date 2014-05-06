import os,sys
import requests
import time
import requests
import subprocess
import time
import random
import argparse
import multiprocessing
import json
import matplotlib
from matplotlib import pyplot as plt
import numpy as np
import httplib
import sqlite3


def init_db(name):
  SQL_CREATE = '''
  CREATE TABLE results (id INTEGER PRIMARY KEY AUTOINCREMENT,responsetime,qtime,numfound,concurrency,time);
  CREATE TABLE errors (id INTEGER PRIMARY KEY AUTOINCREMENT,error,concurrency,time);
  '''
  if not os.path.isfile(name):
    db = sqlite3.connect(name,detect_types=sqlite3.PARSE_DECLTYPES|sqlite3.PARSE_COLNAMES)
    SQL = SQL_CREATE.strip().replace('\n','')
    db.executescript(SQL)
    db.commit()
    return db
  db = sqlite3.connect(name)
  return db


class cd:
  """Context manager for changing the current working directory"""
  def __init__(self, newPath):
    self.newPath = newPath
  def __enter__(self):
    self.savedPath = os.getcwd()
    os.chdir(self.newPath)
  def __exit__(self, etype, value, traceback):
    os.chdir(self.savedPath)


class Timer:
  def __init__(self,name=None):
    self.name = name
  def __enter__(self):
    self.start = time.time()
    return self
  def __exit__(self, *args):
    self.end = time.time()
    self.interval = self.end - self.start


def _notes():
  def chunkIt(seq, num):
    avg = len(seq) / float(num)
    out = []
    last = 0.0
    while last < len(seq):
      out.append(seq[int(last):int(last + avg)])
      last += avg
    return out
  pieces = chunkIt(j,5)
  i = 0
  for p in pieces:
    i+=1
    with open('grbs%s.json' % i,'w') as fp:
      json.dump(p,fp)


def ingest(args,curl_args=[
  '--data-binary',
  '@grbs.json',
  '-H',
  "'Content-type:text/json; charset=utf-8'"
  ]):
 #curl http://localhost:8983/solr/update?commit=true --data-binary @grbs.json -H 'Content-type:text/json; charset=utf-8'

  cmd = ['curl','%s/update?commit=true' % args.solr_url]
  cmd.extend(curl_args)
  print "Ingesting data with the following:\n%s" % ' '.join(cmd)
  P = subprocess.Popen(' '.join(cmd),shell=True)
  P.wait()

def globalPlot(dirs=['t2','t3','t4','t5'],concurrencies=[1,2,3,4]):
  results = {}
  fig = plt.figure()
  ax = fig.gca()
  for d in dirs:
    db = sqlite3.connect(os.path.join(d,'results.sqlite'))
    results[d] = []
    for c in concurrencies:
      SQL = '''
      SELECT qtime from results WHERE concurrency==%s;
      ''' % c
      r = db.execute(SQL.strip()).fetchall()
      r = [i[0] for i in r]
      results[d].append( (len(r)/120.0,np.median(r),np.std(r)) )
    x = [i[0] for i in results[d]]
    y = [i[1] for i in results[d]]
    e = [i[2] for i in results[d]]
    ax.errorbar(x,y,yerr=e,fmt='-x',label=d)
  plt.xlabel('Req/sec')
  plt.ylabel('Median QTime')
  ax.legend()
  plt.savefig('test.png')


def plot(args):
  db = sqlite3.connect(args.db)
  SQL_SELECT = '''
  SELECT responsetime,qtime,numfound,time FROM results WHERE concurrency==%(concurrency)s;
  ''' % {'concurrency':args.concurrency}
  res = db.execute(SQL_SELECT.strip()).fetchall()
  responsetime = [i[1] for i in res]
  qtime = [i[1] for i in res]
  numfound = [i[2] for i in res]
  time = [i[3] for i in res]

  fig = plt.figure()
  ax = fig.gca()
  ax.hist(qtime,bins=30,histtype='step',color='red')
  #ax.hist(responsetime,bins=30,histtype='step',color='blue')
  plt.ylabel('QTime')
  plt.title('median=%(median)s, avg=%(avg)0.1f, range=%(min)s-%(max)s' % {'median':np.median(qtime),'avg':np.mean(qtime),'min':min(qtime),'max':max(qtime)})
  plt.savefig('fig_c%s.png' % args.concurrency)

  ax.cla()
  ax.plot(time,qtime,'-k')
  plt.ylabel('QTime')
  plt.xlabel('Time (absolute)')
  plt.title('%s responses in %s sec' % (len(time),args.duration))
  plt.savefig('fig_tc%s.png' % args.concurrency)

  SQL_SELECT = '''
  SELECT time,error FROM errors WHERE concurrency==%(concurrency)s;
  ''' % {'concurrency':args.concurrency}
  res = db.execute(SQL_SELECT.strip()).fetchall()
  time = [i[0] for i in res]

  ax.cla()
  ax.plot(time,[i+1 for i in range(len(time))],'-k')
  plt.ylabel('Cum. Errors')
  plt.xlabel('Time (absolute)')
  plt.title('%s errors in %s sec' % (len(time),args.duration))
  plt.savefig('fig_ec%s.png' % args.concurrency)



def query(args):
  r=random.Random().random()
  URL = '%(url)s/collection1/select?q=*:*&fq=score:[%(val1)s TO %(val2)s]&facet=true&facet.field=score&wt=json'
  URL = URL % {'url': args.solr_url,'val1': r-0.6,'val2': r+0.6,}
  with Timer() as t:
    try:
      content = requests.request('GET',URL).content
    except:
      SQL_INSERT = '''
      INSERT INTO errors (error,concurrency,time) VALUES ("%(err)s",%(concurrency)s,%(time)s);
      ''' % {'err':'unknown_exception','concurrency':args.concurrency,'time':t.start}
      db = sqlite3.connect(args.db)
      db.execute(SQL_INSERT.strip())
      db.commit()
      db.close()
      return

  responsetime = t.interval
  qtime = json.loads(content)['responseHeader']['QTime']
  numfound = json.loads(content)['response']['numFound']
  db = sqlite3.connect(args.db)
  SQL_INSERT = '''
  INSERT INTO results (responsetime,qtime,numfound,concurrency,time) VALUES (%(responsetime)s,%(qtime)s,%(numfound)s,%(concurrency)s,%(time)s);
  ''' % {'responsetime':responsetime,'qtime':qtime,'numfound':numfound,'concurrency':args.concurrency,'time':t.start}
  db.execute(SQL_INSERT.strip())
  db.commit()
  db.close()


def benchmark(args):
  procs = []
  concurrency = 0
  start = time.time()
  while time.time()-start < args.duration:
    time.sleep(0.1)
    while len(procs) < args.concurrency:
      P = multiprocessing.Process(target=query,args=(args,))
      P.start()
      procs.append(P)
    procs = [P for P in procs if P.is_alive()]


def main():
  parser = argparse.ArgumentParser()
  parser.add_argument(
    '--ingest',
    default=False,
    action='store_true',
    dest='ingest',
  )
  parser.add_argument (
    '--concurrency',
    default=1,
    dest='concurrency',
    type=int,
  )
  parser.add_argument (
    '--duration',
    default=60,
    dest='duration',
    type=int,
  )
  parser.add_argument (
    '--solr-url',
    default='http://localhost:8983/solr',
    dest='solr_url',
  )
  parser.add_argument (
    '--db',
    default='results.sqlite',
    dest='db',
  )

  parser.add_argument(
    '--global-plot',
    default=False,
    action='store_true',
    dest='global_plot',
  )

  args = parser.parse_args()
  db = init_db(args.db)

  if args.global_plot:
    globalPlot()
    return

  if args.ingest:
    ingest(args)

  benchmark(args)

  plot(args)


if __name__ == '__main__':
  with cd(os.path.abspath(os.path.dirname(__file__))):
    main()