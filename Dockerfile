FROM ubuntu:16.04

RUN apt update && apt -y install wget apt-transport-https && apt clean && \
  rm -rf /var/lib/apt/lists/*

RUN wget -qO - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | \
  tee /etc/apt/sources.list.d/google-chrome.list

RUN wget -qO - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list

RUN wget -q -O - https://deb.nodesource.com/setup_8.x | bash && \
  rm -rf /var/lib/apt/lists/*

RUN wget -qO - https://raw.githubusercontent.com/yarnpkg/releases/gh-pages/debian/pubkey.gpg | apt-key add - && \
  apt update && apt -y upgrade && \
  apt install -y nodejs imagemagick libmagickwand-dev tzdata \
    git ruby ruby-dev libpq-dev \
    openssh-client libxslt1-dev libxml2-dev yarn locales libffi-dev && \
    apt clean && apt autoremove && \
    rm -rf /var/lib/apt/lists/*

# SET en_GB locale
RUN echo 'LC_ALL=en_GB.UTF-8\nLANG=en_GB.UTF-8' >> /etc/default/locale && \
  echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
ENV LANG en_GB.UTF-8
ENV LC_ALL en_GB.UTF-8
ENV LANGUAGE en_GB

RUN apt-get update && apt install -y google-chrome-stable && apt clean && \
  ln -sf /opt/google/chrome/chrome /usr/local/bin/chrome && \
  rm -rf /var/lib/apt/lists/*

RUN wget -N http://chromedriver.storage.googleapis.com/`wget -qO - chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip -P ~/ \
  && unzip ~/chromedriver_linux64.zip -d ~/ \
  && rm ~/chromedriver_linux64.zip \
  && mv -f ~/chromedriver /usr/local/bin/chromedriver \
  && chown root:root /usr/local/bin/chromedriver \
  && chmod 0755 /usr/local/bin/chromedriver

# install bundler
RUN gem install --no-ri --no-rdoc bundler

CMD ["/bin/bash"]
