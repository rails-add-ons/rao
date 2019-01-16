#!/bin/bash -l
cd ./rao-api-service_controller
echo $PWD
bundle exec rspec spec
cd ..

cd ./rao-component
echo $PWD
bundle exec rspec spec
cd ..

cd ./rao-query
echo $PWD
bundle exec rspec spec
cd ..

cd ./rao-resources_controller
echo $PWD
bundle exec rspec spec
cd ..

cd ./rao-service
echo $PWD
bundle exec rspec spec
cd ..

cd ./rao-service_controller
echo $PWD
bundle exec rspec spec
cd ..

cd ./rao-view_helper
echo $PWD
bundle exec rspec spec
cd ..
