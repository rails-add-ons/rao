#!/bin/bash -l
echo $PWD
bundle exec rspec -f d

for i in api-resources_controller api-service_controller component query resources_controller resource_controller service service_chain service_controller shoulda_matchers view_helper; do
  cd "rao-${i}"
  echo $PWD
  bundle exec rspec -f d
  cd ..
done