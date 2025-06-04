#!/bin/bash
set -e

# Verify the container builds
docker build -t dbt-fusion-test -f src/dbt-fusion/.devcontainer/Dockerfile .

# Test Python installation
docker run --rm dbt-fusion-test python --version

# Test uv installation
docker run --rm dbt-fusion-test uv --version

# Test git installation
docker run --rm dbt-fusion-test git --version

# Test xdg-utils installation
docker run --rm dbt-fusion-test xdg-open --version

echo "All tests passed!" 