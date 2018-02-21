FROM alpine:latest
RUN apk update \
    && apk add jq \
    && rm -rf /var/cache/apk/* \
    && apk add --no-cache curl
COPY cf-export.sh /
CMD ["/cf-export.sh"]
