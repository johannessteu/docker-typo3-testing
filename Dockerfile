FROM ubuntu:14.04
MAINTAINER Johannes Steu <js@johannessteu.de>

USER root

# Install dependecies
RUN apt-get update -y && apt-get install -y git-core nginx curl nano git php5-fpm php5-cli php5-mysql php5-intl php5-mcrypt php5-apcu php5-gd php5-curl php5-sqlite graphicsmagick mysql-client mysql-server php5-ldap
RUN curl -s https://getcomposer.org/installer | php &&  mv composer.phar /usr/local/bin/composer

# add files
ADD docker-files /

RUN mkdir -p /var/www

# install typo3
RUN cd /var/www && git clone http://git.typo3.org/Packages/TYPO3.CMS.git

RUN cp -R /var/www/TYPO3.CMS /var/www/typo3_7-4
RUN cp -R /var/www/TYPO3.CMS /var/www/typo3_7-3
RUN cp -R /var/www/TYPO3.CMS /var/www/typo3_7-0
RUN cp -R /var/www/TYPO3.CMS /var/www/typo3_master

RUN cd /var/www/typo3_master && sed -i s/"\"authors\""/"\"repositories\": [{\"type\": \"composer\", \"url\": \"http:\/\/composer.typo3.org\"},{\"type\": \"git\", \"url\": \"https:\/\/github.com\/helhum\/typo3_console.git\"}],\"authors\""/g composer.json
RUN cd /var/www/typo3_master && composer require helhum/typo3-console 1.*
RUN cd /var/www/typo3_master && composer update

RUN cd /var/www/typo3_7-3 && git checkout TYPO3_7-3
RUN cd /var/www/typo3_7-3 && sed -i s/"\"authors\""/"\"repositories\": [{\"type\": \"composer\", \"url\": \"http:\/\/composer.typo3.org\"},{ \"type\": \"git\", \"url\": \"https:\/\/github.com\/helhum\/typo3_console.git\" }],\"authors\""/g composer.json
RUN cd /var/www/typo3_7-3 && composer require helhum/typo3-console 1.*
RUN cd /var/www/typo3_7-3 && composer update

RUN cd /var/www/typo3_7-4 && git checkout TYPO3_7-4-0
RUN cd /var/www/typo3_7-4 && sed -i s/"\"authors\""/"\"repositories\": [{\"type\": \"composer\", \"url\": \"http:\/\/composer.typo3.org\"},{ \"type\": \"git\", \"url\": \"https:\/\/github.com\/helhum\/typo3_console.git\" }],\"authors\""/g composer.json
RUN cd /var/www/typo3_7-4 && composer require helhum/typo3-console 1.*
RUN cd /var/www/typo3_7-4 && composer update

RUN cd /var/www/typo3_7-0 && git checkout TYPO3_7-0
RUN cd /var/www/typo3_7-0 && sed -i s/"\"authors\""/"\"repositories\": [{\"type\": \"composer\", \"url\": \"http:\/\/composer.typo3.org\"},{ \"type\": \"git\", \"url\": \"https:\/\/github.com\/helhum\/typo3_console.git\" }],\"authors\""/g composer.json
RUN cd /var/www/typo3_7-0 && composer require helhum/typo3-console 1.*
RUN cd /var/www/typo3_7-0 && composer update

RUN cd /var/www && git clone https://github.com/neos/neos-base-distribution.git
RUN mv /var/www/neos-base-distribution /var/www/neos
RUN cd /var/www/neos && composer install

