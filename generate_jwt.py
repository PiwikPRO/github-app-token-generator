#!/usr/bin/env python3
import jwt
import time
import sys
import os

# Get PEM file path
pem = os.environ['PRIVATE_KEY']

# Get the App ID
app_id = os.environ['APP_ID']


payload = {
    # Issued at time
    'iat': int(time.time()),
    # JWT expiration time (10 minutes maximum)
    'exp': int(time.time()) + 600,
    # GitHub App's identifier
    'iss': app_id
}

# Create JWT
jwt_instance = jwt.JWT()
encoded_jwt = jwt_instance.encode(payload, pem, alg='RS256')

print(f"JWT:  ", encoded_jwt)