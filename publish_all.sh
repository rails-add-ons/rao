#!/bin/bash -l
shopt -s expand_aliases
source ~/.bash_aliases

echo $PWD
publish_gem
for i in api-resources_controller api-service_controller component query resources_controller resource_controller service service_chain service_controller shoulda_matchers view_helper; do
  cd "rao-${i}"
  echo $PWD
  publish_gem
  cd ..
done
