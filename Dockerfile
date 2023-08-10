FROM --platform=linux/amd64 alpine:3.18 as builder
RUN set -ex; \
  apk add --no-cache python3 py3-grpcio py3-pip make g++ openssl wget unzip protobuf; \
  python3 -m pip wheel --no-cache-dir --no-deps --wheel-dir /wheels protobuf; \
  python3 -m pip install --no-cache /wheels/*.whl; \
  wget -O /nanopb.zip https://github.com/nanopb/nanopb/archive/refs/heads/master.zip; \
  unzip nanopb.zip; \
  mv /nanopb-master /nanopb; \
  /nanopb/generator/nanopb_generator.py --version

FROM --platform=linux/amd64 alpine:3.18 as app
ENV INPUT_COMMAND='/nanopb/generator/nanopb_generator.py --version'
ENTRYPOINT ["/entrypoint.sh"]
COPY entrypoint.sh /entrypoint.sh
COPY --from=builder /wheels /wheels
COPY --from=builder /nanopb /nanopb
RUN set -ex; \
  chmod +x /entrypoint.sh; \
  apk add --no-cache python3 py3-grpcio py3-pip protobuf; \
  python3 -m pip install --no-cache /wheels/*.whl; \
  /nanopb/generator/nanopb_generator.py --version