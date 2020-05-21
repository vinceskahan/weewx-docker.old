
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

| os 	| ver 	| type 	| python 	| nginx port 	|
|:-:	|:-:	|:-:	|:-:	|:-:	|
| ubuntu | 20.04 | dpkg	| 3 | 8878 |
| ubuntu | 20.04 | setup | 3 |  8879i|
|:-:	|:-:	|:-:	|:-:	|:-:	|
| debian | 10 | dpkg 	| 2 |  8887	|
| debian | 10 | dpkg 	| 3 |  8888	|
| debian | 10 | dpkg 	| 2 |  8887	|
|:-:	|:-:	|:-:	|:-:	|:-:	|
| centos | 7 | setup 	| 2 |  8869	|

  * open localhost:8878 in a browser for ubuntu 20.04 (python3, dpkg)
  * open localhost:8879 in a browser for ubuntu 20.04 (python3, setup.py)

  * open localhost:8887 in a browser for debian 10    (python2, dpkg)

  * open localhost:8888 in a browser for debian 10    (python3, dpkg)
  * open localhost:8889 in a browser for debian 10    (python3, setup.py)

  * open localhost:8869 in a browser for centos 7     (python2, setup.py)

### known issues:
 * the centos 7 container doesn't log at all, but seems to run fine in brief testing.
   To do this, I patched logger.py to use the console logger rather than syslog to a socket,
   using code from Tom (see https://groups.google.com/d/msg/weewx-development/Xx-1k6zxwVY/xgfCYeF9BAAJ)

### to stop all containers and delete networks
    docker-compose down 
    docker-compose down wee_pkg_deb10    # to shut down just that one pair of containers

### disclaimers
 * if on a mac and docker-compose is glacially slow, add the following to your /etc/hosts

         127.0.0.1	localhost localunixsocket.local

### sources to build this image
   available at https://github.com/vinceskahan/weewx-docker

