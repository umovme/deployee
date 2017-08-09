FROM ruby:2.1-alpine

ENV APP_HOME /app

RUN mkdir $APP_HOME && \
  apk add --update \
    build-base \
    libxml2-dev \
    libxslt-dev

WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
RUN bundle config build.nokogiri --use-system-libraries && bundle install
COPY . $APP_HOME/


ENTRYPOINT ["ruby", "bin/deployee"]
CMD [""]
