# NginxProxyByEndpoint

**Problem statement:** imagine a situation where circuit breakers are in place with different timeouts for different endpoints. Toxiproxy provides only service-level latency and downtime simulation, but we need to simulate network latency and service downtime on a per-endpoint basis, to match our circuit breaker configuration.

This example is an experiment in using NGINX as a reverse-proxy to route requests to different wiremock servers, based on the path of the request. Then setting up Toxiproxy to apply latency or downtime toxicity to the wiremock servers, this will enable us to simulate per-endpoint latency or downtime, which therefore helps if circuit breakers are configured to open at different timeouts for different endpoints.

![nginx_wiremock_rev_proxy.jpg](images/nginx_wiremock_rev_proxy.jpg)

### To run this example

```shell
docker compose down && docker compose up -d
```

### To check Toxiproxy proxy configuration

**Note:** This does not work in the browser due to an [issue](https://github.com/Shopify/toxiproxy/issues/219) with User-Agent in Toxiproxy.

Request:
```shell
curl http://localhost:8474/proxies
```

Response:
```json
{
  "wiremock_a": {
    "name": "wiremock_a",
    "listen": "[::]:8080",
    "upstream": "wiremock_a:8080",
    "enabled": false,
    "Logger": {},
    "toxics": []
  },
  "wiremock_b": {
    "name": "wiremock_b",
    "listen": "[::]:8081",
    "upstream": "wiremock_b:8081",
    "enabled": false,
    "Logger": {},
    "toxics": []
  }
}
```

### Sources:
- [NGINX Docs: NGINX Reverse Proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/).
- [GitHub: Toxiproxy](https://github.com/Shopify/toxiproxy).
- [Medium: ToxiProxy — Testing automated chaos scenarios](https://medium.com/@mustafautku_79071/toxiproxy-testing-automated-chaos-scenarios-d5d9a3f3083c).