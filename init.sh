#!/bin/bash

# Update package lists and install required packages for Docker
sudo apt-get update
sudo apt-get install ca-certificates curl

# Create directory for Docker's GPG key and add the key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's official repository to Apt sources
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists and install Docker components
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create a Docker network for containers
docker network create pg-network

# Run Redis Stack container on the created network
docker run -p 6379:6379 -p 8001:8001 -v /redis-data/:/data --network=tl-network --name redis-server redis/redis-stack

# Stop and remove existing Postgres container if it exists, then run a new one
docker container stop postgres
docker container rm postgres
docker run -d -p 6432:5432 -v /custom/mount:/var/lib/postgresql/data -e POSTGRES_PASSWORD=buuandbee --network=pg-network --name postgres postgres:16.3

# Wait for Postgres to initialize
sudo sleep 10

# Stop and remove existing Hasura container if it exists, then run a new one
docker container stop hasura
sudo docker container rm hasura
sudo docker run -d --network=pg-network --restart always -p 8080:8080 -e HASURA_GRAPHQL_ENABLE_CONSOLE=true -e HASURA_GRAPHQL_METADATA_DATABASE_URL=postgresql://postgres:buuandbee@postgres:5432/postgres --name hasura hasura/graphql-engine:v2.15.2

# Install git
apt-get install git

# Download and install nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Source nvm script to use nvm in current shell
\. "$HOME/.nvm/nvm.sh"

# Install Node.js version 22 using nvm
nvm install 22

# Verify Node.js and npm versions
node -v # Should print "v22.17.1".
nvm current # Should print "v22.17.1".
npm -v # Should print "10.9.2".

# Clone the GraphQL repository and install dependencies
git clone https://github.com/hanwister/graphql.git
cd graphql

# Install project dependencies and global packages
npm install
npm install node-red pm2 -g

# Start the application
bash start.sh
