FROM ruby:2.3.7-alpine

# Maintainer
MAINTAINER "Matt Critchlow <mcritchlow@ucsd.edu">

RUN apk add --no-cache \
  build-base \
  busybox \
  ca-certificates \
  chromium \
  chromium-chromedriver \
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
  openssh-client \
  postgresql-dev \
  tzdata \
  rsync

# Headless chromium for tests
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/
ENV CHROME_NO_SANDBOX=true

ENV RAILS_ENV=test

# Trick to copy in Gemfile before other files.
# This way bundle install step only runs again if THOSE files change
COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app
RUN bundle install
COPY . /usr/src/app/

CMD ["rails", "s", "-b", "0.0.0.0"]
