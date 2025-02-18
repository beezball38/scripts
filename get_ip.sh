#!/bin/bash

read -p "Enter the network interface (e.g., tun0): " interface

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    ip -4 addr show $interface | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    ifconfig $interface | grep "inet " | awk '{print $2}'
else
    echo "Unsupported OS"
fi

