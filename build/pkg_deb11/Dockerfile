#-------------------------------------------------------
#
# Dockerfile for building a simulator driver weewx system
#
# build via 'docker build -t weebian'
#
# run via 'docker -p 22 -p 80 run -t weebian' 
#     and optionally add -d to run detached in the backgroud
#     or optionally add -t -i to monitor it in the foreground
#
# or 'docker run -i -t weebian /bin/bash'
#     and in the shell 'service start' nginx and weewx
#
#-------------------------------------------------------

FROM debian:11
MAINTAINER Vince Skahan "vinceskahan@gmail.com"

# copy supervisor config file into place
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# install misc packages, webserver, weewx prerequisites, pip, supervisord/sshd
# then install pyephem via pip
# then install weewx via the setup.py method
#  - the 'cd' below expects Tom to stick with the weewx-VERSION naming in his .tgz
#
# cleanup of apt remnants courtesy of:
#  https://gist.github.com/marvell/7c812736565928e602c4
#
# this should be reasonably stable
#
# os notes:
#    debian:10 docker base image does not have python3-distutils installed
#              and seems to default to python2, so we call python3 explictly below
#              if this Dockerfile uses setup.py
#

RUN apt-get update \
    && apt-get install -y sqlite3 wget \
           python3-distutils rsyslog  \
           python3-configobj python3-cheetah python3-pil \
           python3-usb python3-serial \
           supervisor tzdata procps vim \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

# add the trailing \ above and uncomment these to add in 
# unnecessary things that you might want to add to the image
#
#           python-serial python-usb \
#           curl procps \

# add the trailing \ above and uncomment these to add in
# pyephem, which makes the size much bigger and the build much slower
#
#           python-dev \
#           python-pip \
#   && pip install pyephem

# install weewx, making sure to mkdir the directories we will use as external volumes
##### (4.5.1 needs a patch to restore --no-prompt)
####cd weewx-* ; ./setup.py build ; ./setup.py install --no-prompt && \
#RUN wget http://weewx.com/downloads/weewx-4.5.1.tar.gz -O /tmp/weewx.tgz && \
#      cd /tmp && \
#      tar zxvf /tmp/weewx.tgz && \
#      cd weewx-* ; python3 ./setup.py build && echo "debian10\n700,foot\n0.00\n0.00\nn\nus\n3\n" | python3 ./setup.py install && \
#      cp /home/weewx/util/init.d/weewx.debian /etc/init.d/weewx && \
#      mkdir -p /home/weewx/archive /home/weewx/public_html
## set the location to something indicating this os

RUN wget http://www.weewx.com/downloads/released_versions/python3-weewx_4.5.1-1_all.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ./python3-weewx_4.5.1-1_all.deb

# let'em know who we are
RUN sed -i -e s:Santa\'s\ Workshop,\ North\ Pole:Debian10\ dpkg\ test\ system: /etc/weewx/weewx.conf

#---- uncomment to set your timezone to other than UTC
# (to do: this doesn't work any more)
RUN TIMEZONE="US/Pacific" && rm /etc/timezone && rm /etc/localtime && echo $TIMEZONE > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# call supervisord as our container process to run
CMD ["supervisord"]

# try it with a wrapper script
#COPY foo foo
#COPY weewx-startup-script weewx-startup-script
#CMD sh ./foo
#CMD service weewx start #### >/dev/null 2>/dev/null && bash

# CMD ["/bin/bash"]


