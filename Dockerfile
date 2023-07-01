FROM node:alpine

# Install SSH server
RUN apk update && apk add openssh

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
