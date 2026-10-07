#!/usr/bin/env bash
cd "$(dirname "$0")"
(cd backend && ./mvnw spring-boot:run) &
(cd frontend && npm install && npm run dev) &
wait
