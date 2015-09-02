#!/usr/bin/env bash

echo "PLUSWERK: Update TYPO3"
cd /var/www/typo3 && git pull
composer update

service mysql start

echo "PLUSEWRK:   Set extensions active"
cd /var/www/typo3/
cp typo3conf/ext/typo3_console/Scripts/typo3cms .
chmod +x typo3cms

echo "PLUSEWRK: Run setup"
./typo3cms install:setup --nonInteractive=TRUE --databaseUserName=root --databaseHostName=localhost --databaseName=typo3 --databasePort=3306 --databaseCreate=1 --adminUserName=admin --adminPassword=Pluswerk1234! --siteName=testing
./typo3cms install:generatepackagestates
./typo3cms cache:flush
