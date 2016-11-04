#!/bin/bash
#
# provision-centos.sh
#
# This file used for provisioning a CentOS7 server

# By storing the date now, we can calculate the duration of provisioning at the
# end of this script.
start_seconds="$(date +%s)"

#IUS INSTALL
el5_download_install(){
  sudo wget -O /tmp/release.rpm ${1}
  sudo yum -y localinstall /tmp/release.rpm
  sudo rm -f /tmp/release.rpm
}

centos_install_epel(){
  # CentOS has epel release in the extras repo
  sudo yum -y install epel-release
  import_epel_key
}

rhel_install_epel(){
  case ${RELEASE} in
    5*) el5_download_install https://dl.fedoraproject.org/pub/epel/epel-release-latest-5.noarch.rpm;;
    6*) sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm;;
    7*) sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;;
  esac
  import_epel_key
}

import_epel_key(){
  case ${RELEASE} in
    5*) sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL;;
    6*) sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6;;
    7*) sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7;;
  esac
}

centos_install_ius(){
  case ${RELEASE} in
    5*) el5_download_install https://centos5.iuscommunity.org/ius-release.rpm;;
    6*) sudo yum -y install https://centos6.iuscommunity.org/ius-release.rpm;;
    7*) sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm;;
  esac
  import_ius_key
}

rhel_install_ius(){
  case ${RELEASE} in
    5*) el5_download_install https://rhel5.iuscommunity.org/ius-release.rpm;;
    6*) sudo yum -y install https://rhel6.iuscommunity.org/ius-release.rpm;;
    7*) sudo yum -y install https://rhel7.iuscommunity.org/ius-release.rpm;;
  esac
  import_ius_key
}

import_ius_key(){
  sudo rpm --import /etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY
}

ius_install(){
  if [[ -e /etc/redhat-release ]]; then
    RELEASE_RPM=$(rpm -qf /etc/redhat-release)
    RELEASE=$(rpm -q --qf '%{VERSION}' ${RELEASE_RPM})
    case ${RELEASE_RPM} in
      centos*)
        echo "detected CentOS ${RELEASE}"
        centos_install_epel
        centos_install_ius
        ;;
      redhat*)
        echo "detected RHEL ${RELEASE}"
        rhel_install_epel
        rhel_install_ius
        ;;
      *)
        echo "unknown EL clone"
        exit 1
        ;;
    esac

  else
    echo "not an EL distro"
    exit 1
  fi

  echo "IUS Done"
}

# PACKAGE INSTALLATION
#
# Build a bash array to pass all of the packages we want to install to a single
# apt-get command. This avoids doing all the leg work each time a package is
# set to install. It also allows us to easily comment out or add single
# packages. We set the array as empty to begin with so that we can append
# individual packages to it as required.
yum_package_install_list=()

# Start with a bash array containing all packages we want to install in the
# virtual machine. We'll then loop through each of these and check individual
# status before adding them to the yum_package_install_list array.
yum_package_check_list=(

  # PHP5
  #
  # Our base packages for php5. As long as php5-fpm and php5-cli are
  # installed, there is no need to install the general php5 package, which
  # can sometimes install apache as a requirement.
  php56u
  php56u-cli

  # Common and dev packages for php
  php56u-common
  php56u-devel

  # Extra PHP modules that we find useful
  php56u-pecl-apcu
  php56u-pecl-memcache
  php56u-pecl-imagick
  php56u-mcrypt
  php56u-mysqlnd
  php56u-mbstring
  php56u-imap
  php56u-pear
  php56u-gd
  php56u-pecl-mongo
  php56u-pecl-jsonc
  php56u-pecl-gearman
  php56u-xmlrpc
  php56u-xml
  php56u-pecl-geoip
  php56u-intl
  php56u-pspell

  # apache2 is installed as the default web server
  httpd
  mod_ssl

  # mysql is the default database
  mariadb101u
  mariadb101u-server
#  mongodb

  # other packages that come in handy
  ImageMagick
  subversion
  git
  zip
  unzip
  ngrep
  curl
  make
  vim-enhanced
  colordiff
  postfix
  wget
  nc

  # ntp service to keep clock current
  ntp
  htop
  sysstat
  dstat
  iotop
  python-pip
#  python-apt
  screen

  # Req'd for i18n tools
  gettext

  # Req'd for Webgrind
  graphviz

  # dos2unix
  # Allows conversion of DOS style line endings to something we'll have less
  # trouble with in Linux.
  dos2unix

  # nodejs for use by grunt
#  g++
  nodejs
  npm

  #Mailcatcher requirement
  sqlite-devel
)

