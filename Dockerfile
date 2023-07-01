FROM node:alpine

RUN apk add libgomp

RUN echo "root:Docker!" | chpasswd
#RUN docker-service enable ssh
RUN apk add openssh
RUN sed -i -E 's/^#?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

WORKDIR /usr/app

COPY . .
RUN npm install
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22
COPY entrypoint.sh /
CMD npm start
