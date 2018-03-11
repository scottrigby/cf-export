FROM alpine:3.7
RUN apk --no-cache add jq curl
COPY cf-github-pr-export /usr/local/bin/
CMD ["cf-github-pr-export"]
