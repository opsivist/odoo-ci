FROM ubuntu:22.04

# some environment variables
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

RUN set -x \
  && apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y software-properties-common \
  && add-apt-repository -y ppa:deadsnakes/ppa \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    git \
    mercurial \
    wget \
    openssh-client \
    rsync \
    make \
    python3 \
    python3-dev \
    python3-venv \
    python3.8 \
    python3.8-dev \
    python3.8-venv \
    python3.9 \
    python3.9-dev \
    python3.9-venv \
    python3.10 \
    python3.10-dev \
    python3.10-venv \
    python3.11 \
    python3.11-dev \
    python3.11-venv \
    postgresql-client \
    # expect provides the unbuffer utility
    tcl \
    expect \
    # odoo dependencies
    graphviz \
    node-clean-css \
    node-less \
    poppler-utils \
    antiword \
    # libreoffice for py3o
    libreoffice-writer \
    libreoffice-calc \
    # gettext to manipulate .pot, .po files
    gettext \
  # wkhtmltopdf
  && wget -q -O /tmp/wkhtmltox.deb https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb \
  && echo "ee88d74834bdec650f7432c7d3ef1c981e42ae7a762a75a01f7f5da59abc18d5 /tmp/wkhtmltox.deb" | sha256sum -c - \
  && apt-get -y install /tmp/wkhtmltox.deb \
  && rm -f /tmp/wkhtmltox.deb \
  # cleanup
  && rm -fr /var/lib/apt/lists/*

# Install pipx, which we use to install other python tools.
ENV PIPX_BIN_DIR=/usr/local/bin
ENV PIPX_HOME=/opt/pipx
RUN python3 -m venv /opt/pipx/venv \
    && /opt/pipx/venv/bin/pip install --no-cache-dir pipx \
    && ln -s /opt/pipx/venv/bin/pipx /usr/local/bin/

# We don't use the ubuntu virtualenv package because it unbundles pip dependencies
# in virtualenvs it create.
RUN pipx install --pip-args="--no-cache-dir" virtualenv

# git-autoshare
RUN pipx install --pip-args="--no-cache-dir" "git-autoshare>=1.0.0b4"
COPY git-wrapper /usr/local/bin/git

# manifestoo
RUN pipx install --pip-args="--no-cache-dir" "manifestoo>=0.4.0"

# acsoo
RUN pipx install --pip-args="--no-cache-dir" "acsoo"

# pip-deepfreeze
RUN pipx install --pip-args="--no-cache-dir" "pip-deepfreeze"

# avoid potential race conditions in creating these directories
RUN mkdir -p \
  /root/.local/share/Odoo/addons \
  /root/.local/share/Odoo/filestore \
  /root/.local/share/Odoo/sessions

# make sure directories in /home/gitlab-runner have adequate owner and permissions
RUN mkdir -p \
  /root/.cache \
  /root/.config \
  /root/.ssh \
  && chmod 700 /root/.ssh

COPY git-autoshare.yml /root/.config/git-autoshare/repos.yml
