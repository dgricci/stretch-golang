% Environnement GoLang  
% Didier Richard  
% 2019/03/22

---

revision:
    - 1.0.0 : 2018/08/30 : golang 1.11  
    - 1.0.1 : 2019/01/13 : golang 1.11.4  
    - 1.1.0 : 2019/02/27 : golang 1.12  
    - 1.1.1 : 2019/02/27 : golang 1.12.1  

---

# Building #

```bash
$ docker build -t dgricci/golang:$(< VERSION) .
$ docker tag dgricci/golang:$(< VERSION) dgricci/golang:latest
```

## Behind a proxy (e.g. 10.0.4.2:3128) ##

```bash
$ docker build \
    --build-arg http_proxy=http://10.0.4.2:3128/ \
    --build-arg https_proxy=http://10.0.4.2:3128/ \
    -t dgricci/golang:$(< VERSION) .
$ docker tag dgricci/golang:$(< VERSION) dgricci/golang:latest
```

## Build command with arguments default values ##

```bash
$ docker build \
    --build-arg GOLANG_VERSION=1.12.1 \
    --build-arg GOLANG_DOWNLOAD_URL=https://golang.org/dl/go1.12.1.linux-amd64.tar.gz \
    --build-arg GOLANG_DOWNLOAD_SHA256=2a3fdabf665496a0db5f41ec6af7a9b15a49fbe71a85a50ca38b1f13a103aeec \
    -t dgricci/golang:$(< VERSION) .
$ docker tag dgricci/golang:$(< VERSION) dgricci/golang:latest
```

# Use #

See `dgricci/stretch` README for handling permissions with dockers volumes.

```bash
$ docker run -it --rm dgricci/golang:$(< VERSION)
go version go1.12.1 linux/amd64
```

## An example ##

### run ###

```bash
$ mkdir -p test test/{bin,pkg,src} test/src/hello
$ cd test
$ cat > ./src/hello/world.go <<- EOF
package main

import "fmt"

func main() {
    fmt.Println("hello world")
}
EOF
$ tree .
.
├── bin
├── pkg
└── src
    └── hello
        └── world.go

4 directories, 1 files
$ docker run -i --rm -v `pwd`:/go -w/go/src/hello -e USER_ID=`id -u` dgricci/golang go run world.go
hello world
```

### build ###

Let's suppose that the env variable GOPATH points at the current directory :

```bash
$ pwd
/home/dgricci/test
$ echo $GOPATH
/home/dgricci/test
$ cd src/hello
$ docker run --rm -v${GOPATH}:/go -w/go${PWD##${GOPATH}} -e USER_ID=`id -u` -e USER_NAME=`whoami` dgricci/golang:$(< VERSION) go build world.go
$ ./world
hello world
```

## Tests ##

Just launch `golang.bats` (once `bats`[^bats] is installed on your system) :

```bash
$ ./golang.bats --tap
1..3
ok 1 check golang ok
ok 2 run hello world
ok 3 build hello world then launch
```

## A shell to hide container's usage ##

As a matter of fact, typing the `docker run ...` long command is painfull !  
In the [bin directory, the go.sh bash shell](bin/go.sh) can be invoked to ease
the use of such a container. For instance (we suppose that the shell script
has been copied in a bin directory and is in the user's PATH) :

```bash
$ cd whatever/bin
$ ln -s go.sh go
$ ln -s go.sh godoc
$ ln -s go.sh gofmt
$ ln -s go.sh golint
$ ln -s go.sh dep
$ cd $GOPATH
$ go version
go version go1.12.1 linux/amd64
```

One can then get the golang standard library documentation locally :

```bash
$ godoc -http=:6060
dd6c108f994494665fb87bca445a776e646bf003a2195840250929ad91eb6c52
$ firefox http://localhost:6060
```

Don't forget to stop and remove the container after usage :

```bash
$ docker stop dd6c108f9944
dd6c108f9944
$ docker rm dd6c108f9944
dd6c108f9944
```

__Et voilà !__


_fin du document[^pandoc_gen]_

[^pandoc_gen]: document généré via $ `pandoc -V fontsize=10pt -V geometry:"top=2cm, bottom=2cm, left=1cm, right=1cm" -s -N --toc -o golang.pdf README.md`{.bash}

