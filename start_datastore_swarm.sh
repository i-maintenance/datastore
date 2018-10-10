#!/usr/bin/env bash
cd swarm/DataStack
sudo docker-compose build
sudo docker-compose push || true
sudo docker stack deploy --compose-file swarm-docker-compose.yml elk
