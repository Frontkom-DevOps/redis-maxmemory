#!/usr/bin/env bash

set -euo pipefail

if [[ -n "${DEBUG:-}" ]]; then
    set -x
fi

function calculate-maxmemory() {
  # Do not allow setting maxmemory as we calculate tis value.
  if [[ "${REDIS_MAXMEMORY:-NA}" != "NA" ]]; then
      echo >&2 'error: Do not set REDIS_MAXMEMORY, set REDIS_MAXMEMORY_PERCENT instead.'
      exit 1
  fi

  # Only allow redis to use 1-100% of system memory.
  if [[ "${REDIS_MAXMEMORY_PERCENT}" -gt 100 ]]; then
      echo >&2 'error: REDIS_MAXMEMORY_PERCENT must be between 1 and 100.'
      exit 1
  fi

  # If REDIS_MAXMEMORY_PERCENT is over 90% warn the user.
  if [[ "${REDIS_MAXMEMORY_PERCENT}" -gt 90 ]]; then
      echo >&2 'warning: REDIS_MAXMEMORY_PERCENT is over 90%, this may cause issues with the system!'
  fi

  # Calculate total system memory and adjust for Redis based on REDIS_MAXMEMORY_PERCENT.
  total_mem_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
  adjusted_mem_kb=$((total_mem_kb * REDIS_MAXMEMORY_PERCENT / 100))
  # Transform to MB and round down.
  adjusted_mem=$((adjusted_mem_kb / 1024))

  # Set the maxmemory value in the redis config.
  export REDIS_MAXMEMORY="${adjusted_mem}mb"
}

function main() {
  calculate-maxmemory

  /docker-entrypoint.sh "${@}"
}

main "${@}"
