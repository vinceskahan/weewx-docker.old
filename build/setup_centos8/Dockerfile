
FROM centos:8
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
    && yum install -y wget tzdata rsyslog \
           python3-pip python3-configobj python3-pillow python3-pyserial python3-pyusb \
           epel-release 

RUN yum update -y \
    && yum install -y python3-cheetah supervisor

# add the trailing \ above and uncomment these to add in 
# unnecessary things that you might want to add to the image
#
#           pyserial pyusb \
#           curl procps \
#           pyephem

# (note: pyephem above makes the size much bigger and the build much slower)

# extract it out
RUN wget http://weewx.com/downloads/weewx-4.0.0.tar.gz -O /tmp/weewx.tgz && \
      cd /tmp && \
      tar zxvf /tmp/weewx.tgz

# patch logger.py to use the console logger
COPY logger.py /tmp/logger.py
COPY rsyslog.conf /tmp/rsyslog.conf

# now build it
# convoluted steps here
#   - copy our rsyslog.conf into place
#   - stash the original logger.py
#     and use our patched version through 'setup install'
#   - then put the stashed logger.py back into place

RUN cd /tmp/weewx-* && \
    cp /tmp/rsyslog.conf /etc/rsyslog.conf && \
    cp ./bin/weeutil/logger.py /tmp/logger.py.dist && cp /tmp/logger.py ./bin/weeutil/logger.py && \
    python3 ./setup.py build && \
    /usr/sbin/rsyslogd && \
    echo -e "mylocation\n700,foot\n0.00\n0.00\nn\nus\n3\n" | python3 ./setup.py install  && \
    cp /tmp/logger.py.dist /home/weewx/bin/weeutil/logger.py && \
    mkdir -p /home/weewx/archive /home/weewx/public_html && \
    sed -i -e s:debug\ =\ 0:debug\ =\ 1: /home/weewx/weewx.conf

# set the location to something indicating this os
RUN sed -i -e s:mylocation:Centos8\ setup.py\ test\ system: /home/weewx/weewx.conf

#---- uncomment to set your timezone to other than UTC
RUN TIMEZONE="US/Pacific" && rm -f /etc/localtime && ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

# call supervisord as our container process to run
CMD ["/usr/bin/supervisord"]
