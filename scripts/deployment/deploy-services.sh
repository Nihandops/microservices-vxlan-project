#!/bin/bash
# Deploy all services in multi-datacenter setup

# Function to deploy DC1 services
deploy_dc1() {
  echo "Deploying DC1 services..."
  
  # Deploy Gateway Service
  docker run -d --name gateway-nginx-dc1 --network dc1-net -p 80:80 gateway-nginx
  # Deploy User Service
  docker run -d --name user-nginx-dc1 --network dc1-net -p 8080:80 user-nginx
  # Deploy Catalog Service
  docker run -d --name catalog-nginx-dc1 --network dc1-net -p 8081:80 catalog-nginx
  # Deploy Order Service
  docker run -d --name order-nginx-dc1 --network dc1-net -p 8082:80 order-nginx
}

# Function to deploy DC2 services
deploy_dc2() {
  echo "Deploying DC2 services..."

  # Deploy Gateway Service (Backup)
  docker run -d --name gateway-nginx-dc2 --network dc2-net -p 8086:80 gateway-nginx
  # Deploy Payment Service
  docker run -d --name payment-nginx-dc2 --network dc2-net -p 8083:80 payment-nginx
  # Deploy Notify Service
  docker run -d --name notify-nginx-dc2 --network dc2-net -p 8084:80 notify-nginx
  # Deploy Order Service (Replica)
  docker run -d --name order-nginx-dc2 --network dc2-net -p 8087:80 order-nginx
}

# Function to deploy DC3 services
deploy_dc3() {
  echo "Deploying DC3 services..."
  
  # Deploy Gateway Service
  docker run -d --name gateway-nginx-dc3 --network dc3-net -p 8088:80 gateway-nginx
  # Deploy User Service (Backup)
  docker run -d --name user-nginx-dc3 --network dc3-net -p 8089:80 user-nginx
  # Deploy Catalog Service (Backup)
  docker run -d --name catalog-nginx-dc3 --network dc3-net -p 8090:80 catalog-nginx
  # Deploy Order Service (Backup)
  docker run -d --name order-nginx-dc3 --network dc3-net -p 8091:80 order-nginx
  # Deploy Payment Service (Backup)
  docker run -d --name payment-nginx-dc3 --network dc3-net -p 8092:80 payment-nginx
  # Deploy Notify Service (Backup)
  docker run -d --name notify-nginx-dc3 --network dc3-net -p 8093:80 notify-nginx
  # Deploy Analytics Service
  docker run -d --name analytics-nginx-dc3 --network dc3-net -p 8094:80 analytics-nginx
  # Deploy Discovery Service
  docker run -d --name discovery-nginx-dc3 --network dc3-net -p 8500:80 discovery-nginx
}

# Start deployment
echo "Starting deployment of services across datacenters..."
deploy_dc1
deploy_dc2
deploy_dc3

echo "Deployment completed successfully!"
