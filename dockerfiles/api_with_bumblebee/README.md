## Prereqs:

  1. Docker
  2. git clone adsws, git clone bumblebee in this directory

## usage:

`docker build -t adsabs/api_with_bumblebee .`

`docker run -d --name MY_CONTAINER -p 8001:8001 -p 5000:5000 adsabs/api_with_bumblebee`

`docker stop MY_CONTAINER`

`docker start MY_CONTAINER`

`docker rm MY_CONTAINER`

(interactive inside the container) `docker run -t -i adsabs/api_with_bumblebee bash `

or, if the build broke at a certain point:

1. Find the last image created with `docker ps -l`
2. `docker run -t -i <IMAGE_HASH> bash`
