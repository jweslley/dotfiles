#!/bin/sh

# go development

export GOROOT=$HOME/tools/go
export GOPATH=$HOME/code/go
export PATH=$HOME/tools/go_appengine:$GOPATH/bin:$GOROOT/bin:$PATH
export CDPATH=$CDPATH:$HOME/code/go/src:$HOME/code/go/src/github.com/jweslley/
