# Eclipse Photon VNC/noVNC dokcer 

[![](https://images.microbadger.com/badges/image/openkbs/eclipse-photon-vnc-docker.svg)](https://microbadger.com/images/openkbs/eclipse-photon-vnc-docker "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/openkbs/eclipse-photon-vnc-docker.svg)](https://microbadger.com/images/openkbs/eclipse-photon-vnc-docker "Get your own version badge on microbadger.com")

* Eclipse-Photon + Java 8 JDK + Maven 3.5 + Python 3.5 + Gradle + VNC/noVNC (Desktop GUI)

# NOTE: This docker default is providing latest Eclipse Photon instead of Oxygen and you can change it to build other versions!!!

# License Agreement
By using this image, you agree the [Oracle Java JDK License](http://www.oracle.com/technetwork/java/javase/terms/license/index.html).
This image contains [Oracle JDK 8](http://www.oracle.com/technetwork/java/javase/downloads/index.html). You must accept the [Oracle Binary Code License Agreement for Java SE](http://www.oracle.com/technetwork/java/javase/terms/license/index.html) to use this image.

# Components
* Eclipse Phonto JEE version (you can change if by change Dockerfile)
* java version "1.8.0_191"
  Java(TM) SE Runtime Environment (build 1.8.0_191-b12)
  Java HotSpot(TM) 64-Bit Server VM (build 25.191-b12, mixed mode)
* Apache Maven 3.5.3
* Python 3.5.2
* VNC / noVNC: for VNC Client/Viwer / Browser-based VNC (noVNC)
* Other tools: git wget unzip vim python python-setuptools python-dev python-numpy 

# Run (recommended for easy-start)
Image is pulling from openkbs/eclipse-photon-vnc-docker
```
./run.sh
```
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
VNC_RESOLUTION, default: 1920x1080 , e.g., change to 1280x1024
    -e VNC_RESOLUTION=1280x1024
VNC_PW, default: vncpassword , e.g., change to MySpecial!(Password%)
    -e VNC_PW=MySpecial!(Password%)
```
# Screen (Desktop) Resolution
Two ways to change Screen resolutions.

## 1.) Modify ./run.sh file
```
#VNC_RESOLUTION="1280x1024"
VNC_RESOLUTION="1920x1280"
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
Note that the default build docker is "photon" version. 
If you want to build older Eclipse like "oxygen", you can following instruction in next section
```
./build.sh
```

# Build (Older Eclipse, e.g. Oxygen)
Two ways (at least) to build:
## **Recommended**:
If you use command line "'**./build.sh**'", you can modify "'**./.env**' (old filename ./docker.env)" file and then, run "./build.sh" to build image
```
## -- Eclipse versions: photon, oxygen, etc.: -- ##
ECLIPSE_VERSION=photon
or
ECLIPSE_VERSION=oxygen
```
Then, 
```
./build/sh
```

# Configurations (Optional)
If you run "./run.sh" instead of "docker-compose up", you don't have to do anything as below.

* The container uses a default "/workspace" folder. 
* The script "./run.sh" will re-use or create the local folder in your $HOME directory with the path below to map into the docker's internal "/workspace" folder.
```
$HOME/data_docker/eclipse-photon-vnc-docker/workspace
```
The above configuration will ensure all your projects created in the container's "/workspace" being "persistent" in your local folder, "$HOME/data_docker/eclipse-photon-vnc-docker/workspace", for your repetitive restart docker container.


# Distributed Storage
This project provides simple host volumes. For using more advanced storage solutions, there are a few distributed cluster storage options available, e.g., Lustre (popular in HPC), GlusterFS, Ceph, etc.
* [Dockerfiles (CentOS, Fedora, Red Hat) for GlusterFS ](https://github.com/gluster/gluster-containers)
* [GlusterFS Quickstart](https://docs.gluster.org/en/latest/Quick-Start-Guide/Quickstart/)
* [Two Days of Pain or How I Deployed GlusterFS Cluster to Kubernetes](https://blog.lwolf.org/post/how-i-deployed-glusterfs-cluster-to-kubernetes/)
# See Also - Other docker-based IDE
* [openkbs/docker-atom-editor](https://hub.docker.com/r/openkbs/docker-atom-editor/)
* [openkbs/eclipse-photon-vnc-docker](https://hub.docker.com/r/openkbs/eclipse-photon-vnc-docker/)
* [openkbs/eclipse-oxygen-docker](https://hub.docker.com/r/openkbs/eclipse-oxygen-docker/)
* [openkbs/intellj-docker](https://hub.docker.com/r/openkbs/intellij-docker/)
* [openkbs/netbeans9-docker](https://hub.docker.com/r/openkbs/netbeans9-docker/)
* [openkbs/netbeans](https://hub.docker.com/r/openkbs/netbeans/)
* [openkbs/papyrus-sysml-docker](https://hub.docker.com/r/openkbs/papyrus-sysml-docker/)
* [openkbs/pycharm-docker](https://hub.docker.com/r/openkbs/pycharm-docker/)
* [openkbs/scala-ide-docker](https://hub.docker.com/r/openkbs/scala-ide-docker/)
* [openkbs/sublime-docker](https://hub.docker.com/r/openkbs/sublime-docker/)
* [openkbs/webstorm-docker](https://hub.docker.com/r/openkbs/webstorm-docker/)

# Resources - JBoss
* [JBoss Tools Integration Stacks 4.6.0.Final](https://tools.jboss.org/downloads/jbosstools_is/photon/4.6.0.Final.html#update_site)
* [Containerize Teiid linked with MariaDB](https://developer.jboss.org/wiki/QuickstartExampleWithDockerizedTeiid)
* [Teiid Downloads](http://teiid.jboss.org/downloads/)
* [Teiid Designer 11.1 with Eclipse Oxygen](http://teiiddesigner.jboss.org/designer_summary/downloads.html)
* [Teiid Cloud - Data Virtualization Services](http://teiid.io/teiid_cloud/)
* [Deploying Teiid VDB](http://teiid.github.io/teiid-documents/master/content/admin/Deploying_VDBs.html)
* [JBoss Tools Integration Stack 4.6.0.Final](https://tools.jboss.org/downloads/jbosstools_is/photon/4.6.0.Final.html)


