
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

# extract it out
RUN wget http://weewx.com/downloads/weewx-4.0.0.tar.gz -O /tmp/weewx.tgz && \
      cd /tmp && \
      tar zxvf /tmp/weewx.tgz

# patch logger.py to use the console logger
COPY logger.py /tmp/logger.py

# now build it
RUN cd /tmp/weewx-* ; cp /tmp/logger.py ./bin/weeutil/logger.py && \
    python ./setup.py build && \
    echo -e "mylocation\n700,foot\n0.00\n0.00\nn\nus\n3\n" | python ./setup.py install  && \
    cp /home/weewx/util/init.d/weewx.debian /etc/init.d/weewx && \
    mkdir -p /home/weewx/archive /home/weewx/public_html

# set the location to something indicating this os
RUN sed -i -e s:mylocation:Centos7\ setup.py\ test\ system\ \(python2\): /home/weewx/weewx.conf

#---- uncomment to set your timezone to other than UTC
RUN TIMEZONE="US/Pacific" && rm -f /etc/localtime && ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

# call supervisord as our container process to run
CMD ["/usr/bin/supervisord"]
