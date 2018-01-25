# Docker development stack for PHP projects using Nginx, PHP-FPM and MySQL

This Nginx/PHP/MySQL stack is super-easy to setup, and it could replace entirely your local typical LAMP setup, or work in parallel on alternative ports.

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

Use `git` to checkout this repository on your localcomputer and inside create a new `docker-compose.override.yml` file to customize your local setup to use your specific local paths and port preferences (read step 3 below). A typical file looks like this:

```yml

version: '2.0'

services:
  nginx:
    ports:
    - "127.0.0.1:80:80"
    volumes:
    - /home/cristiroma/Work/cbd/bioland:/var/www/html/bioland
    - /home/cristiroma/Work/eu-osha/ncw:/var/www/html/ncw

  php71:
    volumes:
    - /home/cristiroma/Work/cbd/bioland:/var/www/html/bioland

  php56:
    volumes:
    - /home/cristiroma/Work/eu-osha/ncw:/var/www/html/ncw

  db:
    ports:
    - "127.0.0.1:3306:3306"

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

### Step 2. Configure your projects

TODO - Add more details on how to configure paths in nginx, settings.php in Drupal etc.

1. Create the `Nginx` .conf virtual host file for your project by using an existing sample one. Inside make sure you use the proper path for `root` directive and also route the requests to the appropriate `FPM` interpreter (`fastcgi_pass php71:9000;`).

2. Create the volume mappings between local host paths and container paths in the `docker.override.yml`, for example:

```yml
  nginx:
    volumes:
    - /home/cristiroma/Work/cbd/bioland:/var/www/html/bioland

  php71:
    volumes:
    - /home/cristiroma/Work/cbd/bioland:/var/www/html/bioland
```

**Important** The mappings must be done both in `nginx` and `php71` because `nginx` is going to serve the static files under the directory, while the `php71` container will execute the PHP scripts coming from nginx's FCGI request. Technically, nginx will path the absolute path to the PHP script thus is vital to have identical mappings inside both containers: (i.e. `/var/www/html/bioland`) and a correct `root /var/www/html/bioland;` set in `server` directive!

3. Database configuration. The hostname of MySQL server is `db` so in your Drupal, WordPress etc. system make sure you set the correct `hostname` for the MySQL connection string. Also the default MySQL user is `root` and password is `root`.


### Step 3. Start the stack

Use `docker-compose up` on your console and see what's happening. If you follow the configuration suggested above, you can:

1. Access your local projects at http://my-best-project.local
2. Access the local email (mailtrap) at http://localhost:81 (default config)

## Switch your project between PHP 5.x and 7.x

TODO - *Hint* edit nginx virtual host .conf file `fastcgi_pass` directive


## Contribute

If you have issues, ideas add a ticket here - even better - make a pull-request!

**Happy coding!**
