import os,sys
import subprocess
import time
import requests
import time
import random

#curl http://localhost:8983/solr/update?commit=true --data-binary @grbs.json -H 'Content-type:text/json; charset=utf-8'

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
    self.start = time.clock()
    return self
  def __exit__(self, *args):
    self.end = time.clock()
    self.interval = self.end - self.start

def ingest(URL='http://localhost:8983/solr/update?commit=true',args=[
  '--data-binary',
  '--@grbs.json',
  '-H',
  "'Content-type:text/json; charset=utf-8'"
  ]):

  cmd = ['curl',url]
  cmd.extend(args)
  P = subprocess.Popen(cmd)


def main():
  with cd(os.path.dirname(__file__)):
    ingest()


if __name__ == '__main__':
  main()