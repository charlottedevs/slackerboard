# API

### How to setup development environment

You need to make sure you have both `docker-compose` and `docker` installed on your machine.

Installation instructions:
* [docker-compose](https://docs.docker.com/compose/install/#install-compose)
* [docker (community edition)](https://docs.docker.com/install/)


Finally, run the setup script:
```
script/setup
```

### Steps to create a new service
1) create a new directory: `services/<yourservice>`
2) get your code working locally without docker
  > **NOTE**: even if you are not well versed in docker, you can still contribute!
  Please feel free to disregard steps 3-5 while you're coding your service.
  Once you're ready to move on, ask for docker help in `#questions`.
  Of course, if you feel comfortable with docker already, please go ahead and add it
  to your development workflow. :+1:
3) create a Dockerfile that includes all necessary operating system dependencies
  > see: [services/example service](services/example_service)
4) add service to [docker-compose.yml](docker-compose.yml)
5) run service with docker via `docker-compose up <yourservice>`
