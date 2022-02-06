
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
           tzdata python-setuptools \
           rsyslog unzip epel-release

RUN yum install -y supervisor

# add the trailing \ above and uncomment these to add in 
# unnecessary things that you might want to add to the image
#
#           pyserial pyusb \
#           curl procps \
#           pyephem

# (note: pyephem above makes the size much bigger and the build much slower)

#### TO DO - and delete rpmdb etc to minimize the size of the container

# extract it out
RUN wget http://weewx.com/downloads/weewx-4.6.0.tar.gz -O /tmp/weewx.tgz && \
      cd /tmp && \
      tar zxvf /tmp/weewx.tgz

# need rsyslog
COPY rsyslog.conf /etc/rsyslog.conf

# now build it
# convoluted steps here
#   - copy our rsyslog.conf into place
#   - stash the original logger.py
#     and use our patched version through 'setup install'
#   - then put the stashed logger.py back into place

RUN wget https://github.com/weewx/weewx/archive/master.zip -O /tmp/weewx.zip && \
      unzip /tmp/weewx*.zip && \
      cd weewx-* ; python ./setup.py build && python ./setup.py install --no-prompt && \
      cp /home/weewx/util/init.d/weewx.debian /etc/init.d/weewx && \
      mkdir -p /home/weewx/archive /home/weewx/public_html && \
      sed -i -e s:My\ Little\ Town,\ Oregon:Centos7\ setup.py\ test\ system\ \(python2\): /home/weewx/weewx.conf && \
      rsyslogd

#--- uncomment to set weewx debug=1
RUN sed -i -e s:debug\ =\ 0:debug\ =\ 1: /home/weewx/weewx.conf

#---- uncomment to set your timezone to other than UTC
RUN TIMEZONE="US/Pacific" && rm -f /etc/localtime && ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

# call supervisord as our container process to run
CMD ["/usr/bin/supervisord"]
