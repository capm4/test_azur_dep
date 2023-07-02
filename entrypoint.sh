#!/bin/sh
set -e

# Create the /etc/supervisor directory
mkdir -p /etc/supervisor

# Copy the supervisord.conf file to the expected location
cp supervisord.conf /etc/supervisor/supervisord.conf

# Start Supervisor
supervisord -c /etc/supervisor/supervisord.conf

# Start SSH service
service ssh start

# Keep the script running to keep the container alive
tail -f /dev/null
