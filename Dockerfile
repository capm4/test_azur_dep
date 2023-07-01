FROM node:alpine

RUN echo "root:Docker!" | chpasswd
RUN docker-service enable ssh
RUN sed -i -E 's/^#?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

WORKDIR /usr/app

COPY . .
RUN npm install

CMD npm start
