# Opsivist docker image for running Odoo CI workloads

This Odoo image has the following characteristics:

- Based on Ubuntu 20.04.
- Minimal dependencies to run Odoo CI jobs

  - git (with user.name=GitLab and user.email=gitlab@opsivist.io)
  - git-autoshare
  - mercurial
  - openssh-client
  - rsync
  - make
  - python2.7/3.5/3.6/3.7/3.8/3.9/3.10
  - virtualenv
  - postgresql client
  - lessc
  - wkhtmltopdf
  - unbuffer
  - gettext: useful to manipulate .po files
  - graphviz, poppler-utils, antiword: used by some Odoo versions
  - libreoffice-writer, libreoffice-calc: for py3o

- [pipx](https://pypi.org/project:pipx>)
- [manifestoo](https://pypi.org/project/manifestoo>)
- ssh client configuration

  - disable strict host key checking

- Odoo 8, 9, 10, 11, 12, 13, 14, 15 are supported.
- Odoo is not preinstalled.
- Runs as non-privileged user named _gitlab-runner_

## Recommended mounts

It is recommended to mount the following volumes, for better build performance:

- ```/home/gitlab-runner/.cache/pip```
- ```/home/gitlab-runner/.cache/git-autoshare```
- ```/home/gitlab-runner/.cache/acsoo-wheel```, if you use the deprecated ```acsoo wheel``` command
