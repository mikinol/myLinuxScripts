#!/bin/bash
rand_number=$(head /dev/urandom | tr -dc '0-9' | head -c7)
echo "0$rand_number"

