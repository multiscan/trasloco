FROM ruby:latest

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential nodejs yarn # postgresql-client
RUN apt-get update -qq && apt-get install -y texlive-latex-base texlive-latex-recommended texlive-pictures texlive-latex-extra

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN gem install bundler:2.1.2

ADD . $APP_HOME/
RUN bundle install
RUN yarn install --check-files

# Add a script to be executed every time the container starts.
COPY docker/app_entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails","server","-b","0.0.0.0"]