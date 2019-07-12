# Theia with Rust support

## Building the image

RUST\_CHANNEL=nightly make image

## Start Theia

1. cd to a folder in your home dir.

eg. cd to the example\_workspace folder.
  
2. Start editor

<pre>ex\_theia</pre>

This creates a container and mounts your home dir. It creates a user inside the container with matching UID/GID so that you can edit files without corrupting permissions. A volume rust-cargo-vol is created in which the rust environment is stored. This will allow you to persistently install crates etc. across container life cycles.

## Bash inside the container

3. Start a bash within the container

<pre>ex\_bash</pre>

4. Run a single command in the container

You can run a single command in side the container:

<pre>ex "...command..."</pre>

eg.

<pre>ex "cargo --list"</pre>

## Example project

A very simple rust example project is included in the example_project folder. It contains a build task and debug configuration which uses rust-gdb.


