# Can't use node image, because it creates a user that conflicts
FROM ubuntu:18.04

RUN apt-get update -yq \
    && apt-get install -yq \
    curl gnupg build-essential gcc g++ gdb make python sudo git \
    # for gnat community?
    # libdbus-1-3 libx11-dev libx11-xcb-dev libfontconfig \
    # gnat ada
    gnat \
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
RUN /root/miniconda/conda --init
RUN conda create gnat_env python=2


RUN cd /root && git clone https://github.com/AdaCore/libadalang
ADD install-lal-and-deps.sh /root/libadalang

RUN mkdir /root/ada/tools
RUN cd /root/ada/build_tools && git clone https://github.com/AdaCore/xmlada.git
RUN cd /root/ada/build_tools && git clone https://github.com/AdaCore/gprbuild.git

ADD gprbuild/Makefile /root/ada/build_tools/gprbuild/Makefile
RUN cd /root/ada/build_tools && export GNATMAKEFLAGS=-gnatE && bash bootstrap.sh --with-xmlada=../xmlada --prefix=./bootstrap

RUN cd /root/ada/build_tools/xmlada && export PATH=$PATH:/root/ada/build_tools/gprbuild/bootstrap/bin && ./configure && make install prefix=/root/ada/adalib && make install-static prefix=/root/ada/adalib
RUN cd /root/ada/build_tools/gprbuild && \
    ln -sf /root/ada/build_tools/xmlada && \
    make prefix=/root/ada/adalib SOURCE_DIR=/root/ada/build_tools/gprbuild setup && \
    PATH=$PATH:/root/ada/build_tools/gprbuild/bootstrap/bin GPR_PROJECT_PATH=xmlada/xmlada_install/share/gpr make && \
    make install && \ 
    make libgpr.build.static && \
    make libgpr.install.static

RUN cd /root/ada/build_tools && git clone https://github.com/AdaCore/gnatcoll-core)
RUN cd /root/ada/build_tools/gnatcoll-core && \
    GPR_PROJECT_PATH=/root/ada/adalib/share/gpr make PROCESSORS=0 prefix=/root/ada/adalib LIBRARY_TYPES=static build install 

RUN cd /root/ada/build_tools && git clone https://github.com/AdaCore/gnatcoll-bindings

RUN cd /root/ada/build_tools && git clone https://github.com/AdaCore/langkit
#TODO checkout correct branch
RUN source /opt/conda/activate gnat_env && pip install -r /root/ada/build_tools/langkit/REQUIREMENTS.dev

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

