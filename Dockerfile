FROM node:alpine

RUN apt-get update \
    && apt-get install -y supervisor \
    && apt-get install -y openssh-server && echo "root:Docker!" | chpasswd

RUN mkdir -p /var/log/supervisor 
COPY sshd_config /etc/ssh/

EXPOSE 2222

WORKDIR /usr/app

COPY . .
RUN npm install

EXPOSE 2222

CMD npm start
