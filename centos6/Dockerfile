#-------------------------------------------------------
#
# Dockerfile for building a simulator driver weewx system
#
# build via 'docker build -t centos6'
#
# run via 'docker -p 22 -p 80 run -t weentos6' 
#     and optionally add -d to run detached in the backgroud
#     or optionally add -t -i to monitor it in the foreground
#
# or 'docker run -i -t weentos6 /bin/bash'
#     and in the shell 'service start' nginx and weewx
#
# last modified:
#     2019-0205 - update to 3.9.0
#     2019-0203 - update to 3.9.0b3
#     2018-0816 - update to 3.8.2
#     2018-0502 - try centos6
#     2018-0430 - set timezone to US/Pacific
#
#-------------------------------------------------------

FROM centos:6
MAINTAINER Vince Skahan "vinceskahan@gmail.com"

# copy supervisor config file into place
COPY supervisord.conf /etc/supervisord.conf

# install misc packages, webserver, weewx prerequisites, pip, supervisord/sshd
# then install pyephem via pip
# then install weewx via the setup.py method
#  - the 'cd' below expects Tom to stick with the weewx-VERSION naming in his .tgz
#
# this should be reasonably stable
RUN yum update -y  \
    && yum install -y sqlite3 wget \
           python-configobj python-cheetah python-imaging \
           tzdata python-setuptools

RUN easy_install supervisor

# add the trailing \ above and uncomment these to add in 
# unnecessary things that you might want to add to the image
#
#           curl procps
#

#--- python serial/usb modules ---
#
# pyusb is available from the EPEL repo, but pyserial
# does not exist there (sigh).  Just use pip for simplicity.
#
#    yum install -y python-pip
#    pip install pyserial pyusb
#

#--- pyephem ---
#
# pyephem is available in EPEL as well, but since we're using
# pip to install the serial/usb modules, use it for pyephem too
#
#    pip install pyephem
#
# (note: pyephem above makes the size much bigger and the build much slower)

# install weewx, making sure to mkdir the directories we will use as external volumes
RUN wget http://weewx.com/downloads/weewx-3.9.0.tar.gz -O /tmp/weewx.tgz && \
      cd /tmp && \
      tar zxvf /tmp/weewx.tgz && \
      cd weewx-* ; ./setup.py build ; ./setup.py install --no-prompt && \
      cp /home/weewx/util/init.d/weewx.debian /etc/init.d/weewx && \
      mkdir -p /home/weewx/archive /home/weewx/public_html

# set the location to something indicating this os
RUN sed -i -e s:My\ Little\ Town,\ Oregon:Centos6\ setup.py\ test\ system: /home/weewx/weewx.conf

#---- uncomment to set your timezone to other than UTC
RUN TIMEZONE="US/Pacific" && rm -f /etc/localtime && ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

# call supervisord as our container process to run
CMD ["/usr/bin/supervisord"]

# or use bash instead (and manually run supervisord) for debugging
#CMD ["/bin/bash"]
