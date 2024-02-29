#!/bin/bash

docker build --build-arg NPM_MIRROR="https://registry.npmmirror.com" \
    --build-arg DEB_MIRROR="mirrors.tuna.tsinghua.edu.cn" \
    -t avencast/slidev:hep .