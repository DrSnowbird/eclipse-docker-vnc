FROM openkbs/jdk-mvn-py3-vnc

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

## -------------------------------------------------------------------------------
## ---- USER_NAME is defined in parent image: openkbs/jdk-mvn-py3-x11 already ----
## -------------------------------------------------------------------------------
ENV USER_NAME=${USER_NAME:-developer}
ENV HOME=/home/${USER_NAME}
ENV ECLIPSE_WORKSPACE=${HOME}/eclipse-workspace

## ----------------------------------------------------------------------------
## ---- To change to different Eclipse version: e.g., oxygen, change here! ----
## ----------------------------------------------------------------------------

## -- 1.) Eclipse version: oxygen, photon, 2021-03, etc.: -- ##
ARG ECLIPSE_VERSION=${ECLIPSE_VERSION:-2021-03}
ENV ECLIPSE_VERSION=${ECLIPSE_VERSION}

## -- 2.) Eclipse Type: -- ##
#ARG ECLIPSE_TYPE=${ECLIPSE_TYPE:-modeling}
ARG ECLIPSE_TYPE=${ECLIPSE_TYPE:-jee}

## -- 3.) Eclipse Release: -- ##
ARG ECLIPSE_RELEASE=${ECLIPSE_RELEASE:-R}

## -- 4.) Eclipse Download Mirror site: -- ##
ARG ECLIPSE_OS_BUILD=${ECLIPSE_OS_BUILD:-linux-gtk-x86_64}

## -- 5.) Eclipse Download Mirror site: -- ##
#https://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/2020-06/R/eclipse-jee-2020-06-R-linux-gtk-x86_64.tar.gz

#http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-jee-photon-R-linux-gtk-x86_64.tar.gz
#http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-modeling-photon-R-linux-gtk-x86_64.tar.gz
## https://mirror.umd.edu/eclipse/technology/epp/downloads/release/2021-03/R/eclipse-modeling-2021-03-R-linux-gtk-x86_64.tar.gz

#ARG ECLIPSE_MIRROR_SITE_URL=${ECLIPSE_MIRROR_SITE_URL:-https://mirror.math.princeton.edu/pub/}
ARG ECLIPSE_MIRROR_SITE_URL=${ECLIPSE_MIRROR_SITE_URL:-https://mirror.umd.edu/}

## ----------------------------------------------------------------------------------- ##
## ----------------------------------------------------------------------------------- ##
## ----------- Don't change below unless Eclipse download system change -------------- ##
## ----------------------------------------------------------------------------------- ##
## ----------------------------------------------------------------------------------- ##
## -- Eclipse TAR/GZ filename: -- ##
#ARG ECLIPSE_TAR=${ECLIPSE_TAR:-eclipse-jee-photon-R-linux-gtk-x86_64.tar.gz}
ARG ECLIPSE_TAR=${ECLIPSE_TAR:-eclipse-${ECLIPSE_TYPE}-${ECLIPSE_VERSION}-${ECLIPSE_RELEASE}-${ECLIPSE_OS_BUILD}.tar.gz}

## -- Eclipse Download route: -- ##
ARG ECLIPSE_DOWNLOAD_ROUTE=${ECLIPSE_DOWNLOAD_ROUTE:-eclipse/technology/epp/downloads/release/${ECLIPSE_VERSION}/${ECLIPSE_RELEASE}}

## -- Eclipse Download full URL: -- ##
## e.g.: http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/
## e.g.: http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/
ARG ECLIPSE_DOWNLOAD_URL=${ECLIPSE_DOWNLOAD_URL:-${ECLIPSE_MIRROR_SITE_URL}/${ECLIPSE_DOWNLOAD_ROUTE}}

## http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-jee-photon-R-linux-gtk-x86_64.tar.gz
## http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-jee-photon-R-linux-gtk-x86_64.tar.gz
## http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-modeling-photon-R-linux-gtk-x86_64.tar.gz
## https://mirror.umd.edu/eclipse/technology/epp/downloads/release/2021-03/R/eclipse-modeling-2021-03-R-linux-gtk-x86_64.tar.gz

WORKDIR /opt
RUN sudo wget -q -c --no-check-certificate ${ECLIPSE_DOWNLOAD_URL}/${ECLIPSE_TAR} && \
    sudo tar xvf ${ECLIPSE_TAR} && \
    sudo rm -f ${ECLIPSE_TAR} 

#################################
#### Install Eclipse Plugins ####
#################################
# ... add Eclipse plugin - installation here (see example in https://github.com/DrSnowbird/papyrus-sysml-docker)

# (Ubutnu 20.0.04 having issue with this)
#RUN sudo apt-get update -y && sudo apt-get install -y libwebkitgtk-3.0-0

##################################
#### Set up user environments ####
##################################
VOLUME ${ECLIPSE_WORKSPACE}
VOLUME ${HOME}/.eclipse 

RUN mkdir -p ${HOME}/.eclipse ${ECLIPSE_WORKSPACE} && \
    sudo chown -R ${USER}:${USER} ${HOME} ${HOME}/.eclipse ${WORKSPACE}

##################################
#### VNC ####
##################################
WORKDIR ${HOME}

USER ${USER}

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]

##################################
#### ECLIPSE ####
##################################
WORKDIR ${ECLIPSE_WORKSPACE}

CMD ["/opt/eclipse/eclipse"]
