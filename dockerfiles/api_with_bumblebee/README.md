## Prereqs:

  1. Docker
  2. git clone adsws, git clone bumblebee in this directory

## usage:

`docker build -t adsabs/api_with_bumblebee .`

(interactive inside the container) `docker run -t -i adsabs/api_with_bumblbee bash `

or, if the build broke at a certain point:

1. Find the last image created with `docker ps -l`
2. `docker run -t -i <IMAGE_HASH> bash`
