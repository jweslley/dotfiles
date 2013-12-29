#!/bin/sh

# go development

export GOROOT=$HOME/tools/go
export GOPATH=$HOME/code/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export CDPATH=$CDPATH:$HOME/code/go/src

gotools() {
  go get github.com/nsf/gocode
  go get github.com/jstemmer/gotags
  go get github.com/mitchellh/gox
  go get code.google.com/p/rog-go/exp/cmd/godef
}
