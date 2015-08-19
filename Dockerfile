FROM ubuntu:14.04
MAINTAINER Johannes Steu <js@johannessteu.de>

# Install dependecies
RUN apt-get update -y && apt-get install -y git-core nginx curl nano git php5-fpm php5-cli php5-mysql php5-intl php5-mcrypt php5-apcu php5-gd php5-curl php5-sqlite graphicsmagick mysql-client mysql-server
RUN curl -s https://getcomposer.org/installer | php &&  mv composer.phar /usr/local/bin/composer

# add files
ADD docker-files /

RUN mkdir -p /var/www

# install typo3
RUN cd /var/www && git clone https://github.com/TYPO3/TYPO3.CMS.git

RUN mv /var/www/TYPO3.CMS /var/www/html
RUN cd /var/www/html && sed -i s/"\"authors\""/"\"repositories\": [{ \"type\": \"git\", \"url\": \"https:\/\/github.com\/helhum\/typo3_console.git\" }],\"authors\""/g composer.json
RUN cd /var/www/html && composer require helhum/typo3-console 1.*
RUN cd /var/www/html && composer update

# RUN Install script
ADD run.sh /run.sh
RUN chmod +x /run.sh

# CMD ["/run.sh"]
