FROM ubuntu:16.04
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y ruby-build subversion autoconf bison software-properties-common git
RUN apt-get install -y imagemagick libmagickcore-dev libmagickwand-dev libpq-dev
RUN ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/Magick-config /usr/bin/Magick-config
ENV PATH /root/.rbenv/shims:$PATH
RUN rbenv install 1.8.7-p375
RUN rbenv local 1.8.7-p375
RUN gem update --system 1.8.25
RUN gem install -v 1.10.6 bundler --no-rdoc --no-ri
RUN rbenv rehash
# https://gist.github.com/formigarafa/474af0ce654389c2aabe34d9f0a0b881
