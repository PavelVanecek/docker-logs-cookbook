Handling logs from Docker containers
====================

**The situation**: You have multiple applications running on multiple machines. All of them run inside their Docker containers. Applications output some logs: be it debug, info, or error reporting.

**The problem**: You wish to store, read, and query the logs on one place.

**The solution**: ELK stack.

ELK stack
---------

*ELK* stands for
[*Elastic Search*](https://github.com/elastic/elasticsearch) (distributed search engine built on top of [Lucene](https://lucene.apache.org/)),
[*Logstash*](http://logstash.net/) (a tool for managing events and logs),
and [*Kibana*](https://github.com/elastic/kibana) (browser based analytics and search dashboard).

This stack is a state of the art solution for log management. It allows you to send logs to a single endpoint, yet scales well thanks to ElasticSearch and Lucene. It allows you to create GUI dasboards and graphs in Kibana, or consume JSON reports directly from ElasticSearch API.


                           ELK STACK                        +        USERS
                                                            |
                                                            |
                    +------------------+                    |   +--------------+
                    |                  |      GUI           |   |              |
                    |      Kibana      +------------------------>   browser    |
                    |                  |                    |   |              |
                    +---------^--------+                    |   +--------------+
                              |                             |
    +-------------------------+-------------------------+   |
    |                   Elastic Search                  |   |
    |                                                   |       +--------------+
    |  +------------+   +------------+  +------------+  |  API  |              |
    |  |            |   |            |  |            |  +------->  application |
    |  |   shard    |   |   shard    |  |   shard    |  |       |              |
    |  |            |   |            |  |            |  |   |   +--------------+
    |  +------------+   +------------+  +------------+  |   |
    +-------------------------^-------------------------+   |
                              |                             |
                   +----------+---------+                   |   +--------------+
                   |                    |      SYSLOG       |   |              |
                   |      Logstash      <-----------------------+    source    |
                   |                    |                   |   |              |
                   +--------------------+                   |   +--------------+
                                                            |
                                                            +


Connecting Docker containers to ELK = logspout
--------------

[*Logspout*](https://github.com/gliderlabs/logspout) (Log routing for Docker container logs) is a tool for gathering logs from all running Docker containers. Thanks to [logspout-logstash adapter](https://github.com/looplab/logspout-logstash) it connects seamlessly into logstash.

Logspout is the missing link between Docker and ELK. You just deploy one more container on your system and that is it; all logs are processed without the need to modify applications or containers.

Requirements for your Docker containers
---------------------------------------

If you wish to integrate your containers seamlessly with logspout, you need to make sure that:

- all applications log only to STDOUT and STDERR ([no files](https://github.com/jwilder/dockerize))
- all containers are running *[without the](https://github.com/gliderlabs/logspout/issues/22) [-t flag](https://github.com/gliderlabs/logspout/pull/78)*

```
+-----------------+  +-----------------+  +-----------------+  
|    container    |  |    container    |  |    container    |  
| +-------------+ |  | +-------------+ |  | +-------------+ |  
| | application | |  | | application | |  | | application | |  
| +------+------+ |  | +------+------+ |  | +------+------+ |  
|  STDOUT|STDERR  |  |  STDOUT|STDERR  |  |  STDOUT|STDERR  |
+--------v-----+--+  +-----+--v--------+  +---+----v--------+  
               |           |                  |
+--------------v-----------v------------------v-------------+  
|                                                           |  
|                    Logspout container                     |  
|                                                           |
+-----------------------------+-----------------------------+  
                              |
                              |            MY MACHINE
+-------------------------------------------------------------+
                              |           "THE CLOUD"
                    +---------v--------+
                    |                  |
                    |    ELK stack     |
                    |                  |
                    +------------------+
```

How to run the ELK stack
-------------------------

The easiest to run is the [`pblittle/docker-logstash`](https://github.com/pblittle/docker-logstash) image. It contains full configurable ELK stack.

The repository [README]((https://github.com/pblittle/docker-logstash) lists a few examples on running logstash. It however does not listen on syslog interface by default, so you have to enable it in configuration file and provide that one.

    # conf.d/logstash.conf snippet

    input {
      tcp {
        port => 5000
        type => syslog
      }

      udp {
        port => 5000
        type => syslog
      }
    }

    # ... more configs

Then you inject the config folder as a volume and open proper ports:

    docker run \
      -v `pwd`/conf.d/:/opt/logstash/conf.d \
      -p 5000:5000 \
      -p 5000:5000/udp \
      # ... other port forwards and params \
      pblittle/docker-logstash

See the `logstash` folder of this repo to see full running example.

> You can choose your own ports, either in logstash config or docker port forwarding settings. I am using 5000 both times as an example.

> I have not yet completed how to persist elastic search data. Stay tuned!

You have now the full ELK stack running. Verify this by visiting the Kibana dashboard:

    http://<elk_container_ip>:9292

How to connect your containers to logstash
------------------------------------------

First, read *Requirements for your Docker containers*.

See the `logspout` folder for running example.

Verify
------

You should now be able to see all logs from all your Docker containers in Kibana dashboards:

    http://<elk_container_ip>:9292

More tasks
----------
