ARG WODBY_TAG="7"

FROM wodby/redis:${WODBY_TAG}

ENV REDIS_MAXMEMORY_PERCENT=90

COPY ./docker-entrypoint.wrapper.sh /docker-entrypoint.wrapper.sh

ENTRYPOINT ["/docker-entrypoint.wrapper.sh"]

CMD [ "redis-server" , "/etc/redis.conf" ]
