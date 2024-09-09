set -ex
mkdir -p $HOME/Applications/bin
mkdir -p $HOME/Repositories/Sireum
cd $HOME/Repositories/Sireum
git clone https://github.com/sireum/kekinian
export SIREUM_HOME=$HOME/Repositories/Sireum/kekinian
touch $HOME/.zshrc
echo 'export PATH=$HOME/Applications/bin:$PATH:$HOME/Applications/jextract/bin' > $HOME/.zprofile
echo "export SIREUM_HOME=$SIREUM_HOME" >> $HOME/.zprofile
wget -q https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh --unattended
rm -f install.sh
echo 'export PATH=$HOME/Applications/bin:$PATH:$HOME/Applications/jextract/bin' >> $HOME/.zshrc
echo "export SIREUM_HOME=$SIREUM_HOME" >> $HOME/.zshrc
cd $SIREUM_HOME
if [ ! -z "$SIREUM_SHA" ]; then
  git checkout $SIREUM_SHA
fi
git submodule update --init --recursive
bin/build.cmd setup
bin/install/rust.cmd
bin/install/vscodium.cmd
bin/install/brave.cmd
cd $HOME
mkdir -p $HOME/.config/xfce4/panel
echo "button-icon=$SIREUM_HOME/resources/distro/icons/idea_logo_background.png" > $HOME/.config/xfce4/panel/whiskermenu-1.rc
eval `dbus-launch --sh-syntax`
xfconf-query --create --type string -c xfwm4 -p /general/theme -s Materia-dark-compact
xfconf-query -c xsettings -p /Net/ThemeName -s Materia-dark-compact
xfconf-query -c xsettings -p /Net/IconThemeName -s Papirus-Dark
kill -HUP $DBUS_SESSION_BUS_PID
tar xfz /vagrant/xfce4-panel.tar.gz
cd $HOME/Applications/bin
ln -s $SIREUM_HOME/bin/sireum .
if [ `uname -m` = "aarch64" ]; then
  ln -s $SIREUM_HOME/bin/linux/arm/java/bin/java .
  echo 'export JAVA_HOME=$SIREUM_HOME/bin/linux/arm/java' >> $HOME/.zshrc
  if [ "$NO_JEXTRACT" != "true" ]; then
    cd $HOME/Applications
    wget https://github.com/sireum/rolling/releases/download/jextract/jextract-jdk22-linux-arm64.tar.gz
    tar xfz jextract-jdk22-linux-arm64.tar.gz
    rm jextract-jdk22-linux-arm64.tar.gz
  fi
else
  ln -s $SIREUM_HOME/bin/linux/java/bin/java .
  echo 'export JAVA_HOME=$SIREUM_HOME/bin/linux/java' >> $HOME/.zshrc
  find $HOME/.config/xfce4/panel -type f -print0 | xargs -0 sed -i "s/kekinian\/bin\/linux\/arm/kekinian\/bin\/linux/g"
  if [ "$NO_JEXTRACT" != "true" ]; then
    cd $HOME/Applications
    wget --no-check-certificate https://download.java.net/java/early_access/jextract/22/5/openjdk-22-jextract+5-33_linux-x64_bin.tar.gz
    tar xfz openjdk-22-jextract+5-33_linux-x64_bin.tar.gz
    mv jextract-22 jextract
    rm openjdk-22-jextract+5-33_linux-x64_bin.tar.gz
  fi
fi
cd $HOME
git credential-oauth configure
