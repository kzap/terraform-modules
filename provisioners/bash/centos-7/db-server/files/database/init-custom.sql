# In order for that to respond properly, default databases should be
# available for use.
CREATE DATABASE IF NOT EXISTS `my_database`;
GRANT ALL PRIVILEGES ON `my_user`.* TO 'my_database'@'localhost' IDENTIFIED BY 'my_password';
