# NginxToxiproxyByEndpoint

**Problem statement:** You want to run chaos tests with different timeouts for different endpoints on the _**same**_ downstream service. Toxiproxy provides only service-level latency and downtime simulation, but we would like the flexibility to simulate network latency and service downtime on a per-endpoint basis, to match our needs (without needing to make significant chaos-specific config change to the client/service that's making the request to achieve this).

This example is an experiment in using NGINX as a reverse-proxy to route requests to WireMock, via Toxiproxy. This is achieved by having NGINX route traffic to Toxiproxy ports based on path, with Toxiproxy applying toxicity based on port, then forwarding the now-toxic request to WireMock. This enables us to simulate per-endpoint latency or downtime,

![nginx_wiremock_rev_proxy.jpg](images/nginx_wiremock_rev_proxy.jpg)

### To run this example locally

```shell
docker compose down && docker compose up -d
```

Once running, you can check the latencies added by toxiproxy by calling either `http://localhost/foo` (+2 second latency) or `http://localhost/bar` (+5 second latency).

### Checking Toxiproxy configuration

**Note:** This does not work in the browser due to an [issue](https://github.com/Shopify/toxiproxy/issues/219) with User-Agent in Toxiproxy.

Request:
```shell
curl http://localhost:8474/proxies
```

Response:
```json
{
  "wiremock_bar": {
    "name": "wiremock_bar",
    "listen": "[::]:8081",
    "upstream": "wiremock:8080",
    "enabled": true,
    "Logger": {},
    "toxics": []
  },
  "wiremock_foo": {
    "name": "wiremock_foo",
    "listen": "[::]:8080",
    "upstream": "wiremock:8080",
    "enabled": true,
    "Logger": {},
    "toxics": []
  }
}
```

### Toxiproxy configurator 

This is a simple container to configure toxics in the local Toxiproxy container. If you make any changes to the Toxiproxy configuration, you will need to make sure the previous image is deleted (`docker rmi toxiproxy_configurator_image_ref`) else your changes will not be applied.

### Manually configuring toxicity on Toxiproxy via curl

Request:
```shell
curl -X POST -d '{"type" : "latency", "attributes" : {"latency" : 10000}}' http://localhost:8474/proxies/wiremock_foo/toxics
```

Response:
```json
{
  "attributes": {
    "latency": 10000,
    "jitter": 0
  },
  "name": "latency_downstream",
  "type": "latency",
  "stream": "downstream",
  "toxicity": 1
}
```

### Sources:
- [NGINX Docs: NGINX Reverse Proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/).
- [Medium: ToxiProxy — Testing automated chaos scenarios](https://medium.com/@mustafautku_79071/toxiproxy-testing-automated-chaos-scenarios-d5d9a3f3083c).
- [GitHub: Toxiproxy](https://github.com/Shopify/toxiproxy).
- [GitHub: johnmuth/toxiproxy-docker-compose-example](https://github.com/johnmuth/toxiproxy-docker-compose-example).
