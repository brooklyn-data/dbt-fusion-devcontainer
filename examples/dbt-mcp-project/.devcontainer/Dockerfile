# Use the official Python image as the base image
FROM python:3.12-slim

# Install system dependencies (i.e. git, curl, xdg-utils)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm (needed for Claude)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs    

# Install uv using pip
RUN pip install uv

# Install tools using uv and ensure they're in PATH
RUN uv pip install --system ruff pre-commit sqlfmt

# Install Anthropic CLI globally
RUN npm install -g @anthropic-ai/claude-code

# Set the working directory
WORKDIR /workspace

# Set the default command
CMD ["/bin/bash"]