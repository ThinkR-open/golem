#!/bin/bash

R -e 'devtools::build("../../", path = ".")'

docker build -t golemmantest . --no-cache

docker run -p 5555:5555 -d golemmantest && \
  sleep 2 && open http://localhost:5555

rm golem_*tar.gz
