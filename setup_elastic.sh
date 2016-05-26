sudo apt-get install openjdk-7-jre
sudo apt-get install  wget
#wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.3.2/elasticsearch-2.3.2.deb
#sudo dpkg -i elasticsearch-2.3.2.deb
cd /usr/share && sudo elasticsearch/bin/plugin install mobz/elasticsearch-head
