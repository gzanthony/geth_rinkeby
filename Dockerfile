FROM node:12.18-buster

MAINTAINER Bokmanli <cngzwing@vip.163.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN apt-get update

RUN apt-get install -y tzdata wget curl golang && dpkg-reconfigure --frontend noninteractive tzdata

ENV NETWORKID 4
ENV RPCAPI web3,eth,net,rpc,personal
ENV CROSDOMAIN 127.0.0.1
ENV VHOSTS *
ENV SYNCMODE fast

RUN apt-get update \
  && apt-get install -y software-properties-common

RUN curl -o /tmp/geth.tar.gz https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.9.15-0f77f34b.tar.gz

RUN cd /tmp \
  && tar xzf geth.tar.gz \
  && mv geth-linux-amd64-1.9.15-0f77f34b/geth /usr/local/bin \
  && rm -f geth.tar.gz

EXPOSE 8584
EXPOSE 30303

WORKDIR /data

ENTRYPOINT geth --ipcpath /root/geth.ipc --rinkeby --syncmode ${SYNCMODE} --datadir=/data --rpc --rpcapi ${RPCAPI} --http.vhosts '*' --networkid ${NETWORKID}
