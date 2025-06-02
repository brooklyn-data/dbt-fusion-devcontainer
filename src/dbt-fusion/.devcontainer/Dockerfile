# Use the official Python image as the base image
FROM python:3.12-slim

# Install system dependencies (i.e. git, curl)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv using pip
RUN pip install uv

# Install tools using uv and ensure they're in PATH
RUN uv pip install --system ruff

# Set the working directory
WORKDIR /workspace

# Set the default command
CMD ["/bin/bash"]