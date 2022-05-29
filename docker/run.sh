#!/bin/bash
set -euxo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker-compose --project-name "${DIR}" build
docker-compose --project-name "${DIR}" run --rm build-container
