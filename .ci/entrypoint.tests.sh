#!/usr/bin/env bash

echo "Running linter"

bundle exec rubocop


echo "Running tests"

bin/rake spec