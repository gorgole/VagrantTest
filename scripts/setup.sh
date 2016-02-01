
#!/bin/sh

# update the system
sudo apt-get update
sudo apt-get upgrade

################################################################################
# This is a port of the manishgoyaler/devbox Dockerfile,
################################################################################

export JAVA_VERSION='8'
export JAVA_HOME='/usr/lib/jvm/java-8-oracle'

export MAVEN_VERSION='3.3.9'
export MAVEN_HOME='/usr/share/maven'
export PATH=$PATH:$MAVEN_HOME/bin

export LANGUAGE='en_US.UTF-8'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export ACTIVATOR_VER='1.3.7'
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales

# force encoding
sudo echo 'LANG=en_US.UTF-8' >> /etc/environment
sudo echo 'LANGUAGE=en_US.UTF-8' >> /etc/environment
sudo echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
sudo echo 'LC_CTYPE=en_US.UTF-8' >> /etc/environment

## install languages
sudo apt-get install -y language-pack-fr
sudo apt-get install -y language-pack-en

# install utilities
sudo apt-get -y install vim git sudo zip bzip2 fontconfig curl

# install Java 8
sudo echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list
sudo echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886
#other repo for java 8
#sudo add-apt-repository -y ppa:webupd8team/java
#
sudo apt-get update
#
sudo echo oracle-java-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install -y --force-yes oracle-java${JAVA_VERSION}-installer
sudo update-java-alternatives -s java-8-oracle
sudo apt-get install oracle-java8-set-default

# install maven
sudo curl -fsSL http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz | sudo tar xzf - -C /usr/share && sudo mv /usr/share/apache-maven-${MAVEN_VERSION} /usr/share/maven && sudo ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# install node.js
sudo curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -
sudo apt-get install -y nodejs unzip python g++ build-essential

# update npm
sudo npm install -g npm

# install yeoman gsudot bower grunt gulp
sudo npm install -g yo bower grunt-cli gulp

#install ruby and compass
sudo gem install compass

# Install necessary tools
sudo apt-get install -y nano wget dialog net-tools

# Download and Install Nginx
sudo apt-get install -y nginx

#installing activator
sudo mkdir -p /opt
cd /opt
sudo wget http://downloads.typesafe.com/typesafe-activator/${ACTIVATOR_VER}/typesafe-activator-${ACTIVATOR_VER}.zip \
   && unzip typesafe-activator-${ACTIVATOR_VER}.zip \
   && ln -s /opt/activator-dist-${ACTIVATOR_VER} /opt/activator \
   && rm -f /opt/typesafe-activator-${ACTIVATOR_VER}.zip

sudo chmod -R 777 /opt/activator
export PATH=$PATH:/opt/activator
sudo ln -s /opt/activator/activator /usr/bin/activator

#installing cassandra
sudo echo "deb http://debian.datastax.com/community stable main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list
sudo curl -L https://debian.datastax.com/debian/repo_key | apt-key add -
sudo apt-get update
sudo apt-get -q -y install dsc30
sudo apt-get install cassandra-tools ## Optional utilities

################################################################################
# Install the graphical environment
################################################################################

## sudo GUI as non-privileged user
#sudo echo 'allowed_users=anybody' > /etc/X11/Xwrapper.config
#
## install Ubuntu desktop and VirtualBox guest tools
#sudo apt-get install -y ubuntu-desktop virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
#sudo apt-get install -y gnome-session-flashback


################################################################################
# Install the zsh shell
################################################################################

sudo apt-get -y install zsh
sudo chsh -s $(which zsh)
touch ~/.zshrc
sudo sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#sudo chown -R vagrant:vagrant /home/vagrant

# clean the box
sudo dpkg --configure -a
sudo apt-get clean
dd if=/dev/zero of=/EMPTY bs=1M > /dev/null 2>&1
rm -f /EMPTY
