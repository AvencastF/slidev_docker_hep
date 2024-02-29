#!/bin/bash

working_dir="slidev"

# echo docker run --name slidev-hep --rm -it -v "$(pwd)":/${working_dir} -w /${working_dir} -p 3000:3030 avencast/slidev:hep

case "$1" in
  clean)
    echo "Performing clean operation..."
    # Place your commands for the "clean" operation here
    rm -rf node_modules package-lock.json package.json slides.md
    ;;
  *)
    echo "Running slidev-hep..."
    docker run --name slidev-hep --rm -it -v "$(pwd)":/${working_dir} -w /${working_dir} -p 3001:3030 avencast/slidev-hep $@
    ;;
esac