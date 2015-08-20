FROM ubuntu:14.04
MAINTAINER Johannes Steu <js@johannessteu.de>

# Install dependecies
RUN apt-get update -y && apt-get install -y git-core nginx curl nano git php5-fpm php5-cli php5-mysql php5-intl php5-mcrypt php5-apcu php5-gd php5-curl php5-sqlite graphicsmagick mysql-client mysql-server
RUN curl -s https://getcomposer.org/installer | php &&  mv composer.phar /usr/local/bin/composer

# add files
ADD docker-files /

RUN mkdir -p /var/www

# install typo3
RUN cd /var/www && git clone https://git.typo3.org/Packages/TYPO3.CMS.git

RUN mv /var/www/TYPO3.CMS /var/www/typo3
RUN cd /var/www/typo3 && sed -i s/"\"authors\""/"\"repositories\": [{ \"type\": \"git\", \"url\": \"https:\/\/github.com\/helhum\/typo3_console.git\" }],\"authors\""/g composer.json
RUN cd /var/www/typo3 && composer require helhum/typo3-console 1.*
RUN cd /var/www/typo3 && composer update

RUN cd /var/www && git clone https://github.com/neos/neos-base-distribution.git
RUN mv /var/www/neos-base-distribution /var/www/neos
RUN cd /var/www/neos && composer install

# RUN Install script
ADD run.sh /run.sh
RUN chmod +x /run.sh

# CMD ["/run.sh"]
