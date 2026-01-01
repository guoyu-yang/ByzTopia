#!/bin/bash

go env -w GO111MODULE="off"
go env -w GOPATH="/opt/bft/waterbear"
go env -w GOBIN="/opt/bft/waterbear/bin"
go env -w GOPROXY="https://goproxy.cn,direct"

