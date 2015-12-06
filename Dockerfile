#-------------------------------------------------------
#
# Dockerfile for building a simulator driver weewx system
#
# build via 'docker build -t weebian'
#
# run via 'docker -p 22 -p 80 run -t weebian' 
#     and optionally add -d to run detached in the backgroud
#     or optionally add -t -i to monitor it in the foreground
# or 'docker run -i -t weebian /bin/bash'
#     and in the shell 'service start' nginx and weewx
#
# this Dockerfile sets root's password = root
# and permits root logins over ssh for debugging
#
# note: this uses debian because it's 20% smaller than the
#       corresponding ubuntu 14.04 build, and it permits root
#       to ssh into the container without requiring edits
#
# last modified:
#     2014-0120 vinceskahan@gmail.com - original
#
#-------------------------------------------------------

FROM debian
MAINTAINER Vince Skahan "vinceskahan@gmail.com"

# misc, webserver, weewx prerequisites
RUN apt-get update; apt-get install -y sqlite3 wget curl procps \
   nginx \
   python-configobj python-cheetah python-imaging python-serial python-usb python-dev

# for multiple processes running in the container
RUN apt-get install -y supervisor openssh-server

#---- uncomment the next two lines for the optional pyephem
# RUN apt-get install -y python-pip 
# RUN pip install pyephem

# install weewx via the setup.py method
#  - the 'cd' below expects Tom to stick with the weewx-VERSION naming in his .tgz
RUN wget http://weewx.com/downloads/weewx-3.3.0.tar.gz -O /tmp/weewx.tgz
RUN cd /tmp
RUN tar zxvf /tmp/weewx.tgz
RUN cd weewx-* ; ./setup.py build ; ./setup.py install --no-prompt

# link it into the nginx web
RUN ln -s /var/www/html /home/weewx/public_html

# not used under docker, but sometimes helpful to have installed
RUN cp /home/weewx/util/init.d/weewx.debian /etc/init.d/weewx

# DANGER WILL ROBINSON !!!!
# set root's password to something trivial
RUN echo "root:root" | chpasswd

# sshd needs its /var/run tree there to successfully start up
RUN mkdir /var/run/sshd

# use 'supervisord' to start multiple processes in the container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# call supervisord as our container process to run
CMD ["/usr/bin/supervisord"]

# or use bash instead (and manually run supervisord) for debugging
# CMD ["/bin/bash"]
