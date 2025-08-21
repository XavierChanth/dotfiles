FROM ghcr.io/cirruslabs/flutter:${templateOption:channel}

USER root

ENV USER=atsign
ENV HOME=/home/${USER}

# We always add US to the locale because some tools break without it.
# The sed line removes blank lines so if you don't specify a locale
# then only US will be set.
RUN useradd -m ${USER} \
  usermod -aG wheel ${USER} \
  echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers;

ENV FLUTTER_HOME=${HOME}/sdks/flutter \
  FLUTTER_VERSION=${templateOption:channel}
ENV FLUTTER_ROOT=$FLUTTER_HOME
ENV WORKSPACE="/workspace"
ENV PUB_CACHE="/workspace/.pub-cache"

ENV PATH="${PATH}:${PUB_CACHE}/bin:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin"

RUN git clone --depth 1 --branch "${FLUTTER_VERSION}" https://github.com/flutter/flutter.git "${FLUTTER_HOME}"; \
  flutter --disable-analytics; \
  flutter doctor; \
  chown -R ${USER}:${USER} "${FLUTTER_HOME}"; \
  chown -R ${USER}:${USER} "${WORKSPACE}"; \
  dart pub global activate at_repl; \
  dart pub global activate at_pkam;

USER ${USER}
