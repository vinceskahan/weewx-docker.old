
# DEPRECATED - THIS IS AN OLD PROOF_OF_CONCEPT (unsupported as of 2022-1123)
# DEPRECATED - THIS IS AN OLD PROOF_OF_CONCEPT (unsupported as of 2022-1123)
# DEPRECATED - THIS IS AN OLD PROOF_OF_CONCEPT (unsupported as of 2022-1123)

----
# Docker implementation of weewx in simulator mode

This runs pairs of docker containers configured to work together:

 * an nginx container from upstream using a local public_html tree
 * a weewx container writing to that public_html tree and saving its archives to a local dir

Note: this compose files uses /var/tmp/weewx_html and /var/tmp/weewx_archive for persistent storage

### to build:
    docker-compose build                     # to build all variants
    docker-compose build weewx_pkg_deb10     # to build only one variant

### to run with logs in foreground:
    docker-compose up                        # to run all variants
    docker-compose up weewx_pkg_deb10        # to run only one variant

### to run detached:
    docker-compose up -d                     # to run all variants
    docker-compose up -d weewx_pkg_deb10     # to run only one variant

### for a list of currently supported variants
    see the docker-compose file

### to see the web pages:

|   os   |  ver  |  type | python | nginx port | size (MB) |
| :---:  | :---: | :---: | :---:  |    :---:   |   :---:   |
| ubuntu | 20.04 | setup |   3    |    8879    |  168 |
| ubuntu | 20.04 | dpkg  |   3    |    8878    |  202 |
| debian | 11    | setup |   3    |    8889    |  336 |
| debian | 11    | dpkg  |   3    |    8888    |  368 |
| debian | 10    | setup |   3    |    8889    |  302 |
| debian | 10    | dpkg  |   3    |    8888    |  329 |
| debian | 10    | setup |   2    |    8887    |  276 |
| centos | 8     | setup |   3    |    8857    |  697 |
| centos | 7     | setup |   2    |    8867    |  1220 |

### known issues:
 * centos variants obviously aren't anywhere near as stripped as they could be
 * all the images could probably be cleaned up significantly for size
 
### to stop all containers and delete networks
    docker-compose down 
    docker-compose down weewx_pkg_deb10    # to shut down just that one pair of containers

### disclaimers
 * if on a mac and docker-compose is glacially slow, add the following to your /etc/hosts

         127.0.0.1	localhost localunixsocket.local

### sources to build this image
   available at https://github.com/vinceskahan/weewx-docker

