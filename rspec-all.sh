#!/bin/bash -l
echo $PWD
bundle exec rspec spec

for i in api-service_controller api-resources_controller component query resources_controller service service_controller shoulda_matchers view_helper; do
  cd "rao-${i}"
  echo $PWD
  rm Gemfile.lock
  bundle
  bundle exec rspec spec
  cd ..
done