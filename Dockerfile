# syntax=docker/dockerfile:1.5-labs
FROM --platform=linux/amd64 alpine:latest as builder
ADD https://github.com/nanopb/nanopb.git /app/nanopb
COPY entrypoint.sh /app/entrypoint.sh
RUN set -ex; \
  apk add --no-cache g++ make openssl protobuf py3-grpcio py3-pip python3; \
  python3 -m pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels protobuf; \
  python3 -m pip install --no-cache --break-system-packages /app/wheels/*.whl; \
  ls -al /app; \
  /app/nanopb/generator/nanopb_generator.py --version

FROM --platform=linux/amd64 alpine:latest as app
ENV INPUT_COMMAND='/nanopb/generator/nanopb_generator.py --version'
ENTRYPOINT ["/entrypoint.sh"]
COPY --from=builder /app /
RUN set -ex; \
  chmod +x /entrypoint.sh; \
  apk add --no-cache protobuf py3-grpcio py3-pip python3; \
  python3 -m pip install --no-cache --break-system-packages /wheels/*.whl; \
  rm -rf /wheels; \
  /nanopb/generator/nanopb_generator.py --version
