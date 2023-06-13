# syntax=docker/dockerfile:1
ARG paper_build=550
ARG paper_version=1.19.4
ARG velocity_build=258
ARG velocity_version=3.2.0-SNAPSHOT
ARG java_runtime_xms=1G
ARG java_runtime_xmx=1G

# Create a minimal build of Java 19 usable for
# our services.
# -----------------------------------------------
FROM openjdk:19-oraclelinux8 AS JavaBuilder
USER root
RUN \
    --mount=type=bind,source=minecraft/build_java.sh,target=/opt/build_java.sh \
    /opt/build_java.sh
USER app

# Collect our necessary JAR files for our
# services.
# -----------------------------------------------
FROM cvisionai/wget:latest AS JarCollector
WORKDIR /opt/jars
ARG paper_build
ARG paper_version
ARG velocity_build
ARG velocity_version

ENV PAPER_BUILD=${paper_build}
ENV PAPER_VERSION=${paper_version}
ENV VELOCITY_BUILD=${velocity_build}
ENV VELOCITY_VERSION=${velocity_version}

RUN \
    --mount=type=bind,source=minecraft/wget_jars.sh,target=/opt/wget_jars.sh \
    /opt/wget_jars.sh

# Builds the docker cli binary from source.
# -----------------------------------------------
FROM ubuntu:latest AS DockerBuilder
WORKDIR /opt/docker
ENV DOCKER_VERSION=24.0.2
ENV DOCKER_ARCH=x86_64

RUN apt-get update && apt-get upgrade -yq
RUN apt-get install python wget -yq
RUN \
    --mount=type=bind,source=minecraft/build_docker.sh,target=/opt/build_docker.sh \
    /opt/build_docker.sh

# Finalize our image. Include needed environment
# variables, binaries and scripts
# -----------------------------------------------
FROM ubuntu:latest AS base
ARG java_runtime_xms
ARG java_runtime_xmx

ENV JAVA_HOME=/opt/jre-minimal
ENV JAVA_RUNTIME_XMS=${java_runtime_xms}
ENV JAVA_RUNTIME_XMX=${java_runtime_xmx}
ENV PATH="$PATH:$JAVA_HOME/bin"

COPY --from=JavaBuilder /opt/jre-minimal /opt/jre-minimal
COPY --from=JarCollector /opt/jars /opt/jars
COPY . /opt

# Builds the velocity image.
# docker build . --tag=<tag-name> --target=proxy
# -----------------------------------------------
FROM base AS proxy
WORKDIR /opt/app
COPY --from=DockerBuilder /opt/docker/docker/docker /usr/local/bin/
# MC default listening port.
EXPOSE 25565
ENTRYPOINT [ "/opt/minecraft/start_proxy.sh" ]

# Builds the server image.
# docker build . --tag=<tag-name> --target=server
# -----------------------------------------------
FROM base AS server
WORKDIR /opt/app
# MC default listening port.
EXPOSE 25565
# MC remote console port.
EXPOSE 25575
ENTRYPOINT [ "/opt/minecraft/start_server.sh" ]
