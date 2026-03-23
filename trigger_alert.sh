#!/bin/bash

URL="https://endpoint4.collection.sumologic.com/receiver/v1/http/ZaVnC4dhaV12nzQkY59-QQQQg0DqPgn8DBkHe1u-ry-3iKpJq71M1ABjkeU8CGJ9qzC5rTRIxC1sTLOcf4eUYxI8DA3w5QajTqkql8f3M-Jvv-dqqZ68uQ=="

for i in {1..6}; do
  curl -X POST -H "Content-Type: application/json" -d '{"endpoint": "/api/data", "response_time_ms": 3500}' "$URL"
  echo " Sent log $i"
  sleep 1
done