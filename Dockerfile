FROM ruby:2.3.7

# Maintainer
MAINTAINER "Matt Critchlow <mcritchlow@ucsd.edu">

RUN apt-get update -yqq
RUN apt-get install -yqq --no-install-recommends nodejs

# Dependencies we need for running phantomjs
ENV PHANTOM_JS_DEPENDENCIES\
  libicu-dev libfontconfig1-dev libjpeg-dev libfreetype6

ENV PHANTOM_JS_TAG 2.1.1
RUN apt-get install -fyq ${PHANTOM_JS_DEPENDENCIES}

# Downloading bin, unzipping & removing zip
WORKDIR /tmp
RUN wget -q http://cnpmjs.org/mirrors/phantomjs/phantomjs-${PHANTOM_JS_TAG}-linux-x86_64.tar.bz2 -O phantomjs.tar.bz2 \
  && tar xjf phantomjs.tar.bz2 \
  && rm -rf phantomjs.tar.bz2 \
  && mv phantomjs-* phantomjs \
  && mv /tmp/phantomjs/bin/phantomjs /usr/local/bin/phantomjs

RUN echo "phantomjs binary is located at `which phantomjs`" \
  && echo "just run 'phantomjs' (version `phantomjs -v`)"

# Trick to copy in Gemfile before other files.
# This way bundle install step only runs again if THOSE files change
COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app
RUN bundle install
COPY . /usr/src/app/

CMD ["rails", "s", "-b", "0.0.0.0"]
