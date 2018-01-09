FROM ubuntu:16.04

RUN apt update && apt -y install wget apt-transport-https

RUN wget -qO - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | \
  tee /etc/apt/sources.list.d/google-chrome.list

RUN wget -qO - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list

RUN wget -q -O - https://deb.nodesource.com/setup_8.x | bash

RUN apt update && apt -y upgrade && \
  apt install -y nodejs imagemagick libmagickwand-dev qt5-default tzdata \
    libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools \
    gstreamer1.0-x qt5-qmake xvfb git ruby ruby-dev git libpq-dev \
    openssh-client libxslt1-dev libxml2-dev google-chrome-stable yarn locales

RUN wget "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-$(arch).tar.bz2" && \
  tar -xjf "phantomjs-2.1.1-linux-$(arch).tar.bz2" -C /usr/local && \
  ln -s "/usr/local/phantomjs-2.1.1-linux-$(arch)/bin/phantomjs" /usr/local/bin

RUN ln -sf /opt/google/chrome/chrome /usr/local/bin/chrome

RUN wget -N http://chromedriver.storage.googleapis.com/`wget -qO - chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip -P ~/ \
  && unzip ~/chromedriver_linux64.zip -d ~/ \
  && rm ~/chromedriver_linux64.zip \
  && mv -f ~/chromedriver /usr/local/bin/chromedriver \
  && chown root:root /usr/local/bin/chromedriver \
  && chmod 0755 /usr/local/bin/chromedriver

# SET en_GB locale
RUN echo 'LC_ALL=en_GB.UTF-8\nLANG=en_GB.UTF-8' >> /etc/default/locale
RUN echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen
RUN locale-gen
ENV LANG en_GB.UTF-8
ENV LC_ALL en_GB.UTF-8

# install bundler
RUN gem install --no-ri --no-rdoc bundler

CMD ["/bin/bash"]
