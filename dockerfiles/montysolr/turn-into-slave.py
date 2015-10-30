#!/bin/env/python

#this will be executed inside the target

import os

config  = open('solr/collection1/conf/solrconfig.xml', 'r').read()

config = config.replace('<requestHandler name="/replication" class="solr.ReplicationHandler" startup="lazy" />',
   """
   <requestHandler name="/replication" class="solr.ReplicationHandler" >
     <lst name="slave">
         <str name="masterUrl">http://adsabs.harvard.edu/solr/</str>
         <str name="pollInterval">00:00:60</str>
       </lst>
   </requestHandler>
   """)

fo = open('solr/collection1/conf/solrconfig.xml', 'w')
fo.write(config)
fo.close()


