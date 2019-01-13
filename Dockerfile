## Dockerfile for golang environment
FROM dgricci/dev:1.0.0
MAINTAINER Didier Richard <didier.richard@ign.fr>
LABEL       version="1.0.1" \
            golang="1.11.4" \
            os="Debian Stretch" \
            description="Golang"

## different versions - use argument when defined otherwise use defaults
ARG GOLANG_VERSION
ENV GOLANG_VERSION ${GOLANG_VERSION:-1.11.4}
ARG GOLANG_DOWNLOAD_URL
ENV GOLANG_DOWNLOAD_URL ${GOLANG_DOWNLOAD_URL:-https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz}
ARG GOLANG_DOWNLOAD_SHA256
ENV GOLANG_DOWNLOAD_SHA256 ${GOLANG_DOWNLOAD_SHA256:-fb26c30e6a04ad937bbc657a1b5bba92f80096af1e8ee6da6430c045a8db3a5b}
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

