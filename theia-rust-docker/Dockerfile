#ARG NODE_VERSION=8
#FROM node:${NODE_VERSION}-stretch

FROM ubuntu:18.04

RUN apt-get update -yq \
    && apt-get install curl gnupg gcc g++ make python sudo -yq 

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -yq \
    && apt-get install yarn -yq 

ADD sudoers /etc/sudoers

#RUN apt-get update -yq \
#    && curl -sL https://deb.nodesource.com/setup_10.x | bash \
#    && apt-get install yarn -yq 


#RUN apt-get update \
#    && apt-get install -y python python-dev python-pip \
#    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*
#
#RUN pip install \
#    python-language-server \
#    flake8 \
#    autopep8

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/sh.rustup.rs && sh /tmp/sh.rustup.rs -y

ARG rust_channel=nightly
RUN . /root/.cargo/env && rustup toolchain install $rust_channel
RUN . /root/.cargo/env && rustup default $rust_channel
RUN . /root/.cargo/env && rustup component add rls rust-analysis rust-src
RUN . /root/.cargo/env && cargo +$rust_channel install racer

ADD build-env/theia_rust_extension /root/theia_rust_extension
#RUN cd /root/theia_rust_extension && npm install

RUN cd /root/theia_rust_extension && yarn

#RUN cd $HOME/theia_rust_extension && npm install
#RUN cd $HOME/theia_rust_extension && npm i -D inversify && npm i @theia/languages

#RUN cd $HOME/theia_rust_extension && yarn prepare
#RUN cd $HOME/theia_rust_extension && yarn build
#RUN cd $HOME/theia_rust_extension && yarn rebuild:browser
#cd browser-app
#yarn start


#ARG theia_version=latest
#ADD $theia_version.package.json ./package.json
#ARG GITHUB_TOKEN
#RUN yarn --cache-folder ./ycache && rm -rf ./ycache
#RUN yarn theia build
EXPOSE 3000
ENV SHELL /bin/bash
ADD run.sh /root/run.sh
ADD start.sh /root/start.sh
RUN chmod 755 /root \
    && chmod 755 /root/start.sh
#ENTRYPOINT [ "/root/run.sh" ]
#WORKDIR $HOME/theia_rust_extension/browser-app
#ENTRYPOINT [ "yarn", "theia", "start", "/home/project", "--hostname=0.0.0.0" ]
