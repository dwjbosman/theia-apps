#!/bin/bash
source $HOME/.cargo/env
cd $HOME/theia_rust_extension/browser-app
yarn theia start $HOME --hostname=0.0.0.0

