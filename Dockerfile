#
# A dockerfile to run Octave and access it through the browser with noVNC
#
# BUILD DOCKER:	docker build -t epflsti/octave-x11-novnc-docker .
# RUN DOCKER:		docker run -it -p 8083:8083 epflsti/octave-x11-novnc-docker
# TEST DOCKER:	docker exec -it epflsti/octave-x11-novnc-docker /bin/bash

FROM phusion/baseimage:0.9.18
MAINTAINER OliverKohlDSc <oliver@kohl.bz>

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV TZ=Europe/Vienna
ENV SCREEN_RESOLUTION 1024x768
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Installing apps (Note: git is here just in case noVNC needs it in launch.sh
RUN apt-get update && apt-get -y install \
	xvfb \
	x11vnc \
	supervisor \
	fluxbox \
	git-core \
	git \
	firefox

# House cleaning
RUN apt-get autoclean

# Docker's supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set display
ENV DISPLAY :0

# Change work directory to add novnc files
WORKDIR /root/
ADD novnc /root/novnc/

# A few examples for the demo
#WORKDIR /scripts
#ADD ./octave_scr /scripts

# Can be configured to set octave settings
# COPY qt-settings /root/.config/octave/qt-settings

# Expose Port (Note: if you change it do it as well in surpervisord.conf)
EXPOSE 8083

CMD ["/usr/bin/supervisord"]
