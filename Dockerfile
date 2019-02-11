FROM ruby:2.5

ENV LANG C.UTF-8
ENV APP_ROOT /app

RUN curl -sSL https://deb.nodesource.com/setup_10.x | bash && \
    apt-get update -qq && apt-get install -y nodejs postgresql-client

RUN mkdir -p ${APP_ROOT}
WORKDIR ${APP_ROOT}

COPY Gemfile* ${APP_ROOT}/
RUN bundle install -j "$(getconf _NPROCESSORS_ONLN)" --retry 5 --no-document
COPY . ${APP_ROOT}

# Add a script to be executed every time the container starts.
COPY rootfs /
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
