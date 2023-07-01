FROM node:alpine

# Install SSH server and OpenSSH client
RUN apk update && apk add openssh-server openssh-client

# Set up a non-root user
RUN adduser -D appuser
USER appuser

WORKDIR /usr/app

COPY . .
RUN npm install

# Generate SSH host keys
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
    ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa && \
    ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa && \
    ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

# Expose SSH port
EXPOSE 22

# Start SSH server and the application
CMD /usr/sbin/sshd -D && npm start
