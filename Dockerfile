FROM ubuntu:16.04
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install software-properties-common imagemagick libmagickcore-dev libmagickwand-dev libpq-dev --yes
RUN ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/Magick-config /usr/bin/Magick-config
RUN apt-add-repository -y ppa:rael-gc/rvm
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8094BB14F4E3FBBE
RUN apt-get update
RUN apt-get install rvm --yes
RUN /bin/bash -l -c "source /usr/share/rvm/scripts/rvm"
RUN /bin/bash -l -c "rvm use 1.8.7 --default --install"
RUN /bin/bash -l -c "rvm rubygems 1.8.25 --force"
RUN /bin/bash -l -c "gem install -v 1.10.6 bundler --no-rdoc --no-ri"
ENTRYPOINT ["/bin/bash", "-l", "-c"]
# https://gist.github.com/formigarafa/474af0ce654389c2aabe34d9f0a0b881
