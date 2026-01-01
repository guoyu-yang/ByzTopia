FROM ubuntu:18.04

RUN apt-get update && apt-get install -y iproute2 make net-tools iperf\
  && rm -rf /var/lib/apt/lists/*


COPY go1.15.14.linux-amd64.tar.gz /tmp/
RUN tar -C /usr/local -xzf /tmp/go1.15.14.linux-amd64.tar.gz && \
  rm /tmp/go1.15.14.linux-amd64.tar.gz


ENV BASE_DIR="/home/fin"

WORKDIR $BASE_DIR


ENV PATH $PATH:/usr/local/go/bin

COPY . $BASE_DIR/

RUN export GOPATH=$PWD&&export GOBIN=$PWD/bin&&export GO111MODULE=off
RUN export GRPC_GO_LOG_VERBOSITY_LEVEL=99&&export GRPC_GO_LOG_SEVERITY_LEVEL=info
ENV GOPATH $BASE_DIR
ENV GOBIN $BASE_DIR/bin
RUN make build
