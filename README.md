
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
 * patience....docker-compose seems glacially slow on a 2011 Macbook Air
 * the weewx container has pyephem built in, which doubles its size
