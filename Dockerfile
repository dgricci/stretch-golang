## Dockerfile for golang environment
FROM dgricci/dev:1.0.0
MAINTAINER Didier Richard <didier.richard@ign.fr>
LABEL       version="1.1.1" \
            golang="1.13.3" \
            os="Debian Stretch" \
            description="Golang"

## different versions - use argument when defined otherwise use defaults
ARG GOLANG_VERSION
ENV GOLANG_VERSION ${GOLANG_VERSION:-1.13.3}
ARG GOLANG_DOWNLOAD_URL
ENV GOLANG_DOWNLOAD_URL ${GOLANG_DOWNLOAD_URL:-https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz}
ARG GOLANG_DOWNLOAD_SHA256
ENV GOLANG_DOWNLOAD_SHA256 ${GOLANG_DOWNLOAD_SHA256:-0804bf02020dceaa8a7d7275ee79f7a142f1996bfd0c39216ccb405f93f994c0}
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV GOBIN  $GOPATH/bin
ENV PATH $GOBIN:$GOROOT/bin:$PATH

COPY build.sh /tmp/build.sh

## install golang, then the sudo version in ... golang !
RUN /tmp/build.sh && rm -f /tmp/build.sh

WORKDIR $GOPATH

# default command : prints go version and exits
CMD ["go", "version"]

