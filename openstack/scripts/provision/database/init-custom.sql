# In order for that to respond properly, default databases should be
# available for use.
CREATE DATABASE IF NOT EXISTS `galleonph`;
GRANT ALL PRIVILEGES ON `galleonph`.* TO 'galleonph'@'localhost' IDENTIFIED BY 'galleonph';
