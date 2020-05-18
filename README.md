
# Docker implementation of weewx in simulator mode

This runs pairs of docker containers configured to work together:

 * an nginx container from upstream using a local public_html tree
 * a weewx container writing to that public_html tree and saving its archives to a local dir

Note: this compose files uses /var/tmp/weewx_html and /var/tmp/weewx_archive for persistent storage

### to build:
    docker-compose build                   # to build all variants
    docker-compose build wee_pkg_deb10     # to build only one variant

### to run with logs in foreground:
    docker-compose up                      # to run all variants
    docker-compose up wee_pkg_deb10        # to run only one variant

### to run detached:
    docker-compose up -d                   # to run all variants
    docker-compose up -d wee_pkg_deb10     # to run only one variant

### to see the web pages:
  * open localhost:8878 in a browser for ubuntu 20.04 (python3, dpkg)
  * open localhost:8879 in a browser for ubuntu 20.04 (python3, setup.py)

  * open localhost:8887 in a browser for debian 10    (python2, dpkg)

  * open localhost:8888 in a browser for debian 10    (python3, dpkg)
  * open localhost:8889 in a browser for debian 10    (python3, setup.py)

### to stop all containers and delete networks
    docker-compose down 
    docker-compose down wee_pkg_deb10    # to shut down just that one pair of containers

### disclaimers
 * if on a mac and docker-compose is glacially slow, add the following to your /etc/hosts

         127.0.0.1	localhost localunixsocket.local

### sources to build this image
   available at https://github.com/vinceskahan/weewx-docker

