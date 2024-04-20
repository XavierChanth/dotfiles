# hadolint global ignore=DL3059

# hadolint ignore=DL3007
FROM fedora:latest

RUN dnf update -y
# hadolint ignore=DL3041
RUN dnf install -y zsh; dnf clean all

# Add user "chant"
RUN useradd -rm -d /home/chant -s /bin/zsh -g root -G wheel -u 501 chant
RUN passwd -d chant
RUN chsh -s /bin/zsh chant
USER chant
WORKDIR /home/chant

# Install dotfiles
RUN rm -rf /home/chant/.zshrc
ADD "https://api.github.com/repos/xavierchanth/dotfiles/commits?per_page=1" latest_commit
RUN git clone https://github.com/xavierchanth/dotfiles.git /home/chant/.dotfiles
WORKDIR /home/chant/.dotfiles
RUN git remote set-url --push origin git@github.com:xavierchanth/dotfiles.git
WORKDIR /home/chant

RUN chmod u+x /home/chant/.dotfiles/install.sh; \
  /home/chant/.dotfiles/install.sh

# Keep the container from exiting
ENTRYPOINT ["tail"]
CMD ["-f", "/dev/null"]
