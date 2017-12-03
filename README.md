## Summary

A simple Dockerfile for apache 2.4 and php-fpm 7.0

- Based on ubuntu:16.04 for developer simplicity (not size)
- With apache 2.4 + php-7.0-fpm
- Custom apache 2.4, php and supervisord configurations
- Without a database

## Usage

### Variables

- $WWW_UID and $WWW_GID : Optional to change the UID/GID that nginx runs under to solve permission issues if you are mounting a directory from your host
- This is also designed to work with docker-sync as docker-sync native mac will break if the uid of sync_userid does not exist within the container

### Running

Pull from docker hub and run:

```
docker pull opendatastack/apache-php-fpm;
docker run \
-p 8787:80 \
--name apache-php-fpm opendatastack/apache-php-fpm;
```

## Development & Test Cycle

Download: 

```
git clone git@github.com:OpenDataStack/docker-apache-php-fpm.git && cd docker-apache-php-fpm
```

Change:

```
docker rm apache-php-fpm;
docker build -t apache-php-fpm .;
docker run \
-p 8787:80 \
--name apache-php-fpm apache-php-fpm:latest;
```

Test:

```
docker rm apache-php-fpm;
docker build -t apache-php-fpm .;
docker run \
-p 8787:80 \
-v "$(pwd)"/src/test:/var/www/html \
--name apache-php-fpm apache-php-fpm:latest;
```

Commit and push:

```
docker login
docker tag apache-php-fpm opendatastack/apache-php-fpm
docker push opendatastack/apache-php-fpm
```

### Debugging

Login:

```
docker exec -it apache-php-fpm /bin/bash
```

Copy files from the container:

```
docker cp apache-php-fpm:/etc/php/7.0/fpm/php.ini /PATH/TO/FILE
```
