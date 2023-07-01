FROM node:alpine

RUN apt install -y openssh-server && echo "root:Docker!" | chpasswd

RUN mkdir -p /var/log/supervisor 

COPY sshd_config /etc/ssh/

EXPOSE 2222

WORKDIR /usr/app

COPY . .
RUN npm install

EXPOSE 2222

CMD service start ssh && npm start
