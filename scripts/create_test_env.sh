#!/bin/sh
pdk bundle exec rake 'litmus:provision_list[travis_el7]'
pdk bundle exec rake 'litmus:install_agent[puppet6]'
pdk bundle exec rake litmus:install_module
