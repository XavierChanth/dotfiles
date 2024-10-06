#!/usr/bin/env bash

dnf update -y
dnf install -y zsh git passwd util-linux-user openssh-server
dnf clean all

useradd -rm -d /home/chant -s /bin/zsh -g root -G wheel -u 501 chant
passwd -d chant
chsh -s /bin/zsh chant

read -r -d '' post_install_script <<'EOF'
#!/usr/bin/env bash
set -eu
ssh-keygen -t ed25519 -N '' -f /home/chant/.ssh/id_ed25519
(cd /home/chant; rm -rf /home/chant/.zshrc; git clone https://github.com/xavierchanth/dotfiles.git /home/chant/.dotfiles)
(cd /home/chant/.dotfiles; git remote set-url --push origin git@github.com:xavierchanth/dotfiles.git)
/home/chant/.dotfiles/install
EOF

touch /home/chant/post-install.sh
chown chant /home/chant/post-install.sh
chmod u+x /home/chant/post-install.sh
echo "$post_install_script" >/home/chant/post-install.sh

su chant -c /home/chant/post-install.sh
rm /home/chant/post-install.sh

passwd chant
