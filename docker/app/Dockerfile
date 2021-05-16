FROM ruby:3.0.1-buster

LABEL maintainer="Rubyroid Labs <hello@rubyroidlabs.com>"

ARG RAILS_ENV=production
ARG NODE_ENV=production

ENV RAILS_ROOT /app
ENV BUNDLER_VERSION="2.2.15"
ENV RAILS_ENV=$RAILS_ENV
ENV NODE_ENV=$NODE_ENV
ENV SECRET_KEY_BASE=secret

RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

COPY package.json package.json
COPY yarn.lock yarn.lock

RUN apt-get update && apt-get -y install build-essential apt-transport-https lsb-release ca-certificates curl cmake

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y nodejs yarn
RUN rm -rf /var/lib/apt/lists/*

COPY config/database.yml.sample config/database.yml
COPY config/storage.yml.sample config/storage.yml

COPY . .

RUN gem install bundler --version "${BUNDLER_VERSION}"
RUN bundle install
RUN yarn install --production=false

EXPOSE 3000

COPY docker/app/script/entrypoint.sh /entrypoint.sh

RUN \
 chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
