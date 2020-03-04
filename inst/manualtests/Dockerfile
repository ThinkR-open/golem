FROM rocker/tidyverse:3.6.0

RUN mkdir /golem

WORKDIR /golem

COPY golem_*.tar.gz golem.tar.gz

COPY script.R script.R

RUN R -e "source('script.R')"

EXPOSE 5555

CMD R -e "options('shiny.port'=5555,shiny.host='0.0.0.0');gogolele::run_app()"