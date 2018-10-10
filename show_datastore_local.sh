#!/usr/bin/env bash
echo "Printing 'docker service ls | grep elk':"
cd swarm/DataStack
sudo docker-compose logs -f

