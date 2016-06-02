sudo apt-get install -y apache2  php5 php5-mysql php5-curl
sudo a2enmod rewrite
sudo apt-get install php5-mcrypt
php5enmod mcrypt
sudo apt-get install php-pear libyaml-dev
sudo apt-get install php5-dev
pecl install yaml
sudo bash -c 'cat > /etc/apache2/sites-enabled/000-default.conf <<APACHE
<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www
  <Directory />
    Options FollowSymLinks
    AllowOverride None
  </Directory>
  <Directory /var/www/>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    Order allow,deny
    allow from all
  </Directory>
  ErrorLog \${APACHE_LOG_DIR}/error.log
  CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
APACHE'
#sudo usermod -G www-data ubuntu
chown -R ubuntu .
cd /var/www
echo pwd
find . -type f -exec chmod 400 {} \;
find . -type d -exec chmod 500 {} \; 
find var/ -type f -exec chmod 600 {} \; 
find media/ -type f -exec chmod 600 {} \;
find var/ -type d -exec chmod 700 {} \; 
find media/ -type d -exec chmod 700 {} \;
chmod 700 includes
chmod 600 includes/config.php
pecl install redis
echo "extension=redis.so" > /etc/php5/mods-available/redis.ini
php5enmod redis
service apache2 restart
bash < <(wget -q --no-check-certificate -O - https://raw.github.com/colinmollenhour/modman/master/modman-installer)
cd /var/www            # Magento is installed here
modman init            # This is only done once in the application root
modman clone git@example.com:foo/mymodule.git
