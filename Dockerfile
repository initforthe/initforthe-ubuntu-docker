FROM ubuntu:16.04

RUN apt-get update -y && \
  apt-get install -y nodejs imagemagick \
    libmagickwand-dev qt5-default libqt5webkit5-dev \
    gstreamer1.0-plugins-base gstreamer1.0-tools \
    gstreamer1.0-x qt5-qmake xvfb git phantomjs \
    ruby ruby-dev git libpq-dev openssh-client \
    libxslt1-dev libxml2-dev

RUN gem install --no-ri --no-rdoc bundler

ENV QT_QPA_PLATFORM=offscreen

CMD ["/bin/bash"]
