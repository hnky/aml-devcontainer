FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server
RUN apt-get install software-properties-common sudo -y 
RUN apt-get install python3.9 sudo -y 
RUN apt-get install python3-pip sudo -y 
RUN apt-get install git sudo -y 
RUN apt-get install curl sudo -y 
RUN apt-get install zip sudo -y 
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash 
RUN az extension add -n ml --system -y | sudo bash 
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg 
RUN sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg 
RUN sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list' 

RUN mkdir /var/run/sshd
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 workshop
RUN echo 'workshop:reactor22' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]