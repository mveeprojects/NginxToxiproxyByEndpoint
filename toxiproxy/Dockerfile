FROM alpine

RUN apk update
RUN apk upgrade
RUN apk add curl bash
COPY configure-toxiproxy.sh /config/
RUN chmod +x /config/configure-toxiproxy.sh
CMD ["/config/configure-toxiproxy.sh"]
