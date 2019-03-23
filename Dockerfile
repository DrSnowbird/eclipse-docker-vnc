FROM openkbs/jdk-mvn-py3-vnc

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

USER 0

## -------------------------------------------------------------------------------
## ---- USER_NAME is defined in parent image: openkbs/jdk-mvn-py3-x11 already ----
## -------------------------------------------------------------------------------
ENV USER_NAME=${USER_NAME:-developer}
ENV HOME=/home/${USER_NAME}
ENV WORKSPACE=${HOME}/workspace

## ----------------------------------------------------------------------------
## ---- To change to different Eclipse version: e.g., oxygen, change here! ----
## ----------------------------------------------------------------------------

## -- 1.) Eclipse version: oxygen, photon, etc.: -- ##
ARG ECLIPSE_VERSION=${ECLIPSE_VERSION:-photon}
ENV ECLIPSE_VERSION=${ECLIPSE_VERSION}

## -- 2.) Eclipse Type: -- ##
ARG ECLIPSE_TYPE=${ECLIPSE_TYPE:-jee}
#ARG ECLIPSE_TYPE=${ECLIPSE_TYPE:-modeling}

## -- 3.) Eclipse Release: -- ##
ARG ECLIPSE_RELEASE=${ECLIPSE_RELEASE:-R}
#ARG ECLIPSE_RELEASE=${ECLIPSE_RELEASE:-2}

## -- 4.) Eclipse Download Mirror site: -- ##
#ARG ECLIPSE_OS_BUILD=${ECLIPSE_OS_BUILD:-win32-x86_64}
ARG ECLIPSE_OS_BUILD=${ECLIPSE_OS_BUILD:-linux-gtk-x86_64}

## -- 5.) Eclipse Download Mirror site: -- ##
#http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-jee-photon-R-linux-gtk-x86_64.tar.gz
#http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-modeling-photon-R-linux-gtk-x86_64.tar.gz
ARG ECLIPSE_MIRROR_SITE_URL=${ECLIPSE_MIRROR_SITE_URL:-http://mirror.math.princeton.edu}

## ----------------------------------------------------------------------------------- ##
## ----------------------------------------------------------------------------------- ##
## ----------- Don't change below unless Eclipse download system change -------------- ##
## ----------------------------------------------------------------------------------- ##
## ----------------------------------------------------------------------------------- ##
## -- Eclipse TAR/GZ filename: -- ##
#ARG ECLIPSE_TAR=${ECLIPSE_TAR:-eclipse-jee-photon-R-linux-gtk-x86_64.tar.gz}
ARG ECLIPSE_TAR=${ECLIPSE_TAR:-eclipse-${ECLIPSE_TYPE}-${ECLIPSE_VERSION}-${ECLIPSE_RELEASE}-${ECLIPSE_OS_BUILD}.tar.gz}

## -- Eclipse Download route: -- ##
ARG ECLIPSE_DOWNLOAD_ROUTE=${ECLIPSE_DOWNLOAD_ROUTE:-pub/eclipse/technology/epp/downloads/release/${ECLIPSE_VERSION}/${ECLIPSE_RELEASE}}

## -- Eclipse Download full URL: -- ##
## e.g.: http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/
## e.g.: http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/
ARG ECLIPSE_DOWNLOAD_URL=${ECLIPSE_DOWNLOAD_URL:-${ECLIPSE_MIRROR_SITE_URL}/${ECLIPSE_DOWNLOAD_ROUTE}}

## http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-jee-photon-R-linux-gtk-x86_64.tar.gz
## http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-jee-photon-R-linux-gtk-x86_64.tar.gz
## http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-modeling-photon-R-linux-gtk-x86_64.tar.gz
WORKDIR /opt
RUN wget -q -c ${ECLIPSE_DOWNLOAD_URL}/${ECLIPSE_TAR} && \
    tar xvf ${ECLIPSE_TAR} && \
    rm ${ECLIPSE_TAR} 

#################################
#### Install Eclipse Plugins ####
#################################
# ... add Eclipse plugin - installation here (see example in https://github.com/DrSnowbird/papyrus-sysml-docker)

RUN apt-get update -y && apt-get install -y libwebkitgtk-3.0-0

##################################
#### Set up user environments ####
##################################
VOLUME ${WORKSPACE}
VOLUME ${HOME}/.eclipse 

RUN mkdir -p ${HOME}/.eclipse ${WORKSPACE} && \
    chown -R ${USER}:${USER} ${HOME} ${HOME}/.eclipse ${WORKSPACE}

##################################
#### VNC ####
##################################
WORKDIR ${HOME}

USER ${USER}

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]

##################################
#### ECLIPSE ####
##################################
WORKDIR ${WORKSPACE}

CMD ["/opt/eclipse/eclipse"]
