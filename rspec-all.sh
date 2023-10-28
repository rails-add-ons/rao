#!/bin/bash -l
echo $PWD
bundle exec rspec -f d

for d in ./rao-*/ ; do (cd "$d" && echo $PWD && bundle exec rspec -f d); done