### FUNCTIONS

portscan() {
  tput setaf 6; echo "Starting port scan of $checkdomain port 80"; tput sgr0;
  if nc -zw1 $checkdomain  80; then
    tput setaf 2; echo "Port scan good, $checkdomain port 80 available"; tput sgr0;
  else
    echo "Port scan of $checkdomain port 80 failed."
  fi
}

pingnet() {
  #Google has the most reliable host name. Feel free to change it.
  tput setaf 6; echo "Pinging $checkdomain to check for internet connection." && echo; tput sgr0;
  ping $checkdomain -c 4

  if [ $? -eq 0 ]
    then
      tput setaf 2; echo && echo "$checkdomain pingable. Internet connection is most probably available."&& echo ; tput sgr0;
      #Insert any command you like here
    else
      echo && echo "Could not establish internet connection. Something may be wrong here." >&2
      #Insert any command you like here
#      exit 1
  fi
}

pingdns() {
  #Grab first DNS server from /etc/resolv.conf
  tput setaf 6; echo "Pinging first DNS server in resolv.conf ($checkdns) to check name resolution" && echo; tput sgr0;
  ping $checkdns -c 4
    if [ $? -eq 0 ]
    then
      tput setaf 6; echo && echo "$checkdns pingable. Proceeding with domain check."; tput sgr0;
      #Insert any command you like here
    else
      echo && echo "Could not establish internet connection to DNS. Something may be wrong here." >&2
      #Insert any command you like here
#     exit 1
  fi
}

httpreq() {
  tput setaf 6; echo && echo "Checking for HTTP Connectivity"; tput sgr0;
  case "$(curl -s --max-time 2 -I $checkdomain | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
  [23]) tput setaf 2; echo "HTTP connectivity is up"; tput sgr0;;
  5) echo "The web proxy won't let us through";exit 1;;
  *)echo "Something is wrong with HTTP connections. Go check it."; exit 1;;
  esac
#  exit 0
}

network_detection() {
  # Network Detection
  #
  # Make an HTTP request to google.com to determine if outside access is available
  GW=`/sbin/ip route | awk '/default/ { print $3 }'`
  checkdns=`cat /etc/resolv.conf | awk '/nameserver/ {print $2}' | awk 'NR == 1 {print; exit}'`
  checkdomain=google.com
  
  #Ping gateway first to verify connectivity with LAN
  tput setaf 6; echo "Pinging gateway ($GW) to check for LAN connectivity" && echo; tput sgr0;
  if [ "$GW" = "" ]; then
      tput setaf 1;echo "There is no gateway. Probably disconnected..."; tput sgr0;
  #    exit 1
  fi

  ping $GW -c 4

  if [ $? -eq 0 ]
  then
    tput setaf 6; echo && echo "LAN Gateway pingable. Proceeding with internet connectivity check."; tput sgr0;
    pingdns
    pingnet
    portscan
    httpreq
    
    ping_result="Connected"
  else
    echo && echo "Something is wrong with LAN (Gateway unreachable)"
    pingdns
    pingnet
    portscan
    httpreq

    #Insert any command you like here
    ping_result="Not Connected"
  fi
}

network_check() {
  network_detection
  if [[ ! "$ping_result" == "Connected" ]]; then
    echo -e "\nNo network connection available, skipping package installation"
    exit 0
  fi
}

noroot() {
  sudo -EH -u "dhc-user" "$@";
}

