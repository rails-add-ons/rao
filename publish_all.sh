#!/bin/bash -l
shopt -s expand_aliases
source ~/.bash_aliases

echo $PWD
publish_gem
for i in api-service_controller api-resources_controller component query resource_controller resources_controller service service_chain service_controller shoulda_matchers view_helper; do
  cd "rao-${i}"
  echo $PWD
  publish_gem
  cd ..
done
