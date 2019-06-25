ARG NODE_VERSION=8
FROM node:${NODE_VERSION}-stretch

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
RUN . $HOME/.cargo/env && rustup toolchain install $rust_channel
RUN . $HOME/.cargo/env && rustup default $rust_channel
RUN . $HOME/.cargo/env && rustup component add rls rust-analysis rust-src
RUN . $HOME/.cargo/env && cargo +$rust_channel install racer

#can't use $HOME env var
ADD build-env/theia_rust_extension /root/theia_rust_extension
RUN cd $HOME/theia_rust_extension && npm install
RUN cd $HOME/theia_rust_extension && yarn

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
#ENTRYPOINT [ "/root/run.sh" ]
#WORKDIR $HOME/theia_rust_extension/browser-app
#ENTRYPOINT [ "yarn", "theia", "start", "/home/project", "--hostname=0.0.0.0" ]
