#!/bin/bash
# VXLAN Configuration for Multi-Datacenter Network Setup

# Define VXLAN interfaces for DC1, DC2, and DC3

# DC1 Network VXLAN Setup
echo "Setting up VXLAN for DC1..."
ip link add vxlan200 type vxlan id 200 dev eth0 dstport 4789
ip addr add 10.200.1.1/16 dev vxlan200
ip link set vxlan200 up

# DC2 Network VXLAN Setup
echo "Setting up VXLAN for DC2..."
ip link add vxlan300 type vxlan id 300 dev eth0 dstport 4789
ip addr add 10.300.1.1/16 dev vxlan300
ip link set vxlan300 up

# DC3 Network VXLAN Setup
echo "Setting up VXLAN for DC3..."
ip link add vxlan400 type vxlan id 400 dev eth0 dstport 4789
ip addr add 10.400.1.1/16 dev vxlan400
ip link set vxlan400 up

# Display VXLAN interfaces and routes
echo "Displaying VXLAN interfaces and routes..."
ip a show vxlan200
ip a show vxlan300
ip a show vxlan400
ip route show
