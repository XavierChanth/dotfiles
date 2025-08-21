ARG user=atsign
ARG flutter_version=stable

FROM ghcr.io/cirruslabs/flutter:${flutter_version}

USER root

ENV HOME=/home/${user}

# We always add US to the locale because some tools break without it.
# The sed line removes blank lines so if you don't specify a locale
# then only US will be set.
RUN useradd -m ${user} \
  usermod -aG wheel ${user} \
  echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers;

ENV FLUTTER_HOME=${HOME}/sdks/flutter \
  FLUTTER_VERSION=$flutter_version
ENV FLUTTER_ROOT=$FLUTTER_HOME


ENV WORKSPACE="/workspace"
ENV PUB_CACHE="/workspace/.pub-cache"

ENV PATH="${PATH}:${PUB_CACHE}/bin:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin"

RUN git clone --depth 1 --branch "${FLUTTER_VERSION}" https://github.com/flutter/flutter.git "${FLUTTER_HOME}"; \
  flutter --disable-analytics; \
  flutter doctor; \
  chown -R ${user}:${user} "${FLUTTER_HOME}"; \
  chown -R ${user}:${user} "${WORKSPACE}"; \
  dart pub global activate at_repl; \
  dart pub global activate at_pkam;

USER ${user}
