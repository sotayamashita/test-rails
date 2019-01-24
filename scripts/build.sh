#!/bin/bash

set -Ceu

readonly USERNAME=sota0805
readonly IMAGE=create-rails-app

docker build -t $USERNAME/$IMAGE:latest .
