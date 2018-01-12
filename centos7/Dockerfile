FROM centos:7
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
#           pyserial pyusb \
#           curl procps \
#           pyephem

# (note: pyephem above makes the size much bigger and the build much slower)

# install weewx, making sure to mkdir the directories we will use as external volumes
RUN wget http://weewx.com/downloads/weewx-3.8.0.tar.gz -O /tmp/weewx.tgz && \
      cd /tmp && \
      tar zxvf /tmp/weewx.tgz && \
      cd weewx-* ; ./setup.py build ; ./setup.py install --no-prompt && \
      cp /home/weewx/util/init.d/weewx.debian /etc/init.d/weewx && \
      mkdir -p /home/weewx/archive /home/weewx/public_html

# set the location to something indicating this os
RUN sed -i -e s:Hood\ River,\ Oregon:Centos7\ setup.py\ test\ system: /home/weewx/weewx.conf

#---- uncomment to set your timezone to other than UTC
# (to do)

# call supervisord as our container process to run
CMD ["/usr/bin/supervisord"]

# or use bash instead (and manually run supervisord) for debugging
#CMD ["/bin/bash"]
