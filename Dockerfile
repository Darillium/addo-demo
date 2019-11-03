FROM ubuntu:18.04

RUN apt update && apt install -y curl jq unzip

ADD run.sh /usr/share/addo-demo/run.sh

CMD /bin/bash /usr/share/addo-demo/run.sh