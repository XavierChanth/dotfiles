FROM archlinux:base@sha256:31f0749bdb81517dc8f379feac0a3860b097f1da1f53c8315c1bae0817d6c0a1

RUN yes | pacman-key --init
RUN yes | pacman-key --populate archlinux
RUN pacman -Sy --noconfirm archlinux-keyring
RUN pacman -S --noconfirm \
  gcc \
  glib2 \
  gtk3 \
  i3status \
  i3-wm \
  python-pip \
  libxcb \
  ttf-dejavu \
  xorg-apps \
  xorg-server \
  xorg-server-xvfb \
  xorg-xinit

# Setup locale (required for i3)
RUN sed -i '/en_US.UTF-8/s/^#//g' /etc/locale.gen
RUN locale-gen

RUN useradd -m user
ENV HOME_DIR=/home/user
ENV APP_DIR="$HOME_DIR/flashfocus"

WORKDIR "$HOME_DIR"
USER user
