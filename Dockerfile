FROM nimlang/choosenim
RUN choosenim update stable

RUN nimble update
RUN nimble install docopt
RUN nimble install httpbeast@0.4.2
RUN nimble install jester

RUN apt-get update
RUN apt-get install -y gnuplot-nox

RUN nimble install gnuplotlib

ADD . /expenses
WORKDIR /expenses
RUN nimble install
RUN cp -r src/html bin/public
RUN ln -s ../data/exp.json bin/exp.json
