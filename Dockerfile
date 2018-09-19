FROM ruby:2.3.7-alpine

# Maintainer
MAINTAINER "Matt Critchlow <mcritchlow@ucsd.edu">

RUN apk add --no-cache \
  build-base \
  busybox \
  ca-certificates \
  curl \
  git \
  gnupg1 \
  gpgme \
  less \
  libffi-dev \
  libxml2-dev \
  libxslt-dev \
  linux-headers \
  libsodium-dev \
  nodejs \
  nodejs-npm \
  openssh-client \
  postgresql-dev \
  tzdata \
  rsync \
  wget

# Install phantomjs
RUN wget -qO- "https://github.com/dustinblackman/phantomized/releases/download/2.1.1a/dockerized-phantomjs.tar.gz" | tar xz -C / \
  && npm config set user 0 \
  && npm install -g phantomjs-prebuilt

# Trick to copy in Gemfile before other files.
# This way bundle install step only runs again if THOSE files change
COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app
RUN bundle install
COPY . /usr/src/app/

CMD ["rails", "s", "-b", "0.0.0.0"]
