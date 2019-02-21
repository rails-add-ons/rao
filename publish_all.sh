#!/bin/bash -l
shopt -s expand_aliases
source ~/.bash_aliases

echo $PWD
for i in api-service_controller api-resources_controller component query resources_controller service service_controller view_helper; do
  cd "rao-${i}"
  echo $PWD
  publish_gem
  cd ..
done
