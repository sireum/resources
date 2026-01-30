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
bin/sireum setup vscode --extensions scala-lang.scala
if [ `uname -m` = "aarch64" ]; then
  chown root:root bin/linux/arm/vscodium/chrome-sandbox; sudo chmod 4755 bin/linux/arm/vscodium/chrome-sandbox
else
  chown root:root bin/linux/vscodium/chrome-sandbox; sudo chmod 4755 bin/linux/vscodium/chrome-sandbox
  bin/build.cmd native
fi
bin/install/rust.cmd
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
else
  ln -s $SIREUM_HOME/bin/linux/java/bin/java .
  echo 'export JAVA_HOME=$SIREUM_HOME/bin/linux/java' >> $HOME/.zshrc
  find $HOME/.config/xfce4/panel -type f -print0 | xargs -0 sed -i "s/kekinian\/bin\/linux\/arm/kekinian\/bin\/linux/g"
fi
cd $HOME
git credential-oauth configure
