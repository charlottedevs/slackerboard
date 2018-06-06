# Slackerboard


### How to install in production environment

This will need to be run as root or with sudo.

```
$ mkdir -p /var/slackerboard
$ git clone https://github.com/charlottedevs/slackerboard.git /var/slackerboard
$ cd /var/slackerboard
$ bin/setup production
```

Start the app (and daemonize it) by running:

```
docker-compose -f production.yml -d up
```

### How to setup development environment

The setup script will handle installing docker if you don't have it already installed.

```
$ git clone https://github.com/charlottedevs/slackerboard.git
$ cd slackerboard
$ sudo bin/setup
```

Start the app by running:

```
docker-compose up
```

Will be available on http://localhost:80
