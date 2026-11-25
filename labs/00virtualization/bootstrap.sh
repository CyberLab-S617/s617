#!/usr/bin/env bash
#
# S617 Workshop - bootstrap.sh
# ----------------------------------------------------------------------------
# Vagrant's SHELL provisioner runs this inside the guest as root. No Ansible,
# no extra tooling - just bash, so there's nothing to install before it starts.
#
# WHAT IT BUILDS:
#   - Docker Engine + CLI + Buildx + Compose v2   (the container engine)
#   - LXC                                          (system containers, for the
#                                                   "a container can be a whole
#                                                   OS" contrast to Docker)
#   - XFCE desktop + LightDM                       (so THIS VM is visually a
#                                                   graphical machine - students
#                                                   can tell "I'm in the VM"
#                                                   (a desktop) apart from
#                                                   "I'm in a container" (a bare
#                                                   shell with a different prompt)
#   - the login user added to the docker group
#
# WHY NO virt-manager: VMs are taught with the host's VirtualBox directly (the
# hypervisor the student already runs), which avoids nested virtualization and
# all its KVM/Hyper-V headaches. A VM is a VirtualBox window; a container is a
# shell inside this VM. Clean, reliable, and the same box serves every lab.
#
# Idempotent: safe to run again (e.g. `vagrant provision`). This script is also
# workshop material - students read it to see a real provisioning script.

set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

# Desktop toggle (default ON). Set INSTALL_DESKTOP=false in the Vagrantfile's
# env block for a headless build if a future lab doesn't need the GUI.
INSTALL_DESKTOP="${INSTALL_DESKTOP:-true}"

# The human login user to grant docker to. On a Vagrant box this is 'vagrant';
# fall back to the first real login user if that's somehow absent.
TARGET_USER="vagrant"
id "$TARGET_USER" >/dev/null 2>&1 || \
  TARGET_USER="$(awk -F: '$3>=1000 && $3<65534 {print $1; exit}' /etc/passwd)"
echo "Provisioning for user: $TARGET_USER  |  desktop: $INSTALL_DESKTOP"

# ---------------------------------------------------------------------------
# Base packages
# ---------------------------------------------------------------------------
echo "== apt update + prerequisites =="
apt-get update -y
apt-get install -y ca-certificates curl gnupg

# ---------------------------------------------------------------------------
# Docker Engine - official repo, arch + Ubuntu codename derived (not hardcoded)
# ---------------------------------------------------------------------------
echo "== Docker =="
install -m 0755 -d /etc/apt/keyrings
if [ ! -s /etc/apt/keyrings/docker.asc ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
fi
# shellcheck disable=SC1091
. /etc/os-release
ARCH="$(dpkg --print-architecture)"
CODENAME="${UBUNTU_CODENAME:-${VERSION_CODENAME:-noble}}"
echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${CODENAME} stable" \
  > /etc/apt/sources.list.d/docker.list
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker

# ---------------------------------------------------------------------------
# LXC - system containers
# ---------------------------------------------------------------------------
echo "== LXC =="
apt-get install -y lxc

# ---------------------------------------------------------------------------
# Group membership so docker works without sudo.
# NOTE: the docker group is root-equivalent - that's the escape lesson later.
# ---------------------------------------------------------------------------
echo "== groups =="
if getent group docker >/dev/null && ! id -nG "$TARGET_USER" | tr ' ' '\n' | grep -qx docker; then
  usermod -aG docker "$TARGET_USER"
  echo "  added $TARGET_USER to docker"
fi

# ---------------------------------------------------------------------------
# XFCE desktop + LightDM, so the VM is visually a graphical machine.
# Auto-login the workshop user so the desktop "just appears" (fallback password
# is the Vagrant default: vagrant / vagrant).
# ---------------------------------------------------------------------------
if [ "$INSTALL_DESKTOP" = "true" ]; then
  echo "== XFCE desktop =="
  apt-get install -y xfce4 xfce4-terminal lightdm

  # Auto-login the workshop user at the graphical screen.
  mkdir -p /etc/lightdm/lightdm.conf.d
  cat > /etc/lightdm/lightdm.conf.d/50-s617-autologin.conf <<EOF
[Seat:*]
autologin-user=$TARGET_USER
autologin-user-timeout=0
user-session=xfce
EOF
  # Some setups require the user to be in the 'autologin' group.
  getent group autologin >/dev/null || groupadd autologin
  usermod -aG autologin "$TARGET_USER" || true

  # Boot into the graphical target so the desktop comes up on screen.
  systemctl set-default graphical.target
  systemctl enable lightdm
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo "== done =="
docker --version
lxc-create --version 2>/dev/null || true
echo "Desktop: $INSTALL_DESKTOP (login user: $TARGET_USER, password: vagrant)"
