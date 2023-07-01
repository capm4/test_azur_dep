FROM node:alpine

RUN echo "root:Docker!" | chpasswd
RUN docker-service enable ssh
RUN sed -i -E 's/^#?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 2222

WORKDIR /usr/app

COPY . .
RUN npm install

EXPOSE 2222

CMD service start ssh && npm start
