#!/bin/bash

#curl -o wordpresspete_linux_installer.sh -L https://www.wordpresspete.com/wordpresspete_linux_installer.sh && chmod 755 wordpresspete_linux_installer.sh &&  ./wordpresspete_linux_installer.sh

if [ -f /etc/debian_version ]; then

#PHP Libraries
sudo apt-get --assume-yes install software-properties-common
sudo apt-get --assume-yes install software-properties-common python-software-properties
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
apt update

echo "##############################################################"
echo "##############################################################"
echo "######## WELCOME TO THE WORDPRESSPETE INSTALLER ##############"
echo "##############################################################"
echo "##############################################################"

read -p "Enter DATABASE ROOT PASSWORD: " dbpassword
dbpassword=${dbpassword:-testing123}

PS3='Enter the PHP version you want to install: '
options=("php5.6" "php7.0" "php7.1" "php7.2" "Quit")
select opt in "${options[@]}"
do
    case $opt in
 		"php5.6")
    		echo "you chose choice 1"
			sudo apt-get --assume-yes install php5.6 php5.6-common
			sudo apt-get --assume-yes install php5.6-curl php5.6-xml php5.6-zip php5.6-gd php5.6-mysql php5.6-mbstring
			sudo a2dismod php7.2
			sudo a2enmod php5.6
			ln -sfn /usr/bin/php5.6 /etc/alternatives/php
    		break
    		;;
    	"php7.0")
			echo "you chose choice 2"
			sudo apt-get --assume-yes install php7.0 php7.0-common
			sudo apt-get --assume-yes install php7.0-curl php7.0-xml php7.0-zip php7.0-gd php7.0-mysql php7.0-mbstring
			sudo a2dismod php7.2
			sudo a2enmod php7.0
			ln -sfn /usr/bin/php7.0 /etc/alternatives/php
       	 	echo "you chose choice 2"
       	 	break
        ;;
        "php7.1")
			echo "you chose choice 3"
			sudo apt-get --assume-yes install php7.1 php7.1-common
			sudo apt-get --assume-yes install php7.1-curl php7.1-xml php7.1-zip php7.1-gd php7.1-mysql php7.1-mbstring
			sudo a2dismod php7.2
			sudo a2enmod php7.1
			ln -sfn /usr/bin/php7.1 /etc/alternatives/php
            echo "you chose choice 2"
            break
            ;;
        "php7.2")
            echo "you chose choice 3"
			sudo apt-get --assume-yes install php7.2 php7.2-common
			sudo apt-get --assume-yes install php7.2-curl php7.2-xml php7.2-zip php7.2-gd php7.2-mysql php7.2-mbstring
			sudo a2enmod php7.2
			ln -sfn /usr/bin/php7.2 /etc/alternatives/php
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

sudo apt-get --assume-yes install zip
sudo apt-get --assume-yes install unzip
sudo a2enmod ssl
sudo service apache2 restart

password_user=$dbpassword
MYSQL=$dbpassword
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $password_user"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $password_user"
sudo apt-get -y install mysql-server

############################################
#Installing Pete

curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
mkdir /var/www
cd /var/www

#git clone -b v1.1 https://bitbucket.org/ozone777/petedeploy.git Pete
curl -o latest.zip -L https://wordpresspete.com/latest.zip
unzip -a latest.zip
mv latest Pete

chmod -R 755 Pete
cd /var/www/Pete
cp .env.example .env

composer install
php artisan key:generate

database_name=db_`openssl rand -hex 6`
password_user=`openssl rand -hex 10`
database_user=usr_`openssl rand -hex 4`
password_root=$MYSQL
mysql_bin=mysql

$mysql_bin --host=localhost -uroot -p$password_root -e "create database $database_name"
$mysql_bin --host=localhost -uroot -p$password_root -e "CREATE USER $database_user@localhost"
$mysql_bin --host=localhost -uroot -p$password_root -e "SET PASSWORD FOR $database_user@localhost = PASSWORD('$password_user')"
$mysql_bin --host=localhost -uroot -p$password_root -e "GRANT ALL PRIVILEGES ON $database_name.* TO $database_user@localhost IDENTIFIED BY '$password_user'"

#php artisan dbkeys --var=DB_DATABASE --key=$database_name
#php artisan dbkeys --var=DB_USERNAME --key=$database_user
#php artisan dbkeys --var=DB_PASSWORD --key=$password_user
#php artisan dbkeys --var=ROOT_PASS --key=$password_root

echo "DB_HOST=localhost
DB_DATABASE=$database_name
DB_USERNAME=$database_user
DB_PASSWORD=$password_user
ROOT_PASS=$password_root
" >> /var/www/Pete/.env

mkdir /var/www/Pete/public/uploads
mkdir /var/www/Pete/public/export
mkdir /var/www/Pete/trash
mkdir /var/www/Pete/storage
mkdir /var/www/Pete/storage/logs
touch /var/www/Pete/storage/logs/laravel.log
chmod 777 /var/www/Pete/storage/logs/laravel.log
chmod -R 777 /var/www/Pete/storage

php artisan migrate
php artisan optimize
php artisan cache:clear 
mkdir /var/www/Pete/app/storage
chmod -R 777 /var/www/Pete/app/storage 
composer dump-autoload

php artisan addoption --option_name=app_root --option_value=/var/www
php artisan addoption --option_name=os --option_value=olinux
php artisan addoption --option_name=os_version --option_value=ubuntu
php artisan addoption --option_name=server_conf --option_value=/etc/apache2/sites-available
php artisan addoption --option_name=server_version --option_value=24
php artisan addoption --option_name=version --option_value=1.1
php artisan addoption --option_name=server --option_value=apache
php artisan addoption --option_name=phpmyadmin --option_value=/phpmyadmin
php artisan addoption --option_name=validation_url --option_value=https://dashboard.wordpresspete.com

echo "
<VirtualHost *:80>

    ServerName localhost
    ServerAlias localhost
    DocumentRoot /var/www/Pete/public
    ErrorLog /var/www/Pete/error.log
    CustomLog /var/www/Pete/requests.log combined
    #SecRequestBodyAccess Off
      <Directory /var/www/Pete>
            AllowOverride All
        </Directory>

</VirtualHost>" > /etc/apache2/sites-available/AA.conf
sudo chown -R www-data:www-data /var/www/
chown -R www-data:www-data /etc/apache2/sites-enabled
chown -R www-data:www-data /etc/apache2/sites-available

rm -rf /etc/apache2/sites-enabled/000-default.conf 
rm -rf /etc/apache2/sites-available/000-default.conf
sudo a2ensite AA.conf
sudo a2enmod rewrite
echo "www-data ALL=NOPASSWD: /etc/init.d/apache2 reload" >> /etc/sudoers
sudo service apache2 restart
cd

ln -s /var/www sites
ln -s /etc/apache2/sites-available configs
ln -s /data/wwwlog logs

mkdir /data
mkdir /data/wwwlog
chown -R www-data:www-data /data/wwwlog

#PHPMYADMIN
debconf-set-selections <<< "phpmyadmin phpmyadmin/internal/skip-preseed boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean false"
apt-get -y install phpmyadmin
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin.conf
sudo service apache2 reload

else

	echo "Operating System not supported"
	
fi

