# syntax=docker/dockerfile:1
ARG RUBY_VERSION=4.0
FROM ruby:${RUBY_VERSION}-alpine AS base

ARG BUNDLER_VERSION=4.0.4

ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

RUN mkdir -p /workspace/tmp/pids
WORKDIR /workspace

# Install all packages in a single layer
# Dev: build-base(gcc/make), postgresql-dev, sqlite-dev, yaml-dev
# Tools: git, vim, curl, bash, github-cli, nodejs, npm, yarn
RUN apk add --no-cache \
    bash build-base curl gzip git unzip vim wget xz \
    libpq-dev sqlite-dev yaml-dev \
    nodejs npm yarn \
    github-cli

SHELL ["/bin/bash", "-c"]

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Install Bundler
RUN gem install -N bundler -v ${BUNDLER_VERSION}

# Bash env for interactive use
ENV BASH_ENV=~/.bashrc
ENV PATH="/root/.local/bin:$PATH"
