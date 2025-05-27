#!/bin/bash

# Sleep for 5 seconds to ensure Toxiproxy is ready
sleep 5

# Update the toxicity configuration for the WireMock proxy (wiremock_b)
curl -X POST -d '{"type" : "latency", "attributes" : {"latency" : 5000}}' http://toxiproxy:8474/proxies/wiremock_b/toxics