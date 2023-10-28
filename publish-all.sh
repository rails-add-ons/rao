#!/bin/bash -l
shopt -s expand_aliases

# publish gems the easy way
function publish_gem {
    TMP=$(gem build $(ls *.gemspec));
    GEM_NAME=$(echo $TMP |& tail -1 | sed -r 's/.*File: //g');
    echo Publishing ${GEM_NAME};
    gem push $GEM_NAME;
}

echo $PWD
publish_gem

for d in ./rao-*/ ; do (cd "$d" && echo $PWD && publish_gem); done
