FROM jacobat/ruby:2.1.5-3
RUN apt-get update && apt-get install -y build-essential nodejs
RUN gem install nokogiri -v 1.6.5
ADD Gemfile /app/
ADD Gemfile.lock /app/
WORKDIR /app
RUN bundle install

ADD . /app
EXPOSE 3000
ENV SECRET_KEY_BASE abcdefabcdef
CMD bundle exec rails s --bind 0.0.0.0 -e production
