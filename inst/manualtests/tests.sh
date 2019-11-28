#!/bin/bash

R -e 'devtools::build("../../", path = ".")'

docker build -t golemmantest .

docker run golemmantest

rm golem_*tar.gz
