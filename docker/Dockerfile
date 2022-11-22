FROM ubuntu:jammy-20221101

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y \
    ca-certificates software-properties-common gnupg lsb-release \
    qemu-user-static qemu-utils parted \
    sudo psmisc libarchive-tools fdisk gdisk kpartx dosfstools\
    git unzip xz-utils curl \
    golang

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && apt-get install packer

RUN mkdir /home/builder

RUN git clone https://github.com/mkaczanowski/packer-builder-arm/ && \
    cd packer-builder-arm && \
    go mod download && \
    go build && \
    mv packer-builder-arm /home/builder

WORKDIR /home/builder
COPY entrypoint.sh /home/builder
RUN chmod +x /home/builder/entrypoint.sh

ENTRYPOINT ["/home/builder/entrypoint.sh"]
