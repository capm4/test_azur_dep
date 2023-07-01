FROM node:alpine

# Install SSH server and OpenSSH client
RUN apk update && apk add openssh-server openssh-client

# Set up a non-root user
RUN adduser -D appuser
USER appuser

WORKDIR /usr/app

COPY . .
RUN npm install

# Expose SSH port
EXPOSE 22

# Start SSH server and generate SSH host keys on container startup
CMD /usr/sbin/sshd && ssh-keygen -A && npm start
