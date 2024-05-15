# build stage
FROM nimlang/choosenim as build
RUN choosenim update 2.0.0

RUN nimble update
RUN nimble install docopt
RUN nimble install httpbeast@0.4.2
RUN nimble install jester

RUN nimble install ggplotnim

ADD . /expenses
WORKDIR /expenses
RUN nimble install

# prod stage
FROM debian:stable-slim as prod

RUN apt-get update
RUN apt-get install -y liblapack-dev libcairo2

WORKDIR /expenses
COPY --from=build /expenses/bin/expenses .
ADD src/html public
RUN ln -s data/exp.json
