FROM ubuntu:focal


RUN apt update  -y
RUN apt install tzdata curl sudo -y

ENV TZ=Asia/Tokyo

RUN curl -L https://raw.githubusercontent.com/tanacchi/dotfiles/remake-auto-setup-script-with-python/docs/index.html | sh

CMD ["bash"]
