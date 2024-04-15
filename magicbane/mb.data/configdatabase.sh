#!/bin/bash

service  mysql start

mysql -u root -e "SET GLOBAL log_bin_trust_function_creators = 1;"
mysql -u root -e "CREATE USER 'Ghodric'@'localhost' IDENTIFIED BY 'Admin';"
mysql -u root -e "CREATE DATABASE magicbane CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'Ghodric'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"
mysql -u root -e "SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));"

mysql -u root magicbane < /home/mbbox/magicbane/mb.data/magicbane.sql

