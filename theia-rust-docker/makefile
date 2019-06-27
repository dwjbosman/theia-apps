.PHONY: get-files rm-files image clean-image run bash push pull

#call with THEIA_VERSION set to latest or next

HOST_NAME=$(shell hostname)

BACKUPS_DIR = /var/artifacts/configuration_management
REGISTRY=$(HOST_NAME):5000
REGISTRY_REMOTE=localhost:5001
DOCKER_IMAGE = theia_rust_image:latest
DOCKER_CONTAINER = theia_rust_container
BUILD_DIR = build-env
SHELL=/usr/bin/env bash

KERNEL:=$(shell uname -r)


identification:
	echo "Created from configurationmanagement repo, commit: " > $(BUILD_DIR)/identification.txt
	git rev-parse --verify HEAD >> $(BUILD_DIR)/identification.txt

# Performing get-files before 'make image' will force a rerun of all layers in the Dockerfile, because of changed file timestamps.
# You are hereby warned of the delay!
image: identification
	docker build --build-arg rust_channel=${RUST_CHANNEL} -t $(DOCKER_IMAGE) .

# This empty directory '$(BUILD_DIR)' exists in git, with only an .gitignore file, set to ignore the entire contents of the dir.
# This helps to avoid committing files in that dir to git.
rm-files:
	cd $(BUILD_DIR) && \
	find . ! -name '.gitignore' -type f -exec rm -f {} + && \
	find . ! -name '.gitignore' -type d -exec rm -rf {} + > /dev/null 2>&1 ; \
	exit 0

get-files: rm-files
	# Add these archived files from external sources to the current directory.
	# Docker will automatically extract them, during image building, with the ADD command.
	# TODO
	git clone git@github.com:theia-ide/theia-rust-extension.git $(BUILD_DIR)/theia_rust_extension


clean-image: get-files
	docker build --no-cache --build-arg rust_channel=${RUST_CHANNEL} -t $(DOCKER_IMAGE) .

push:
	docker tag ${DOCKER_IMAGE} ${REGISTRY}/${DOCKER_IMAGE}
	docker push ${REGISTRY}/${DOCKER_IMAGE}

pull:
	docker pull ${REGISTRY}/${DOCKER_IMAGE}
	docker tag ${REGISTRY}/${DOCKER_IMAGE} ${DOCKER_IMAGE}

transfer_remote:
	docker pull ${REGISTRY_REMOTE}/${DOCKER_IMAGE}
	docker tag ${REGISTRY_REMOTE}/${DOCKER_IMAGE} ${DOCKER_IMAGE}


