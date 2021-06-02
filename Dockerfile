FROM nginx:latest

MAINTAINER Mobydev

WORKDIR /usr/share/nginx/html

RUN apt-get update -y

RUN apt install git -y &&\
    git init &&\
    git clone https://github.com/roninua/devops

RUN cd devops

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -

RUN apt install -y nodejs

RUN cd devops && npm install

RUN npm install -g @angular/cli 

RUN cd devops && ng build

RUN cd devops/dist/devops && cp -R --force . /usr/share/nginx/html

ENTRYPOINT  ["nginx", "-g", "daemon off;"]

