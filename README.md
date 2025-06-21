# 🌐 Multi-Datacenter Microservices Architecture (VXLAN + Docker)

This project simulates a production-like microservices deployment spanning **three datacenters** using Docker, VXLAN (simulated), and network automation. It's intended for educational use and lab environments.

## 🏗️ Architecture Overview

![Architecture Diagram](A_diagram_titled_"Multi-Datacenter_Microservices_A.png")

## 🔧 Microservices List

| Service            | Port | Description                      | Deployed In         |
|--------------------|------|----------------------------------|----------------------|
| `gateway-nginx`    | 80   | Load balancer (static page)      | DC1, DC2, DC3        |
| `user-nginx`       | 8080 | Simulates user management        | DC1, DC3             |
| `catalog-nginx`    | 8081 | Simulates product catalog        | DC1, DC3             |
| `order-nginx`      | 8082 | Simulates order processing       | DC1, DC2, DC3        |
| `payment-nginx`    | 8083 | Simulates payment processing     | DC2, DC3             |
| `notify-nginx`     | 8084 | Simulates notifications          | DC2, DC3             |
| `analytics-nginx`  | 8085 | Simulates analytics reporting    | DC3 only             |
| `discovery-nginx`  | 8500 | Simulates service discovery API  | DC3 only             |

## 🛠️ Infrastructure Setup

> All automated via `Makefile` with 20+ targets

### 💻 Required Tools

- Docker installed
- Bash
- Make

### 🔁 Key Makefile Targets

| Category           | Target                        | Description                                   |
|--------------------|-------------------------------|-----------------------------------------------|
| Infrastructure     | `make setup-infrastructure`   | Sets up Docker networks and simulates VXLAN   |
| Build              | `make build-all-images`       | Builds all NGINX containers                   |
| Deploy             | `make deploy-services`        | Deploys services across all 3 DCs             |
| Testing            | `make test`                   | Runs basic service and connectivity tests     |
| Cleanup            | `make cleanup-services`       | Removes all containers                        |

## 📡 Network Configuration

| Datacenter | Docker Network | Subnet            |
|------------|----------------|-------------------|
| DC1        | `dc1-net`      | `172.31.101.0/24` |
| DC2        | `dc2-net`      | `172.31.102.0/24` |
| DC3        | `dc3-net`      | `172.31.103.0/24` |

## 🚀 Getting Started (Quick Run)

```bash
# Step 1: Setup networks (VXLAN simulated)
make setup-infrastructure

# Step 2: Build all images
make build-all-images

# Step 3: Deploy services
make deploy-services

# Step 4: Test
make test
make health-check
```

## 🔍 Troubleshooting

- ❌ `make: *** missing separator` → Use TABs, not spaces, in Makefile.
- ❌ `Pool overlaps` → Use /24 subnets like `172.31.X.0/24`.
- ❌ Hanging on `ip link` → VXLAN not supported; simulate with Docker networks only.

## 📂 Project Structure

```
microservices-vxlan-project/
├── Makefile
├── architecture/
│   ├── network-topology.md
│   ├── service-architecture.md
├── configs/
│   ├── nginx/
│   └── network/
├── data/
│   └── service-responses/
├── dockerfiles/
├── scripts/
│   ├── infrastructure/
│   └── deployment/
├── docs/
│   └── setup-guide.md
```

## 📌 Credits

- Created by: Your Name
- For simulation and learning purposes
