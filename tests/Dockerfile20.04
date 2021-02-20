FROM ubuntu:focal


RUN apt update  -y
RUN apt install tzdata curl sudo -y

ENV TZ=Asia/Tokyo

RUN curl -L tanacchi.github.io/dotfiles | sh

CMD ["bash"]
