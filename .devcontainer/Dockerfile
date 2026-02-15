# syntax=docker/dockerfile:1

# Stage 1: Get Node.js binaries
FROM node:20-alpine AS node

# Stage 2: Base Ruby + Node runtime
FROM ruby:4.0-alpine AS base

ARG YARN_VERSION=1.22.22

# Node requires libstdc++ which isn't in the base ruby alpine image
RUN apk add --no-cache libstdc++

# Copy Node.js from node stage
COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

# Install Yarn
RUN npm install -g yarn@${YARN_VERSION}

ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

RUN mkdir -p /workspace/tmp/pids
WORKDIR /workspace

# Stage 3: Dev dependencies
FROM base AS build_deps

# Install system dependencies for Rails development
RUN apk add --no-cache \
    bash \
    build-base \
    curl \
    github-cli \
    git \
    gzip \
    postgresql16-dev \
    sqlite-dev \
    sudo \
    tzdata \
    unzip \
    xz \
    yaml-dev

SHELL ["/bin/bash", "-c"]

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Create non-root dev user with passwordless sudo
RUN addgroup -g 1000 -S devuser && \
    adduser -u 1000 -S devuser -G devuser -s /bin/bash -h /home/devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/devuser

# Ensure gem/bundle paths are writable
RUN chown -R devuser:devuser /usr/local/bundle

RUN chown -R devuser:devuser /workspace

USER devuser

# Stage 4: Gem dependencies
FROM build_deps AS gems

COPY Gemfile* ./

# Stage 5: Node dependencies
FROM build_deps AS node_modules

COPY package*json ./
COPY yarn.* ./
