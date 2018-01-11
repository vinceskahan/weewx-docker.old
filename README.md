
# Docker implementation of weewx in simulator mode

This runs two docker containers configured to work together:

 * an nginx container from upstream using a local public_html tree
 * a weewx on debian container writing to that public_html tree and saving its archives to a local dir

### to build:
    docker-compose build

### to run with logs in foreground:
    docker-compose up

### to run detached:
    docker-compose up -d

### to see the web pages:
  open localhost:8080 in a browser

### disclaimers
 * if on a mac and docker-compose is glacially slow, add the following to your /etc/hosts

         127.0.0.1	localhost localunixsocket.local

### sources to build this image
   available at https://github.com/vinceskahan/weebian-docker
