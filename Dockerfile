FROM ruby:2.5

# Configure locals
ENV LANG C.UTF-8
# Set app name
ENV APP_ROOT /app

# For essential
RUN curl -sSL https://deb.nodesource.com/setup_10.x | bash && \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gcc \
    g++ \
    make \
    nodejs \
    vim \
    wget \
 && rm -rf /var/lib/apt/lists/*

# For tini
ENV TINI_VERSION v0.18.0
ENV TINI_GPG_KEY 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7

RUN cd /tmp && \
  curl -sSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc -o tini.asc && \
  curl -sSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -o /usr/local/bin/tini && \
  gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys ${TINI_GPG_KEY} && \
  gpg --verify tini.asc /usr/local/bin/tini && \
  chmod +x /usr/local/bin/tini && \
  rm tini.asc

RUN mkdir -p ${APP_ROOT}


COPY rootfs /

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
WORKDIR ${APP_ROOT}

RUN gem install rails --version=5.2.1

EXPOSE 3000
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
