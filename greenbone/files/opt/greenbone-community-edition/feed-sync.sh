#!/bin/bash

set -e

trap 'echo "$(date) feed synchronization failure"; exit 1' ERR

docker compose --file /opt/greenbone-community-edition/docker-compose.yaml --project-name greenbone-community-edition \
    up --pull always --detach notus-data vulnerability-tests scap-data dfn-cert-data cert-bund-data report-formats data-objects

docker compose --file /opt/greenbone-community-edition/docker-compose.yaml --project-name greenbone-community-edition \
    restart

echo "$(date) feed synchronization succeeded"
