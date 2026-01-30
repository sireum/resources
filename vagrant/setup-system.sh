set -ex
export DEBIAN_FRONTEND=noninteractive
wget -O /usr/bin/ape https://cosmo.zip/pub/cosmos/bin/ape-$(uname -m).elf
chmod +x /usr/bin/ape
sh -c "echo ':APE:M::MZqFpD::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register"
sh -c "echo ':APE-jart:M::jartsr::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register"
add-apt-repository universe
add-apt-repository ppa:hickford/git-credential-oauth
locale-gen en_US en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
apt update
apt upgrade -y
apt install -y zsh software-properties-common locales materia-gtk-theme papirus-icon-theme \
               chromium-browser hugo firefox git-credential-oauth zlib1g-dev \
               build-essential dkms linux-headers-$(uname -r)
useradd -m -d /home/$UNAME -s /bin/zsh -p $(openssl passwd -1 $UPASSWD) $UNAME
usermod -aG sudo $UNAME
if [ "$UBUNTU" = "jammy" ]; then
  apt install -y xubuntu-core^
  if [ "$NO_ROS" != "true" ]; then
    apt install -y ros-dev-tools ros-humble-desktop
  fi
else
  apt install -y xubuntu-desktop-minimal
  if [ "$NO_ROS" != "true" ]; then
    apt install -y ros-dev-tools ros-jazzy-desktop
  fi
fi
