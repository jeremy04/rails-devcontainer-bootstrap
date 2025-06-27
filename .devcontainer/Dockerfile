# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.3
ARG VARIANT=jemalloc-slim
FROM quay.io/evl.ms/fullstaq-ruby:${RUBY_VERSION}-${VARIANT} as base

ARG NODE_VERSION=20.12.2
ARG BUNDLER_VERSION=2.4.21
ARG LOCALSTACK_CLI_VERSION=4.5.0
ARG AWSCLI_VERSION=2.15.39
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
RUN volta install node@${NODE_VERSION} && volta install yarn@${YARN_VERSION}

FROM base as build_deps

ARG DEV_PACKAGES="git build-essential libpq-dev wget vim gzip xz-utils libsqlite3-dev libyaml-dev curl unzip"
ENV DEV_PACKAGES ${DEV_PACKAGES}

# Install core dev packages
RUN --mount=type=cache,id=dev-apt-cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,id=dev-apt-lib,sharing=locked,target=/var/lib/apt \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y ${DEV_PACKAGES}

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
      https://cli.github.com/packages stable main" \
      > /etc/apt/sources.list.d/github-cli.list && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y gh

# Install LocalStack CLI binary
RUN curl -LO https://github.com/localstack/localstack-cli/releases/download/v${LOCALSTACK_CLI_VERSION}/localstack-cli-${LOCALSTACK_CLI_VERSION}-linux-amd64-onefile.tar.gz && \
    tar xvzf localstack-cli-${LOCALSTACK_CLI_VERSION}-linux-amd64-onefile.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/localstack && \
    rm localstack-cli-${LOCALSTACK_CLI_VERSION}-linux-amd64-onefile.tar.gz

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Clean up APT caches
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

FROM build_deps as gems

RUN gem install -N bundler -v ${BUNDLER_VERSION}

COPY Gemfile* ./

FROM build_deps as node_modules

COPY package*json ./
COPY yarn.* ./
