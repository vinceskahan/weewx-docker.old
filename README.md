
# Docker implementation of weewx in simulator mode

This runs pairs of docker containers configured to work together:

 * an nginx container from upstream using a local public_html tree
 * a weewx container writing to that public_html tree and saving its archives to a local dir

### to build:
    docker-compose build

### to run with logs in foreground:
    docker-compose up

### to run detached:
    docker-compose up -d

### to see the web pages:
  open localhost:8080 in a browser for debian
  open localhost:8081 in a browser for ubuntu
  open localhost:8082 in a browser for centos7

### disclaimers
 * if on a mac and docker-compose is glacially slow, add the following to your /etc/hosts

         127.0.0.1	localhost localunixsocket.local

### sources to build this image
   available at https://github.com/vinceskahan/weewx-docker
