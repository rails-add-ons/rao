#!/bin/bash -l
gem update --system
bundle

for d in ./rao-*/ ; do (cd "$d" && echo $PWD && bundle); done