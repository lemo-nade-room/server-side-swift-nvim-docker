FROM ubuntu:noble

SHELL ["/bin/bash", "-c"]

# ================================
# apt
# ================================
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
    apt update && \
    apt install -y \
    curl \
    sudo \
    build-essential \
    make \
    locales \
    unzip \
    fontconfig \
    git \
    libncurses6 \
    libncurses-dev \
    binutils \
    unzip \
    gnupg2 \
    libc6-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libgcc-13-dev \
    libpython3-dev \
    libsqlite3-0 \
    libstdc++-13-dev \
    libxml2-dev \
    libncurses-dev \
    libz3-dev \
    pkg-config \
    tzdata \
    zlib1g-dev \
    openssl \
    libssl-dev \
    && rm -r /var/lib/apt/lists/*

# ================================
# Locale
# ================================
RUN locale-gen ja_JP.UTF-8 && \
    update-locale LANG=ja_JP.UTF-8

ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

# ================================
# Font
# ================================
ARG NERD_FONT=JetBrainsMono
ARG NERD_FONT_VER=v3.1.1
RUN curl -L -o /tmp/${NERD_FONT}.zip \
        https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VER}/${NERD_FONT}.zip && \
    mkdir -p /usr/local/share/fonts/${NERD_FONT} && \
    unzip -q /tmp/${NERD_FONT}.zip -d /usr/local/share/fonts/${NERD_FONT} && \
    rm /tmp/${NERD_FONT}.zip && \
    fc-cache -f -v

# ================================
# Swift Lover
# ================================
RUN echo 'swiftlover ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/swiftlover
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /swiftlover swiftlover
USER swiftlover:swiftlover
WORKDIR /swiftlover

# ================================
# Setup Script
# ================================
COPY scripts /scripts
RUN echo 'bash /scripts/setup.sh' >> /swiftlover/.bashrc

# ================================
# Homebrew
# ================================
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN echo >> /swiftlover/.bashrc
RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /swiftlover/.bashrc
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
    brew install \
    neovim \
    vapor \
    swift-format && \
    brew unlink swift

# ================================
# Setup Neovim
# ================================
COPY nvim /swiftlover/.config/nvim

# ================================
# GitHub gh
# ================================
RUN (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

# ================================
# Setup Swift
# ================================
WORKDIR /swiftly
RUN NONINTERACTIVE=1 curl -O "https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz" && \
    tar zxf "swiftly-$(uname -m).tar.gz" && \
    ./swiftly init --quiet-shell-followup && \
    . ${SWIFTLY_HOME_DIR:-~/.local/share/swiftly}/env.sh && \
    hash -r && \
    echo "source ${SWIFTLY_HOME_DIR:-~/.local/share/swiftly}/env.sh" >> /swiftlover/.bashrc

WORKDIR /swiftlover/workspace

# ================================
# Permission
# ================================
RUN sudo chown -R swiftlover:swiftlover /swiftly
RUN sudo chown -R swiftlover:swiftlover /swiftlover/.config/nvim
RUN sudo chown -R swiftlover:swiftlover /swiftlover/workspace
