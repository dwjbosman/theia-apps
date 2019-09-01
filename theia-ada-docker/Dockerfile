# Can't use node image, because it creates a user that conflicts
FROM ubuntu:18.04

RUN apt-get update -yq \
    && apt-get install -yq \
    curl gnupg build-essential gcc g++ gdb make python sudo git \
    # for gnat
    libdbus-1-3 libx11-dev libx11-xcb-dev libfontconfig \
    # for conda
    wget \
    # for building openocd
    libtool autotools-dev automake pkg-config \
    # for openocde stlink 
    libusb-1.0-0-dev \
    # for embedded dev
    gdb-multiarch qemu-system-arm \
    # for cargo-generate
    libssl1.0-dev 
# allow a user to become root in the container
ADD sudoers /etc/sudoers

RUN cd /root && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash Miniconda3-latest-Linux-x86_64.sh -b -p /root/miniconda

RUN cd /root && git clone https://github.com/AdaCore/libadalang

RUN cd /root && git clone https://github.com/AdaCore/ada_language_server.git

ARG GITHUB_TOKEN
ARG NODE_OPTIONS="--max-old-space-size=4096"
ARG NODE_VERSION=10

ADD install_node.sh /root/install_node.sh
RUN bash /root/install_node.sh --version $NODE_VERSION
ADD nvm_setup.sh /root/nvm_setup.sh

# install theia
ENV THEIA_APP_PATH /root/theia_app
RUN mkdir $THEIA_APP_PATH
RUN . /root/nvm_setup.sh && cd $THEIA_APP_PATH && yarn global add node-gyp
ADD next.package.json $THEIA_APP_PATH/package.json
RUN git clone https://github.com/eclipse-theia/theia-cpp-extensions.git /root/theia-cpp-extension
RUN cp -R /root/theia-cpp-extension/packages $THEIA_APP_PATH/.
RUN . /root/nvm_setup.sh && cd $THEIA_APP_PATH && yarn --cache-folder $THEIA_APP_PATH/ycache 
RUN . /root/nvm_setup.sh && cd $THEIA_APP_PATH/packages/cpp-debug && yarn --cache-folder $THEIA_APP_PATH/ycache 
RUN . /root/nvm_setup.sh && cd $THEIA_APP_PATH/packages/cortex-debug && yarn --cache-folder $THEIA_APP_PATH/ycache 
RUN . /root/nvm_setup.sh && cd $THEIA_APP_PATH && yarn theia build

# when creating a container a volume is mapped to /root/app
# to allow to make persistent changes
ENV APP_HOME /root/app

# ensure that a custom user who's member of the 'app' group
# is able to modify CARGO_HOME dir
RUN mkdir -p $APP_HOME && \
    groupadd -g 500 app && \
    chown root:app $APP_HOME && \
    chmod g+rwxs $APP_HOME 
R
# ADD build-env/openocd /root/openocd
# RUN cd /root/openocd && ./bootstrap && ./configure --enable-stlink && make && make install

EXPOSE 3000
ENV SHELL /bin/bash
# script to start theia
ADD run.sh /root/run.sh
# script to set environment
ADD bashrc /root/bashrc
RUN chmod 755 /root \
    && chmod 755 /root/bashrc
WORKDIR $THEIA_APP_PATH
ENV USER root
CMD [ "bash", "-rcfile", "/root/bashrc", "-i", "/root/run.sh" ]

