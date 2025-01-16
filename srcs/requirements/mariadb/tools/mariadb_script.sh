#!/bin/sh

# Socket directory
if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

# Set correct permissions for MariaDB data directory
chown -R mysql:mysql /var/lib/mysql

# Initialize the MariaDB data directory if it hasn't been initialized yet
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysqld --initialize-insecure --user=mysql
    chown -R mysql:mysql /var/lib/mysql
fi

# Start the MariaDB server in the background to run the initial setup
mysqld_safe --user=mysql &

# Wait for MariaDB to start
sleep 5

# Database and user setup if necessary
if [ $(mysql -u root -e "FLUSH PRIVILEGES;" > /dev/null 2>&1; echo $?) = 0 ]; then
    # Create the database if it doesn't exist
    mysql -e "CREATE DATABASE IF NOT EXISTS ${SQL_DB_NAME};"
    # Create the user with the specified password and grant privileges
    mysql -e "CREATE USER IF NOT EXISTS '${SQL_USER_NAME}'@'%' IDENTIFIED BY '${SQL_USER_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${SQL_DB_NAME}.* TO '${SQL_USER_NAME}'@'%';"
    # Set the root password for secure access
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
    # Apply changes
    mysql -u root --password=${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
fi

# Stop the background mysqld process
mysqladmin -u root --password=${SQL_ROOT_PASSWORD} shutdown

# Start MariaDB in the foreground to keep the container running
exec mysqld_safe --user=mysql

