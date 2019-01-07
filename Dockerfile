FROM ubuntu:18.04

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE 1

RUN apt-get update && \
  apt-get -y install wget apt-transport-https gnupg2 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN wget -q -O - https://deb.nodesource.com/setup_8.x | bash && \
  apt-get install -y nodejs && \
  rm -rf /var/lib/apt/lists/*

RUN wget -qO - https://raw.githubusercontent.com/yarnpkg/releases/gh-pages/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
    tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn && \
  rm -rf /var/lib/apt/lists/*

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && apt-get install -y tzdata && \
  ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
  dpkg-reconfigure --frontend noninteractive tzdata && \
  apt-get install -y imagemagick libmagickwand-dev \
    git ruby ruby-dev libpq-dev \
    openssh-client libxslt1-dev libxml2-dev locales libffi-dev && \
    apt-get clean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# SET en_GB locale
RUN apt-get install -y locales && \
  rm -rf /var/lib/apt/lists/* && \
  localedef -i en_GB -c -f UTF-8 -A /usr/share/locale/locale.alias en_GB.UTF-8
ENV LANG en_GB.utf8

RUN wget -qO - https://dl.google.com/linux/linux_signing_key.pub | \
    apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | \
    tee /etc/apt/sources.list.d/google-chrome.list && \
  apt-get update && \
  apt-get install -y google-chrome-stable && apt-get clean && \
  ln -sf /opt/google/chrome/chrome /usr/local/bin/chrome && \
  rm -rf /var/lib/apt/lists/*

RUN wget -N http://chromedriver.storage.googleapis.com/`wget -qO - \
  chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip -P ~/ \
  && unzip ~/chromedriver_linux64.zip -d ~/ \
  && rm ~/chromedriver_linux64.zip \
  && mv -f ~/chromedriver /usr/local/bin/chromedriver \
  && chown root:root /usr/local/bin/chromedriver \
  && chmod 0755 /usr/local/bin/chromedriver

# install bundler
RUN gem install --no-ri --no-rdoc bundler -v1.17.3

CMD ["/bin/bash"]
