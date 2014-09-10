`docker build -t adsabs/mongo .`
`docker run -d --name mongo -p 27017:27018 -v $PWD/data/:/data/ -m="50g" adsabs/mongo`
