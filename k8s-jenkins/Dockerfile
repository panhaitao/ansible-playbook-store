FROM jenkinsci/blueocean
USER root
RUN apt-get update 

ARG dockerGid=999
RUN echo "docker:x:${dockerGid}:jenkins" >> /etc/group
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
