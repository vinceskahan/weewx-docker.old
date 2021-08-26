#-------------------------------------------------------
#
# Dockerfile for building a simulator driver weewx system
#
# build via 'docker build -t weebuntu'
#
# run via 'docker -p 22 -p 80 run -t weebuntu' 
#     and optionally add -d to run detached in the backgroud
#     or optionally add -t -i to monitor it in the foreground
#
# or 'docker run -i -t weebuntu /bin/bash'
#     and in the shell 'service start' nginx and weewx
#
# this Dockerfile sets root's password = root
# and permits root logins over ssh for debugging
#
#-------------------------------------------------------

FROM ubuntu
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
RUN apt-get update \
    && apt-get install -y sqlite3 wget \
           python-configobj python-cheetah python-pil \
           supervisor tzdata \
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

#---- uncomment to set your timezone to other than UTC
RUN TIMEZONE="US/Pacific" && rm /etc/timezone && rm /etc/localtime && echo $TIMEZONE > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# install weewx, making sure to mkdir the directories we will use as external volumes
RUN wget http://weewx.com/downloads/weewx-4.0.0.tar.gz -O /tmp/weewx.tgz && \
      cd /tmp && \
      tar zxvf /tmp/weewx.tgz && \
      cd weewx-* ; ./setup.py build ; ./setup.py install --no-prompt && \
      cp /home/weewx/util/init.d/weewx.debian /etc/init.d/weewx && \
      mkdir -p /home/weewx/archive /home/weewx/public_html

# set the location to something indicating this os
RUN sed -i -e s:My\ Little\ Town,\ Oregon:Ubuntu\ setup.py\ test\ system: /home/weewx/weewx.conf

# call supervisord as our container process to run
# CMD ["/usr/bin/supervisord"]
CMD ["/home/weewx/bin/weewxd", "--daemon", "--pidfile=/var/run/weewx.pid", "/home/weewx/weewx.conf" ]

# or use bash instead (and manually run supervisord) for debugging
# CMD ["/bin/bash"]
