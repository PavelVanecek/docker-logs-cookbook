Logspout
========

[Logspout](https://github.com/gliderlabs/logspout) is a log routing tool for Docker container logs.

Then, run your logspout container. You want to use the [`logspout-logstash adapter`](https://github.com/looplab/logspout-logstash). To do so, you have to build your own image. This is [described in logspout repository](https://github.com/gliderlabs/logspout/tree/master/custom).

The input is a docker socket file, usually `/var/run/docker.sock`. You specify it by using the `-v` flag.

The output is syslog interface IP:port. You specify it as the last argument when running the container.

Structure
---------

Please consider these files as templates. Fork and modify as appropriate.

### `Dockerfile`

Enables building custom image that uses the `modules.go` file. See the [logspout repository](https://github.com/gliderlabs/logspout/tree/master/custom) for details.

### `modules.go`

List of modules to install.

### `build.sh`

Builds the Dockerfile and assigns tag.

### `run.sh`

Runs the container with all settings and parameters.
