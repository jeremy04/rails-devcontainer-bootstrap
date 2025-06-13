# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.3
ARG VARIANT=jemalloc-slim
FROM quay.io/evl.ms/fullstaq-ruby:${RUBY_VERSION}-${VARIANT} as base

ARG NODE_VERSION=20.12.2
ARG BUNDLER_VERSION=2.4.21

ARG YARN_VERSION=1.22.19

ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

RUN mkdir -p /workspace/tmp/pids
WORKDIR /workspace

SHELL ["/bin/bash", "-c"]

RUN curl https://get.volta.sh | bash

ENV BASH_ENV ~/.bashrc
ENV VOLTA_HOME /root/.volta
ENV PATH $VOLTA_HOME/bin:/usr/local/bin:$PATH
RUN volta install node@${NODE_VERSION} && volta install yarn@YARN_VERSION

RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list && \
    apt-get update && apt-get install -y gh

FROM base as build_deps

ARG DEV_PACKAGES="git build-essential libpq-dev wget vim curl gzip xz-utils libsqlite3-dev libyaml-dev"
ENV DEV_PACKAGES ${DEV_PACKAGES}

RUN --mount=type=cache,id=dev-apt-cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,id=dev-apt-lib,sharing=locked,target=/var/lib/apt \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y ${DEV_PACKAGES} \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

FROM build_deps as gems

RUN gem install -N bundler -v ${BUNDLER_VERSION}

COPY Gemfile* ./

FROM build_deps as node_modules

COPY package*json ./
COPY yarn.* ./
