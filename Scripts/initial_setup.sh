#!/bin/bash

if [[ -z "$CI" ]]; then
    bundle install
else
    bundle config set --local path "$HOME/vendor/bundle"
    bundle check || bundle install
fi