package_check() {
  # Loop through each of our packages that should be installed on the system. If
  # not yet installed, it should be added to the array of packages to install.
  local pkg
  local package_version

  for pkg in "${yum_package_check_list[@]}"; do
    package_version=$(rpm -qa --qf "%{VERSION}-%{RELEASE}" "${pkg}" 2>&1)
    if [[ -n "${package_version}" ]]; then
      space_count="$(expr 20 - "${#pkg}")" #11
      pack_space_count="$(expr 30 - "${#package_version}")"
      real_space="$(expr ${space_count} + ${pack_space_count} + ${#package_version})"
      printf " * $pkg %${real_space}.${#package_version}s ${package_version}\n"
    else
      echo " *" $pkg [not installed]
      yum_package_install_list+=($pkg)
    fi
  done
}

package_replace() {
  echo "Installing yum-plugin-replace..."
  sudo yum install -y yum-plugin-replace

  #MariaDB conflict with postfix mariadb-libs
  echo "Running yum replace mariadb-libs --replace-with mariadb101u-libs..."
  sudo yum replace -y mariadb-libs --replace-with mariadb101u-libs
}

package_install() {
  package_check

  # Provide our custom apt sources before running `apt-get update`
  sudo ln -sf /tmp/provision/config/yum-additional.repo /etc/yum.repos.d/vvv.repo
  echo "Linked custom repos"

  if [[ ${#yum_package_install_list[@]} = 0 ]]; then
    echo -e "No yum packages to install.\n"
  else
    # Update all of the package references before installing anything
    echo "Running yum update..."
    sudo yum update -y

    package_replace

    # Install required packages
    echo "Installing yum packages..."
    sudo yum install -y ${yum_package_install_list[@]}

    # Clean up yum caches
    sudo yum clean all
  fi
}

tools_install() {
  # npm
  #
  # Make sure we have the latest npm version and the update checker module
  sudo npm install -g npm
  sudo npm install -g npm-check-updates

  # ack-grep
  #
  # Install ack-rep directory from the version hosted at beyondgrep.com as the
  # PPAs for Ubuntu Precise are not available yet.
  if [[ -f /usr/bin/ack ]]; then
    echo "ack-grep already installed"
  else
    echo "Installing ack-grep as ack"
    sudo curl -s http://beyondgrep.com/ack-2.14-single-file > "/usr/bin/ack" && chmod +x "/usr/bin/ack"
  fi

  # COMPOSER
  #
  # Install Composer if it is not yet available.
  if [[ ! -n "$(composer --version --no-ansi | grep 'Composer version')" ]]; then
    echo "Installing Composer..."
    sudo curl -sS "https://getcomposer.org/installer" | php
    sudo chmod +x "composer.phar"
    sudo mv "composer.phar" "/usr/local/bin/composer"
  fi

  #if [[ -f /vagrant/provision/github.token ]]; then
  #  ghtoken=`cat /vagrant/provision/github.token`
  #  sudo composer config --global github-oauth.github.com $ghtoken
  #  echo "Your personal GitHub token is set for Composer."
  #fi

  # Update both Composer and any global packages. Updates to Composer are direct from
  # the master branch on its GitHub repository.
  if [[ -n "$(composer --version --no-ansi | grep 'Composer version')" ]]; then
    echo "Updating Composer..."
    COMPOSER_HOME=/usr/local/src/composer sudo composer self-update
    COMPOSER_HOME=/usr/local/src/composer sudo composer -q global require --no-update phpunit/phpunit:4.3.*
    COMPOSER_HOME=/usr/local/src/composer sudo composer -q global require --no-update phpunit/php-invoker:1.1.*
    COMPOSER_HOME=/usr/local/src/composer sudo composer -q global require --no-update mockery/mockery:0.9.*
    COMPOSER_HOME=/usr/local/src/composer sudo composer -q global require --no-update d11wtq/boris:v1.0.8
    COMPOSER_HOME=/usr/local/src/composer sudo composer -q global config bin-dir /usr/local/bin
    COMPOSER_HOME=/usr/local/src/composer sudo composer global update
  fi

  # Grunt
  #
  # Install or Update Grunt based on current state.  Updates are direct
  # from NPM
  #if [[ "$(grunt --version)" ]]; then
  #  echo "Updating Grunt CLI"
  #  npm update -g grunt-cli &>/dev/null
  #  npm update -g grunt-sass &>/dev/null
  #  npm update -g grunt-cssjanus &>/dev/null
  #  npm update -g grunt-rtlcss &>/dev/null
  #else
  #  echo "Installing Grunt CLI"
  #  npm install -g grunt-cli &>/dev/null
  #  npm install -g grunt-sass &>/dev/null
  #  npm install -g grunt-cssjanus &>/dev/null
  #  npm install -g grunt-rtlcss &>/dev/null
  #fi

  # Graphviz
  #
  # Set up a symlink between the Graphviz path defined in the default Webgrind
  # config and actual path.
  echo "Adding graphviz symlink for Webgrind..."
  ln -sf "/usr/bin/dot" "/usr/local/bin/dot"
}

nginx_setup() {
  # Create an SSL key and certificate for HTTPS support.
  if [[ ! -e /etc/nginx/server.key ]]; then
    echo "Generate Nginx server private key..."
    vvvgenrsa="$(openssl genrsa -out /etc/nginx/server.key 2048 2>&1)"
    echo "$vvvgenrsa"
  fi
  if [[ ! -e /etc/nginx/server.crt ]]; then
    echo "Sign the certificate using the above private key..."
    vvvsigncert="$(openssl req -new -x509 \
            -key /etc/nginx/server.key \
            -out /etc/nginx/server.crt \
            -days 3650 \
            -subj /CN=*.galleonph.dev/CN=*.galleonph.dashboard/CN=*.vvv.dev 2>&1)"
    echo "$vvvsigncert"
  fi

  echo -e "\nSetup configuration files..."

  # Used to ensure proper services are started on `vagrant up`
  sudo cp "/tmp/provision/config/init/vvv-start.conf" "/etc/init/vvv-start.conf"
  echo " * Copied /tmp/provision/config/init/vvv-start.conf               to /etc/init/vvv-start.conf"

  # Copy nginx configuration from local
  sudo cp "/tmp/provision/config/nginx-config/nginx.conf" "/etc/nginx/nginx.conf"
  sudo cp "/tmp/provision/config/nginx-config/nginx-wp-common.conf" "/etc/nginx/nginx-wp-common.conf"
  if [[ ! -d "/etc/nginx/custom-sites" ]]; then
    sudo mkdir -p "/etc/nginx/custom-sites/"
  fi
  sudo rsync -rvzh --delete "/tmp/provision/config/nginx-config/sites/" "/etc/nginx/custom-sites/"

  echo " * Copied /tmp/provision/config/nginx-config/nginx.conf           to /etc/nginx/nginx.conf"
  echo " * Copied /tmp/provision/config/nginx-config/nginx-wp-common.conf to /etc/nginx/nginx-wp-common.conf"
  echo " * Rsync'd /tmp/provision/config/nginx-config/sites/              to /etc/nginx/custom-sites"
}

phpfpm_setup() {
  # Copy php-fpm configuration from local
  sudo cp "/tmp/provision/config/php5-fpm-config/php5-fpm.conf" "/etc/php5/fpm/php5-fpm.conf"
  sudo cp "/tmp/provision/config/php5-fpm-config/www.conf" "/etc/php5/fpm/pool.d/www.conf"
  sudo cp "/tmp/provision/config/php5-fpm-config/php-custom.ini" "/etc/php5/fpm/conf.d/php-custom.ini"
  sudo cp "/tmp/provision/config/php5-fpm-config/opcache.ini" "/etc/php5/fpm/conf.d/opcache.ini"
  sudo cp "/tmp/provision/config/php5-fpm-config/xdebug.ini" "/etc/php.d/xdebug.ini"

  # Find the path to Xdebug and prepend it to xdebug.ini
  XDEBUG_PATH=$( find /usr -name 'xdebug.so' | head -1 )
  sudo sed -i "1izend_extension=\"$XDEBUG_PATH\"" "/etc/php.d/xdebug.ini"

  echo " * Copied /tmp/provision/config/php5-fpm-config/php5-fpm.conf     to /etc/php5/fpm/php5-fpm.conf"
  echo " * Copied /tmp/provision/config/php5-fpm-config/www.conf          to /etc/php5/fpm/pool.d/www.conf"
  echo " * Copied /tmp/provision/config/php5-fpm-config/php-custom.ini    to /etc/php5/fpm/conf.d/php-custom.ini"
  echo " * Copied /tmp/provision/config/php5-fpm-config/opcache.ini       to /etc/php5/fpm/conf.d/opcache.ini"
  echo " * Copied /tmp/provision/config/php5-fpm-config/xdebug.ini        to /etc/php.d/xdebug.ini"

  # Copy memcached configuration from local
  sudo cp "/tmp/provision/config/memcached-config/memcached.conf" "/etc/memcached.conf"

  echo " * Copied /tmp/provision/config/memcached-config/memcached.conf   to /etc/memcached.conf"
}

apache_setup() {
  # Create an SSL key and certificate for HTTPS support.
  if [[ ! -e /etc/pki/tls/private/server.key ]]; then
    echo "Generate Apache server private key..."
    vvvgenrsa="$(sudo openssl genrsa -out /etc/pki/tls/private/server.key 2048 2>&1)"
    echo "$vvvgenrsa"
  fi
  if [[ ! -e /etc/pki/tls/certs/server.crt ]]; then
    echo "Sign the certificate using the above private key..."
    vvvsigncert="$(sudo openssl req -new -x509 \
            -key /etc/pki/tls/private/server.key \
            -out /etc/pki/tls/certs/server.crt \
            -days 3650 \
            -subj /CN=*.galleonph.dev/CN=*.galleonph.dashboard/CN=*.vvv.dev 2>&1)"
    echo "$vvvsigncert"
  fi

  echo -e "\nSetup configuration files..."

  # Copy apache configuration from local
  sudo cp "/tmp/provision/config/apache-config/httpd.conf" "/etc/httpd/conf/httpd.conf"
  if [[ ! -d "/etc/httpd/conf/sites-available" ]]; then
    sudo mkdir -p "/etc/httpd/conf/sites-available/"
  fi
  sudo rsync -rvzh --delete "/tmp/provision/config/apache-config/sites-available/" "/etc/httpd/conf/sites-available/"
  sudo mkdir -p "/etc/httpd/conf/sites-enabled/"
  sudo ln -s /etc/httpd/conf/sites-available/* "/etc/httpd/conf/sites-enabled/"

  echo " * Copied /tmp/provision/config/apache-config/httpd.conf           to /etc/httpd/conf/httpd.conf"
  echo " * Rsync'd /tmp/provision/config/apache-config/sites-available/      to /etc/httpd/sites-available"
  echo " * Linked /etc/httpd/sites-available        to /etc/httpd/sites-enabled"
}

phpmod_setup() {
  # Copy php-fpm configuration from local
  sudo cp "/tmp/provision/config/php5-config/php5.conf" "/etc/httpd/conf.d/php5.conf"
  sudo cp "/tmp/provision/config/php5-config/php-custom.ini" "/etc/php.d/php-custom.ini"
  sudo cp "/tmp/provision/config/php5-config/opcache.ini" "/etc/php.d/opcache.ini"
  
  echo " * Copied /tmp/provision/config/php5-config/php5.conf         to /etc/httpd/conf.d/php5.conf"
  echo " * Copied /tmp/provision/config/php5-config/php-custom.ini    to /etc/php.d/php-custom.ini"
  echo " * Copied /tmp/provision/config/php5-config/opcache.ini       to /etc/php.d/opcache.ini"
}

mysql_setup() {
  # If MySQL is installed, go through the various imports and service tasks.
  
  if type mysql >/dev/null 2>&1; then
    echo " * Copy /tmp/provision/config/mysql-config/my.cnf /etc/my.cnf"
    sudo cp /tmp/provision/config/mysql-config/my.cnf /etc/my.cnf
    
    echo "systemctl enable mariadb.service"
    sudo systemctl enable mariadb.service

    echo "systemctl restart mariadb.service"
    sudo systemctl restart mariadb.service

    # commands from mysql_secure_installation
    echo "running commands from mysql_secure_installation..."
    sudo mysql -u root << EOF
UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

    # IMPORT SQL
    #
    # Create the databases (unique to system) that will be imported with
    # the mysqldump files located in database/backups/
    if [[ -f "/tmp/provision/database/init-custom.sql" ]]; then
      sudo mysql -u "root" -p"root" < "/tmp/provision/database/init-custom.sql"
      echo -e "\nInitial custom MySQL scripting..."
    else
      echo -e "\nNo custom MySQL scripting found in database/init-custom.sql, skipping..."
    fi

    # Setup MySQL by importing an init file that creates necessary
    # users and databases that our vagrant setup relies on.
    if [[ -f "/tmp/provision/database/init.sql" ]]; then
      sudo mysql -u "root" -p"root" < "/tmp/provision/database/init.sql"
      echo "Initial MySQL prep..."
    fi

    # Process each mysqldump SQL file in database/backups to import
    # an initial data set for MySQL.
    if [[ -f "/tmp/provision/database/import-sql.sh" ]]; then
      sudo chmod +x "/tmp/provision/database/import-sql.sh"
      sudo "/tmp/provision/database/import-sql.sh"
    fi
  else
    echo -e "\nMySQL is not installed. No databases imported."
  fi
}

mongo_setup() {
  # If MySQL is installed, go through the various imports and service tasks.
  local exists_mongo

  exists_mongo="$(systemctl status mongodb)"
  if [[ "mongodb: unrecognized service" != "${exists_mongo}" ]]; then
    echo -e "\nSetup MongoDB configuration file links..."

    # Copy mysql configuration from local
    #sudo cp "/tmp/provision/config/mongo-config/my.cnf" "/etc/mysql/my.cnf"
    #sudo cp "/tmp/provision/config/mongo-config/root-my.cnf" "~/.my.cnf"

    #echo " * Copied /tmp/provision/config/mysql-config/my.cnf               to /etc/mysql/my.cnf"
    #echo " * Copied /tmp/provision/config/mysql-config/root-my.cnf          to /home/vagrant/.my.cnf"

    echo "systemctl restart mongodb"
    sudo systemctl restart mongodb

    # Process each mysqldump SQL file in database/backups to import
    # an initial data set for MySQL.
    "/tmp/provision/database/import-mongo.sh"
  else
    echo -e "\nMongoDB is not installed. No databases imported."
  fi
}

solr_setup() {
  # Download and extract solr 4.8.0
  if [[ ! -d "/opt/solr" ]]; then
    echo -e "\nDownloading Apache Solr, see http://lucene.apache.org/solr/"
    cd ~
    sudo wget -q -O solr.tgz https://archive.apache.org/dist/lucene/solr/4.8.0/solr-4.8.0.tgz
    sudo tar -xf solr.tgz -C /opt/
    
    echo -e "\nCopying example solr"
    sudo cp -R /opt/solr-4.8.0/example /opt/solr

  else
    echo "Solr already installed."
  fi

  echo -e "\nSetup configuration files..."

  echo " * Copy /tmp/provision/config/solr-config/init.d/solr /etc/init.d/solr"
  sudo cp /tmp/provision/config/solr-config/init.d/solr /etc/init.d/solr

  sudo chmod +x /etc/init.d/solr
  sudo chkconfig --add solr
  sudo service solr restart
}

services_restart() {
  # RESTART SERVICES
  #
  # Make sure the services we expect to be running are running.
  echo -e "\nRestart services..."
  #sudo systemctl restart memcached
  sudo systemctl restart httpd.service
}

opcached_status(){
  # Checkout Opcache Status to provide a dashboard for viewing statistics
  # about PHP's built in opcache.
  if [[ ! -d "/var/www/html/opcache-status" ]]; then
    echo -e "\nDownloading Opcache Status, see https://github.com/rlerdorf/opcache-status/"
    cd /var/www/html
    sudo git clone -q "https://github.com/rlerdorf/opcache-status.git" opcache-status
  else
    echo -e "\nUpdating Opcache Status"
    cd /var/www/html/opcache-status
    sudo git pull --rebase origin master
  fi
}

phpmyadmin_setup() {
  # Download phpMyAdmin
  if [[ ! -d /var/www/html/phpm ]]; then
    echo "Downloading phpMyAdmin..."
    cd /var/www/html
    sudo wget -q -O phpmyadmin.tar.gz "https://files.phpmyadmin.net/phpMyAdmin/4.4.10/phpMyAdmin-4.4.10-all-languages.tar.gz"
    sudo tar -xzf phpmyadmin.tar.gz
    sudo mv phpMyAdmin-4.4.10-all-languages phpm
    sudo rm phpmyadmin.tar.gz
  else
    echo "PHPMyAdmin already installed."
  fi
  sudo cp "/tmp/provision/config/phpmyadmin-config/config.inc.php" "/var/www/html/phpm/"
}

java_setup() {
  #Setup default java
  if [[ ! -d "/usr/java" ]]; then
    echo "Linking Java to default location."
    sudo mkdir /usr/java
    sudo ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/java/default
  else
    echo "Java already installed."
  fi
}

### SCRIPT
#set -xv

# Network check
network_check

# Package and Tools Install
echo " "
ius_install
echo " "
echo "Main packages check and install."
package_install
tools_install
apache_setup
phpmod_setup
mysql_setup
#mongo_setup
java_setup
solr_setup

services_restart

network_check
# Debugging tools
echo " "
echo "Installing/updating debugging tools"
opcached_status
phpmyadmin_setup

#set +xv
# And it's done
end_seconds="$(date +%s)"
echo "-----------------------------"
echo "Provisioning complete in "$((${end_seconds} - ${start_seconds}))" seconds"
