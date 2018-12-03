FROM python:2.7.15-jessie
MAINTAINER Efim Polevoi <fimkap@gmail.com>

# Update and install
RUN apt-get update && apt-get install -y \
      curl \
      wget \
      git \
      software-properties-common \
      python-dev \
      python-pip \
      python3-dev \
      python3-pip \
      ctags \
      silversearcher-ag \
      # For python crypto libraries
      libssl-dev \
      libffi-dev \
      locales \
      # For Neovim
      ninja-build \
      gettext \
      libtool \
      libtool-bin \
      autoconf \
      automake \
      cmake \
      g++ \
      pkg-config \
      unzip

# Install python linting and neovim plugin
RUN pip install neovim
RUN pip3 install neovim

# Install Tornado
RUN pip install tornado

# Install jedi coompletion engine
RUN pip install jedi

# Install Neovim
RUN  git clone -b v0.3.1 https://github.com/neovim/neovim.git && \
  cd neovim && \
  make CMAKE_BUILD_TYPE=Release && \
  make install && \
cd ../ && rm -rf neovim

# Install pyenv
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
RUN echo 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

RUN /root/.pyenv/bin/pyenv install 2.7.15

# Install pyenv virtualenv plugin
RUN git clone https://github.com/pyenv/pyenv-virtualenv.git $(/root/.pyenv/bin/pyenv root)/plugins/pyenv-virtualenv
RUN /root/.pyenv/bin/pyenv virtualenv 2.7.15 cma-convert
# After this need to go to the source dir and run: pyenv local cma-convert

# Install Postgres
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' >> /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-9.6 postgresql-contrib-9.6

RUN apt-get install -y ruby ruby-dev
RUN gem install sass -v 3.4.13 --conservative
RUN gem install compass

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g grunt-cli
# This is to run on the source code
#RUN npm install
#RUN npm install bower
#node_modules/bower/bin/bower --allow-root cache clean
#node_modules/bower/bin/bower --allow-root install
#grunt build:dist

COPY init.vim /root/.config/nvim/init.vim

# Install neovim plugins
RUN nvim -i NONE -c PlugInstall -c quitall > /dev/null 2>&1
