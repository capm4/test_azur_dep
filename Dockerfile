FROM node:alpine

# Install SSH server and OpenSSH client
RUN apk update && apk add openssh-server openssh-client

# Generate SSH keys
RUN ssh-keygen -A

# Set up a non-root user
RUN adduser -D appuser
USER appuser

WORKDIR /usr/app

COPY . .
RUN npm install

# Expose SSH port
EXPOSE 22

# Start SSH server and the application
CMD /usr/sbin/sshd -D && npm start
