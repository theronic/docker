#!/bin/bash

set -ex

tag=$(date +%F)

build() {
    cd $(dirname $0)
    docker build -t japaric/copper:$tag -f Dockerfile ..
}

test() {
    docker run japaric/copper:$tag sh -c "
        rustup default nightly
        cargo install --git https://github.com/japaric/xargo
        git clone --depth 1 https://github.com/japaric/cu
        cd cu
        xargo build --verbose
    "
}

deploy() {
    docker push japaric/photon
}

main() {
    build
    test

    if [ ! "$1" = "--test-only" ]; then
        deploy
    fi
}

main "$@"