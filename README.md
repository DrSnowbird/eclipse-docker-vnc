# Eclipse '2021-03' IDE Docker Container + OpenJDK Java 11 + Maven 3 + Python 3 + pip 21 + node 16 + npm 7 + Gradle 6  + VNC/noVNC 
[![](https://images.microbadger.com/badges/image/openkbs/eclipse-photon-docker.svg)](https://microbadger.com/images/openkbs/eclipse-photon-docker "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/openkbs/eclipse-photon-docker.svg)](https://microbadger.com/images/openkbs/eclipse-photon-docker "Get your own version badge on microbadger.com")

[![](https://images.microbadger.com/badges/image/openkbs/eclipse-docker-vnc.svg)](https://microbadger.com/images/openkbs/eclipse-docker-vnc "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/openkbs/eclipse-docker-vnc.svg)](https://microbadger.com/images/openkbs/eclipse-docker-vnc "Get your own version badge on microbadger.com")

# NOTE: This docker default is providing latest Eclipse Photon instead of Oxygen and you can change it to build other versions!!!

# Components
* Eclipse '2021-03' the latest Modeling or JEE version (you can change if by change .env and then use './build.sh' to build locally)
* Base Components (e.g., Maven, Java, NodeJS, etc.)
  * See [openkbs/jdk-mvn-py3 - Components](https://github.com/DrSnowbird/jdk-mvn-py3/blob/master/README.md#Components)
  * See [openkbs/jdk-mvn-py3 - Releases Information](https://github.com/DrSnowbird/jdk-mvn-py3/blob/master/README.md#Releases-information)

# Run (recommended for easy-start)
Image is pulling from openkbs/eclipse-docker-vnc
```
./run.sh
```

## Mobile devices and Desktop PC supported / tested:
* SmartPhones: tested ok! iPhone5 Safari works though phone screen size being too small vs the desired HD 1920x1080. It should work across all the smartphones with HTML5-capable brwosers. Hence, to access with small phone screen, run with VNC_RESOLUTION=800x600 (or adjust it to fit your phone's screen size)
* Tablets: tested ok! Amazon Fire with noVNC works!. It should work across all the tablets with HTML5-capable brwosers.
![Eclipse Photon on Amazon Fire tablet](doc/eclipse-photon-docker-on-Amazon-Fire-tablet.jpeg).
* Desktop PC or MacBook: tested ok! It should work across all PCs Desktop with HTML5-capable brwosers. ![Eclipse Photon on Desktop PC Browser](doc/eclipse-docker-vnc-on-Desktop-PC-Browser.png)

## Connect to VNC Viewer/Client or noVNC (Browser-based VNC)
* connect via VNC viewer localhost:5901, default password: vncpassword
* connect via noVNC HTML5 full client: http://localhost:6901/vnc.html, default password: vncpassword
* connect via noVNC HTML5 lite client: http://localhost:6901/?password=vncpassword

Once it is up, the default password is "vncpassword" to access with your web browser:
```
http://<ip_address>:6901/vnc.html,
e.g.
=> Standalone Docker: http://localhost:6901/vnc.html
=> Openshift Container Platform: http://<route-from-openshift>/vnc.html
=> similarly for Kubernetes Container Platform: (similar to the Openshift above!)
```
# Run - Override VNC environment variables 
The following VNC environment variables can be overwritten at the docker run phase to customize your desktop environment inside the container. You can change those variables using configurations CLI or Web-GUI with OpenShift, Kubernetes, DC/OS, etc.
```
VNC_COL_DEPTH, default is 24 , e.g., change to 16,
    -e VNC_COL_DEPTH=16
VNC_RESOLUTION, default: 1920x1080 , e.g., change to 1024x800
    -e VNC_RESOLUTION=1280x1024
VNC_PW, default: vncpassword , e.g., change to MySpecial!(Password%)
    -e VNC_PW=MySpecial!(Password%)
```
# Screen (Desktop) Resolution
Two ways to change Screen resolutions.

## 1.) Modify ./run.sh file
```
#VNC_RESOLUTION=1280x1024
VNC_RESOLUTION=1920x1080
```

## 2.) Customize Openshift or Kubernetes container run envionrment
```
Set up, say, VNC_RESOLUTION with value 1920x1280
```

# Base the image to build add-on components

```Dockerfile
FROM openkbs/jdk-mvn-py3-vnc
```

# Build
You can build your own image locally.
Note that the default build docker is "latest" version. 
If you want to build older Eclipse like "photon", "oxygen", you can following instruction in next section
```
./build.sh
```

# Build (Older Eclipse, e.g. Photon, Oxygen)
Two ways (at least) to build:
### Way-1 (**Recommended**):
If you use command line "'**./build.sh**'", you can modify "'**./.env**' (old filename ./.env)" file and then, run "./build.sh" to build image
```
## -- Eclipse versions: photon, oxygen, etc.: -- ##
ECLIPSE_VERSION=photon
or
ECLIPSE_VERSION=oxygen
```
Then, 
```
./build.sh
```
### Way-2: (not recommended - to avoid breaking Dockerfile!)
Modify the line in '**./Dockefile**' as below if you use '**docker-compose**' or Openshift CI/CD. That is, you are not using command line '**./build.sh**' to build container image.
```
## -- Eclipse versions: photon, oxygen, etc.: -- ##
ENV ECLIPSE_VERSION=${ECLIPSE_VERSION:-photon}
or
ENV ECLIPSE_VERSION=${ECLIPSE_VERSION:-oxygen}
```
Then, 
```
docker-compose up -d 
```
# Configurations (Optional - mostly you don't have to do this!)
If you run "./run.sh" instead of "docker-compose up", you don't have to do anything as below.

* The container uses a default "/workspace" folder. 
* The script "./run.sh" will re-use or create the local folder in your $HOME directory with the path below to map into the docker's internal "/workspace" folder.
```
$HOME/data_docker/eclipse-docker-vnc/workspace
```
The above configuration will ensure all your projects created in the container's "/workspace" being "persistent" in your local folder, "$HOME/data_docker/eclipse-photon-docker/workspace", for your repetitive restart docker container.

### Create Customized Volume Mapping for "docker-compose"
You can create your own customzied host file mapping, e.g.
```
mkdir -p <my_host_directory>/.eclipse 
mkdir -p <my_host_directory>/eclipse-workspace
```
Then, run docker-comp
```
docker-compose up -d
```
# Distributed Storage
This project provides simple host volumes. For using more advanced storage solutions, there are a few distributed cluster storage options available, e.g., Lustre (popular in HPC), GlusterFS, Ceph, etc.
* [Dockerfiles (CentOS, Fedora, Red Hat) for GlusterFS ](https://github.com/gluster/gluster-containers)
* [GlusterFS Quickstart](https://docs.gluster.org/en/latest/Quick-Start-Guide/Quickstart/)
* [Two Days of Pain or How I Deployed GlusterFS Cluster to Kubernetes](https://blog.lwolf.org/post/how-i-deployed-glusterfs-cluster-to-kubernetes/)
# See Also - Other docker-based IDE
er/)
* [openkbs/eclipse-docker-vnc](https://hub.docker.com/r/openkbs/eclipse-docker-vnc/)
* [openkbs/intellj-docker](https://hub.docker.com/r/openkbs/intellij-docker/)
* [openkbs/intellj-vnc-docker](https://hub.docker.com/r/openkbs/intellij-vnc-docker/)
* [openkbs/knime-vnc-docker](https://hub.docker.com/r/openkbs/knime-vnc-docker/)
* [openkbs/netbeans-docker](https://hub.docker.com/r/openkbs/netbeans-docker/)
* [openkbs/papyrus-sysml-docker](https://hub.docker.com/r/openkbs/papyrus-sysml-docker/)
* [openkbs/pycharm-docker](https://hub.docker.com/r/openkbs/pycharm-docker/)
* [openkbs/rapidminer-docker](https://cloud.docker.com/u/openkbs/repository/docker/openkbs/rapidminer-docker)
* [openkbs/scala-ide-docker](https://hub.docker.com/r/openkbs/scala-ide-docker/)
* [openkbs/sublime-docker](https://hub.docker.com/r/openkbs/sublime-docker/)
* [openkbs/webstorm-docker](https://hub.docker.com/r/openkbs/webstorm-docker/)
* [openkbs/webstorm-vnc-docker](https://hub.docker.com/r/openkbs/webstorm-vnc-docker/)

# Resources - JBoss
* [JBoss Tools Integration Stacks 4.6.0.Final](https://tools.jboss.org/downloads/jbosstools_is/photon/4.6.0.Final.html#update_site)
* [Containerize Teiid linked with MariaDB](https://developer.jboss.org/wiki/QuickstartExampleWithDockerizedTeiid)
* [Teiid Downloads](http://teiid.jboss.org/downloads/)
* [Teiid Designer 11.1 with Eclipse Oxygen](http://teiiddesigner.jboss.org/designer_summary/downloads.html)
* [Teiid Cloud - Data Virtualization Services](http://teiid.io/teiid_cloud/)
* [Deploying Teiid VDB](http://teiid.github.io/teiid-documents/master/content/admin/Deploying_VDBs.html)
* [JBoss Tools Integration Stack 4.6.0.Final](https://tools.jboss.org/downloads/jbosstools_is/photon/4.6.0.Final.html)


# Releases information
  * See [openkbs/jdk-mvn-py3](https://github.com/DrSnowbird/jdk-mvn-py3/blob/master/README.md#Releases-information)

