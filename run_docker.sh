#!/bin/bash

working_dir="slidev"

# echo docker run --name slidev-hep --rm -it -v "$(pwd)":/${working_dir} -w /${working_dir} -p 3000:3030 avencast/slidev:hep

docker run --name slidev-hep --rm -it -v "$(pwd)":/${working_dir} -w /${working_dir} -p 3001:3030 avencast/slidev:hep
