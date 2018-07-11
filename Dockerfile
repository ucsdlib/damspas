FROM circleci/ruby:2.3.7-node-browsers

# Maintainer
MAINTAINER "Matt Critchlow <mcritchlow@ucsd.edu">

RUN echo "phantomjs binary is located at `which phantomjs`" \
  && echo "just run 'phantomjs' (version `phantomjs -v`)"

# Trick to copy in Gemfile before other files.
# This way bundle install step only runs again if THOSE files change
COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app
RUN bundle install
COPY . /usr/src/app/

CMD ["rails", "s", "-b", "0.0.0.0"]
