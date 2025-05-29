#!/bin/bash

sleep 5

curl -X POST -d '{"type" : "latency", "attributes" : {"latency" : 2000}}' http://toxiproxy:8474/proxies/wiremock_foo/toxics
curl -X POST -d '{"type" : "latency", "attributes" : {"latency" : 5000}}' http://toxiproxy:8474/proxies/wiremock_bar/toxics
