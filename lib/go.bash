#!/bin/sh

# go development

export GOPATH=$HOME/code/go
export PATH=$HOME/tools/go_appengine:$GOPATH/bin:$PATH
export CDPATH=$CDPATH:$HOME/code/go/src:$HOME/code/go/src/github.com/jweslley/

alias golist="go list -f '{{ join .Imports \"\n\" }}'"
