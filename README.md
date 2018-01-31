# Docker development stack for PHP projects using Nginx, PHP-FPM and MySQL

This stack is super-easy to setup, and it could replace entirely your local typical LAMP setup, or work in parallel on alternative ports.

Current component list:

1. nginx HTTP server
2. Varnish server
3. PHP-FPM 5 & 7
4. MySQL
5. Mailtrap to debug emails
6. Apache Tomcat 7 to integrate with J2EE apps
7. Apache Solr 6 full-text search engine

Benefits:

1. Have as many version of PHP as you need, by default is shipping with PHP 5.6 and PHP 7.1 (or 7.2 on separate branch)
2. Switch your project between PHP 5.x and 7.x editing a single line of configuration file
3. Create an environment similar to production _(Varnish, Memcached support is coming in the near future)_
2. Uses local `mailtrap` SMTP docker container to intercept emails (you don't have to send real mails to real servers for testing)

# How to use it

## Prerequisites

1. Have `Docker` installed, the daemon started and able to run container (permission to access the Docker daemon socket)
2. (Optional) `root` access to run on ports < 1024

*Caveats:*
- This setup was tested on Fedora 26/27. If you wonder wether it works on your box, read on and get your hands dirty.


### Step 1. Clone this repository

Use `git` to checkout this repository on your localcomputer and inside create a new `docker-compose.override.yml` file to customize your local setup to use your specific local paths and port preferences (read step 3 below). 

A typical file, setup with two PHP projects, one for PHP 5 and one for PHP 7 looks like this:

```yml

version: '2.0'

services:

  varnish4:
    ports:
    - "127.0.0.1:82:6081"
    volumes:
    - ./conf-varnish4/drupal8.vcl:/etc/varnish/conf.d/default.vcl

  nginx:
    ports:
    - "127.0.0.1:80:80"
    volumes:
    - ./conf-nginx/globals.conf:/etc/nginx/conf.d/globals.conf
    - ./conf-nginx/project1.conf:/etc/nginx/conf.d/project1.conf
    - ./conf-nginx/project2.conf:/etc/nginx/conf.d/project2.conf
    - /home/user/Work/project1:/var/www/html/project1
    - /home/user/Work/project2:/var/www/html/project2

  php71:
    volumes:
    - /home/user/Work/project1:/var/www/html/project1

  php56:
    volumes:
    - /home/user/Work/project2:/var/www/html/project2

  tomcat7:
    ports:
    - "127.0.0.1:8080:8080"
    volumes:
    - /home/user/Work/projectJava/target/service.war:/usr/local/tomcat/webapps/service.war

  db:
    ports:
    - "127.0.0.1:3306:3306"

  solr6:
    ports:
    - "127.0.0.1:8983:8983"

  mail:
    ports:
    - "127.0.0.1:25:25"
    - "127.0.0.1:81:80"

```


### Step 2. Configure your projects' local hostnames in /etc/hosts

If you wish to use local URLs for your projects, like http://my-best-project.local, open `/etc/hosts` and add lines for each project like this:

```
127.0.0.1	my-best-project.local
127.0.0.1	my-second-best-project.local
```

*Note:* On Windows open the file `C:\Windows\system32\drivers\etc\hosts` as `Administrator` in `Notepad` and edit it as above, but don't take my word for it.


### Step 3. Configure your projects

TODO - Add more details on how to configure paths in nginx, settings.php in Drupal etc.

1. Create the `nginx` .conf virtual host file for your project by using an existing sample one (i.e. copy `template-project.conf` to `project-NAME.conf`). Edit the file and configure proper fields (`root` directive etc.) and also route the requests to the appropriate `FPM` interpreter (`fastcgi_pass php71:9000;`).

2. Create the volume mappings between local host paths and container paths in the `docker.override.yml`, for example:

```yml
  nginx:
    volumes:
    - /home/user/Work/project1:/var/www/html/project1

  php71:
    volumes:
    - /home/user/Work/project2:/var/www/html/project2
```

**Important** The mappings must be done both in `nginx` and `php71` because `nginx` is going to serve the static files under the directory, while the `php71` container will execute the PHP scripts coming from nginx's FCGI request. Technically, nginx will path the absolute path to the PHP script thus is vital to have identical mappings inside both containers: (i.e. `/var/www/html/bioland`) and a correct `root /var/www/html/bioland;` set in `server` directive!

3. Database configuration. The hostname of MySQL server is `db` so in your Drupal, WordPress etc. system make sure you set the correct `hostname` for the MySQL connection string. Also the default MySQL user is `root` and password is `root`.


### Step 4. Start the stack

Use `docker-compose up` on your console and see what's happening. If you follow the configuration suggested above, you can:

1. Access your local projects at http://my-best-project.local
2. Access the local email (mailtrap) at http://localhost:81 (default config)


# Frequently Asked Questions

1. How do I switch my project between PHP 5.x and 7.x?

Edit the `nginx` virtual host .conf file and set the `fastcgi_pass` directive to the appropriate container (i.e. `php56`, `php71`, `php72`).

2. How to I use the Varnish cache?

In `docker-compose.override.yml` you can configure the Varnish 4.x container to listen on host port, like this:

Then requests are cached through the Vanrnish.

**NB**: The default varnish VLC is quite empty, and probably, does not properly work with any CMS system. If you wish to use another VCL file, just mount it from the `docker-compose.override.yml` as following:

```
  varnish4:
    ports:
    - "127.0.0.1:81:6081"
    volumes:
    - ./conf-varnish4/drupal8.vcl:/etc/varnish/conf.d/default.vcl

```

So you're accessing uncached website at http://myproject.local, and http://myproject.local:82 cached through Varnish, no changes required. How simple is that!

3. How do I configure Tomcat?

In the `docker-compose.override.yml` you configure the Tomcat container to add your custom applications

```
  tomcat7:
    ports:
    - "127.0.0.1:8080:8080"
    volumes:
    - /path/to/your/application.war:/usr/local/tomcat/webapps/application.war
```

4. Solr configuration

To create a core for Solr 6, **before starting the stack** to the following:

  - go to conf-solr/6/ and execute `sudo ./create-core.sh <template-name> <core-name>`, where `<template-name>` is one of the directory names beneath the `templates/` directory.

  NB: When the stack is started, you need to restart it to pick up the new core.

## Contribute

If you have issues, ideas add a ticket here - even better - make a pull request!

**Happy coding!**
