FROM webdevops/php-apache:8.2-alpine

ARG ARG_WEB_DOCUMENT_ROOT=/app
ARG ARG_ROOT_PASSWORD="Docker!"
ARG ARG_LOG_STDOUT=/var/log/access_log
ARG ARG_LOG_STDERR=/var/log/error_log

COPY ./ /app
WORKDIR /app

# Install Magento dependencies
#RUN composer install --no-interaction --no-plugins --no-scripts

# Set file permissions
# RUN chown -R application:application /app

RUN apk add --no-cache libgomp python3 py3-pip
RUN pip install gunicorn
# Set root password and turn on SSH. Used for SSH in Azure
RUN echo "root:${ARG_ROOT_PASSWORD}" | chpasswd
RUN docker-service enable ssh
RUN sed -i -E 's/^#?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config


# Syslog
RUN echo '@include "/etc/syslog-ng/conf.d/*.conf"' >> /opt/docker/etc/syslog-ng/syslog-ng.conf
#COPY etc/00-syslog.conf /etc/syslog-ng/conf.d/00-syslog.conf

# Ensure env vars show up in SSH session in Azure by adding:
RUN eval $(printenv | grep -E "^[^.]+=.+$" | grep -vE "^(COMPUTERNAME|PWD|HOME|HOSTNAME)" | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/' >> /root/.profile)
RUN echo "eval \$(printenv | grep -E \"^[^.]+=.+\$\" | grep -vE \"^(COMPUTERNAME|PWD|HOME|HOSTNAME)\" | sed -n \"s/^\\([^=]\\+\\)=\\(.*\\)\$/export \\1=\\2/p\" | sed 's/\"/\\\\\\\"/g' | sed '/=/s//=\"/' | sed 's/\$/\"/' >> /root/.profile)" > /opt/docker/provision/entrypoint.d/00-env.sh
RUN wget -O sqlsslca.crt https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem
RUN sed -i 's/providers = provider_sect/providers = provider_sect\n\
ssl_conf = ssl_sect\n\
\n\
[ssl_sect]\n\
system_default = system_default_sect\n\
\n\
[system_default_sect]\n\
Options = UnsafeLegacyRenegotiation/' /etc/ssl/openssl.cnf

EXPOSE 22

