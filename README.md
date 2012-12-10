Hydra Head

Note: This repo does not contain Jetty.  To download and setup a new Jetty
instance, do:

git clone git://github.com/projecthydra/hydra-jetty.git jetty
cd jetty
git checkout new-solr-schema
cd ..
rake hydra:jetty:config 
rake jetty:start
