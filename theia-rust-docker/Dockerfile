#Can't use node image, because it creates a user that conflicts
FROM ubuntu:18.04

RUN apt-get update -yq \
    && apt-get install curl gnupg build-essential gcc g++ gdb make python sudo git -yq 

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -yq \
    && apt-get install yarn -yq 

#allow a user to become root in the container
ADD sudoers /etc/sudoers

ARG GITHUB_TOKEN


ARG NODE_OPTIONS="--max-old-space-size=4096"
#ENV NODE_OPTIONS $node_options

#install theia
RUN mkdir /root/theia_rust_extension
RUN cd /root/theia_rust_extension && yarn global add node-gyp
ADD next.package.json /root/theia_rust_extension/package.json
RUN git clone https://github.com/eclipse/theia-cpp-extension.git /root/theia-cpp-extension
RUN cp -R /root/theia-cpp-extension/packages /root/theia_rust_extension/.


#ENV NODE_MAX_MEM=3000
RUN cd /root/theia_rust_extension && yarn --cache-folder /root/theia_rust_extension/ycache 
RUN cd /root/theia_rust_extension/packages/cpp-debug && yarn --cache-folder /root/theia_rust_extension/ycache 
#&& rm -rf /root/theia_rust_extenstion/ycache

##&& rm -rf /root/theia_rust_extenstion/ycache
RUN free -h
RUN ps aux --sort -rss
RUN cd /root/theia_rust_extension && yarn theia build

# when creating a container a volume is mapped to /root/rust
# to allow to make persistent changes
ARG rust_channel=nightly
ENV RUSTUP_HOME /root/rust/rustup
ENV CARGO_HOME /root/rust/cargo

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/sh.rustup.rs && sh /tmp/sh.rustup.rs -y

#install language server dependencies for theia
RUN . /root/rust/cargo/env && rustup toolchain install $rust_channel
RUN . /root/rust/cargo/env && rustup default $rust_channel
RUN . /root/rust/cargo/env && rustup component add rust-src rust-docs rls rust-analysis rustfmt clippy


RUN . /root/rust/cargo/env && cargo +$rust_channel install racer

EXPOSE 3000
ENV SHELL /bin/bash
# script to start theia
ADD run.sh /root/run.sh
# script to set environment
ADD bashrc /root/bashrc
RUN chmod 755 /root \
    && chmod 755 /root/bashrc
