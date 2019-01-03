#! /bin/bash
docker run -d -p 8080:8080 \
  -e HASURA_GRAPHQL_DATABASE_URL=postgres://brev@host.docker.internal/htmdb \
  -e HASURA_GRAPHQL_ENABLE_CONSOLE=true \
  --name hasura \
  hasura/graphql-engine:v1.0.0-alpha33

