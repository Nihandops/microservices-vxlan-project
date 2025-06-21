# =======================
# MULTI-DATACENTER MAKEFILE
# =======================

# --------------------
# Infrastructure Targets
# --------------------

setup-infrastructure: setup-vxlan-mesh setup-docker-networks

setup-vxlan-mesh:
	bash configs/network/vxlan-config.sh

setup-docker-networks:
	docker network create --driver=bridge --subnet=10.200.0.0/16 dc1-net || true
	docker network create --driver=bridge --subnet=10.300.0.0/16 dc2-net || true
	docker network create --driver=bridge --subnet=10.400.0.0/16 dc3-net || true

cleanup-infrastructure: cleanup-vxlan cleanup-networks

cleanup-vxlan:
	-ip link del vxlan200 || true
	-ip link del vxlan300 || true
	-ip link del vxlan400 || true

cleanup-networks:
	-docker network rm dc1-net dc2-net dc3-net || true

show-network-status:
	ip a show | grep vxlan || true

show-routing-table:
	ip route show

validate-infrastructure:
	ping -c 2 10.300.1.1 || true
	ping -c 2 10.400.1.1 || true

# --------------------
# Build Targets
# --------------------

build-all-images: build-gateway build-user build-catalog build-order build-payment build-notify build-analytics build-discovery

build-gateway:
	docker build -t gateway-nginx -f dockerfiles/Dockerfile.gateway-nginx .

build-user:
	docker build -t user-nginx -f dockerfiles/Dockerfile.user-nginx .

build-catalog:
	docker build -t catalog-nginx -f dockerfiles/Dockerfile.catalog-nginx .

build-order:
	docker build -t order-nginx -f dockerfiles/Dockerfile.order-nginx .

build-payment:
	docker build -t payment-nginx -f dockerfiles/Dockerfile.payment-nginx .

build-notify:
	docker build -t notify-nginx -f dockerfiles/Dockerfile.notify-nginx .

build-analytics:
	docker build -t analytics-nginx -f dockerfiles/Dockerfile.analytics-nginx .

build-discovery:
	docker build -t discovery-nginx -f dockerfiles/Dockerfile.discovery-nginx .

# --------------------
# Deployment Targets
# --------------------

deploy-services: deploy-dc1-services deploy-dc2-services deploy-dc3-services

deploy-dc1-services:
	docker run -d --name gateway-nginx-dc1 --network dc1-net -p 80:80 gateway-nginx
	docker run -d --name user-nginx-dc1 --network dc1-net -p 8080:80 user-nginx
	docker run -d --name catalog-nginx-dc1 --network dc1-net -p 8081:80 catalog-nginx
	docker run -d --name order-nginx-dc1 --network dc1-net -p 8082:80 order-nginx

deploy-dc2-services:
	docker run -d --name gateway-nginx-dc2 --network dc2-net -p 8086:80 gateway-nginx
	docker run -d --name payment-nginx-dc2 --network dc2-net -p 8083:80 payment-nginx
	docker run -d --name notify-nginx-dc2 --network dc2-net -p 8084:80 notify-nginx
	docker run -d --name order-nginx-dc2 --network dc2-net -p 8087:80 order-nginx

deploy-dc3-services:
	docker run -d --name discovery-nginx-dc3 --network dc3-net -p 8500:80 discovery-nginx
	docker run -d --name gateway-nginx-dc3 --network dc3-net -p 8088:80 gateway-nginx
	docker run -d --name user-nginx-dc3 --network dc3-net -p 8089:80 user-nginx
	docker run -d --name catalog-nginx-dc3 --network dc3-net -p 8090:80 catalog-nginx
	docker run -d --name order-nginx-dc3 --network dc3-net -p 8091:80 order-nginx
	docker run -d --name payment-nginx-dc3 --network dc3-net -p 8092:80 payment-nginx
	docker run -d --name notify-nginx-dc3 --network dc3-net -p 8093:80 notify-nginx
	docker run -d --name analytics-nginx-dc3 --network dc3-net -p 8094:80 analytics-nginx

# --------------------
# Management Targets
# --------------------

stop-services:
	-docker stop $$(docker ps -q)

start-services:
	-docker start $$(docker ps -a -q)

cleanup-services:
	-docker rm -f $$(docker ps -a -q)

# --------------------
# Testing & Validation Targets
# --------------------

test: test-connectivity test-services test-cross-dc

test-connectivity:
	ping -c 1 10.300.1.1 || true
	ping -c 1 10.400.1.1 || true

test-services:
	curl -s http://localhost:8080 || echo "User service not responding"
	curl -s http://localhost:8081 || echo "Catalog service not responding"

test-cross-dc:
	curl -s http://10.300.1.1:8083 || echo "Payment service (DC2) unreachable from DC1"

health-check:
	docker ps --format "table {{.Names}}\t{{.Status}}"

show-logs:
	docker logs gateway-nginx-dc1 || true
