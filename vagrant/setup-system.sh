set -ex
export DEBIAN_FRONTEND=noninteractive
add-apt-repository universe
add-apt-repository ppa:hickford/git-credential-oauth
locale-gen en_US en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
apt update
apt upgrade -y
apt install -y zsh software-properties-common locales materia-gtk-theme papirus-icon-theme \
               open-vm-tools-desktop chromium-browser hugo firefox git-credential-oauth
useradd -m -d /home/$UNAME -s /bin/zsh -p $(openssl passwd -1 $UPASSWD) $UNAME
usermod -aG sudo $UNAME
if [ "$UBUNTU" = "noble" ]; then
  apt install -y xubuntu-desktop-minimal
  if [ "$NO_ROS" != "true" ]; then
    apt install -y ros-dev-tools ros-jazzy-desktop
  fi
  if [ "$NO_JEXTRACT" != "true" ]; then
    if [ `uname -m` = "aarch64" ]; then
      wget --no-check-certificate http://launchpadlibrarian.net/666971087/libtinfo5_6.3-2ubuntu0.1_arm64.deb
      dpkg -i libtinfo5_6.3-2ubuntu0.1_arm64.deb
      rm libtinfo5_6.3-2ubuntu0.1_arm64.deb
    else
      wget --no-check-certificate http://launchpadlibrarian.net/666971015/libtinfo5_6.3-2ubuntu0.1_amd64.deb
      dpkg -i libtinfo5_6.3-2ubuntu0.1_amd64.deb
      rm libtinfo5_6.3-2ubuntu0.1_amd64.deb
    fi
  fi
else
  apt install -y xubuntu-core^
  if [ "$NO_ROS" != "true" ]; then
    apt install -y ros-dev-tools ros-humble-desktop
  fi
fi
