# Redis Docker Container Image

[![Build](https://github.com/Frontkom-DevOps/redis-memory-percent/actions/workflows/build.yml/badge.svg)](https://github.com/Frontkom-DevOps/redis-memory-percent/actions/workflows/build.yml)

## Docker Images

Simple wrapper saround wodby/redis which introduces the `REDIS_MAXMEMORY_PERCENT` variable.
This allows setting the `maxmemory` value as a percentage of the available memory, instead of a fixed value.
The value is calculated on container startup as `system_memory * REDIS_MAXMEMORY_PERCENT / 100`.

Overview:

- Based on Alpine Linux
- Base image: [wodby/redis](https://github.com/wodby/redis)

All images built for `linux/amd64` and `linux/arm64`

## Environment Variables

| Variable                          | Default Value | Description |
|-----------------------------------|---------------|-------------|
| `REDIS_MAXMEMORY_PERCENT`         | `90`          |  |
| `REDIS_MAXMEMORY`                 |               | :!!: **Not allowed** as would clash with the "percent" mode. |

For other env variables please refer to the base [image wodby/redis documentation](https://github.com/wodby/redis?tab=readme-ov-file#environment-variables).

### Usage

You can run this image as any other image based on `wodby/redis`:

```bash
docker run --rm -it \
    -e REDIS_MAXMEMORY_PERCENT=50 \ # Example: use 50% of the system memory
    -p 6379:6379 \
    ghcr.io/frontkom-devops/redis-memory-percent:1.x
```

#### Docker Compose

```yaml
version: '3.7'

services:
  redis:
    image: ghcr.io/frontkom-devops/redis-memory-percent:1.x
    environment:
      REDIS_MAXMEMORY_PERCENT: 50
    ports:
      - 6379:6379
```
