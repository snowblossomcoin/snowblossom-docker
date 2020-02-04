ARG SNOWBLOSSOM_VERSION
ARG BAZEL_VERSION=2.0.0
ARG BAZEL_OPTIONS

FROM debian:10-slim as build
ARG SNOWBLOSSOM_VERSION=${SNOWBLOSSOM_VERSION}
ARG BAZEL_VERSION=${BAZEL_VERSION}
ARG BAZEL_OPTIONS=${BAZEL_OPTIONS}
COPY scripts/build/scripts /scripts
RUN /bin/bash /scripts/prepare-build-environment
RUN /bin/bash /scripts/build-snowblossom

FROM openjdk:11-slim as run
ARG SNOWBLOSSOM_VERSION=${SNOWBLOSSOM_VERSION}
ENV SNOWBLOSSOM_VERSION=${SNOWBLOSSOM_VERSION}
COPY --from=build /snowblossom/bazel-bin/Everything_deploy.jar /snowblossom/
COPY --from=build /snowblossom/example/configs/logging.properties /snowblossom/log.conf
COPY scripts/run/scripts /scripts
RUN /bin/sh /scripts/prepare-run-environment

VOLUME [/data]
ENTRYPOINT ["/bin/sh", "/scripts/entrypoint"]
CMD ["node"]
