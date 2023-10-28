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
for i in active_collection api-resources_controller api-service_controller component query resources_controller resource_controller service service_chain service_controller shoulda_matchers view_helper; do
  cd "rao-${i}"
  echo $PWD
  publish_gem
  cd ..
done
