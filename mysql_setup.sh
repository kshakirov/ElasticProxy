#sudo apt-get install  mysql-server-5.6
mysql -u root -pservantes -e "CREATE DATABASE IF NOT EXISTS magento;"
mysql -u root -pservantes -e "GRANT ALL PRIVILEGES ON magento.* TO magento@'magento' IDENTIFIED BY 'magento'; FLUSH PRIVILEGES;"
