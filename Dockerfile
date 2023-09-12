FROM debian:7.7

MAINTAINER Rob McQueen

# Install Python
RUN apt-get update && apt-get install -y \
  python3-dev \
  python3-virtualenv \
  sudo

# Install Ansible
RUN mkdir /opt/ansible && virtualenv /opt/ansible/venv && \
  /opt/ansible/venv/bin/pip install ansible

# if can't install nvidia.nvue
pip install -Iv 'resolvelib<0.6.0' #NOT ROOT

ADD . /build
COPY .ansible-test /build
WORKDIR /build

CMD /opt/ansible/venv/bin/ansible-playbook -i inventory.yml \
    -c local -s -e testing=true -e role=$DOCKER_TEST_ROLE \
    role playbook.yml; /bin/bash
