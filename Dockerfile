FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

CMD ["/bin/bash", "-l", "-c"]
SHELL ["/bin/bash", "-l", "-c"]
ENTRYPOINT ["/bin/bash", "-l", "-c"]

RUN apt-get update -q && apt-get install -y --no-install-recommends \
  apt-utils \
  build-essential \
  ca-certificates \
  curl \
  git \
  gnupg2 \
  imagemagick libmagickwand-dev \
  libpq-dev postgresql-client postgresql-contrib \
  nodejs

RUN ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/Magick-config /usr/bin/Magick-config

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash -s stable
ENV PATH $PATH:$HOME/.rvm/bin
RUN source /etc/profile.d/rvm.sh
RUN rvm rvmrc warning ignore allGemfiles

ENV LANG en_US.UTF-8
RUN rvm install ruby-1.8.7-head
RUN rvm use ruby-1.8.7-head --default
RUN rvm rubygems 1.8.25 --force

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler --no-ri --no-rdoc
RUN bundle install --retry 5

COPY . ./

EXPOSE 3000
