#!/bin/bash
# Create a systemd service that autostarts & manages a docker-compose instance in the current directory
# by Uli Köhler - https://techoverflow.net
# Licensed as CC0 1.0 Universal
SERVICENAME=portfolio
echo "Creating systemd service... /etc/systemd/system/${SERVICENAME}.service"
# Create systemd service file
sudo cat >/etc/systemd/system/$SERVICENAME.service <<EOF
[Unit]
Description=$SERVICENAME
Requires=docker.service
After=docker.service
[Service]
Restart=always
User=ec2-user
Group=ec2-user
WorkingDirectory=/home/ec2-user/portfolio
# Shutdown container (if running) when unit is started
ExecStartPre=/bin/sh secret.sh
# Start container when unit is started
ExecStart=/usr/bin/docker-compose -f docker-compose.yml up
# Stop container when unit is stopped
ExecStop=/usr/bin/docker-compose -f docker-compose.yml down
[Install]
WantedBy=multi-user.target
EOF
