# Using Docker for testing

- Install Docker, docker-compose and possibly docker-machine (depends on your
  OS).

You have two choices for running damspas with Docker:
- To run a fully self-container docker environment including the rails
  application:
    - `docker-compose -f docker/dev/docker-compose.yml up`
- To run just the dependencies in Docker (PG, Solr, Damsrepo):
    - `docker-compose -f docker/ci/docker-compose.yml up`

Setup rails databases:
- Self contained:
    - `docker-compose -f docker/dev/docker-compose.yml exec -e RAILS_ENV=test web bundle exec rake db:create db:schema:load`
- Dependencies only:
    - `RAILS_ENV=test bundle exec rake db:create db:schema:load`

Run damspas test suite:
- Self contained:
    - `docker-compose -f docker/dev/docker-compose.yml exec web bundle exec rake spec`
- Dependencies only:
    - `bundle exec rake spec`

# Development Workflow
If you make changes to the damspas codebase that you want to test, you will need to rebuild the `web`
container which hosts the damspas application. This can be done as follows:

- Kill/stop the running docker-compose session
- Rebuild web container: `docker-compose -f docker/dev/docker-compose.yml build`
- Start docker-compose session again: `docker-compose -f docker/dev/docker-compose.yml up`
- This should only rebuild what is necessary. And won't run `bundle install`
  unless you change the Gemfile

## Debugging w/ byebug
If you need to use byebug (or similar), ensure you are using the
`docker/dev/docker-compose.yml` file as it contains support for attaching and
running a tty in the running container.

If the current web app container is damspas_web_1  then when a byebug breakpoint
is hit, open a terminal/tab and run:
```
docker attach damspas_web_1
```
This will give you a prompt for interacting with byebug


## Errors w/ the web container

If you get an error like:
```
web_1 | A server is already running. Check /usr/src/app/tmp/pids/server.pid.
```

You probably didn't cleanly shut down the web container, leaving `tmp` files in
the container and your local repo that prevent a clean start again. In this case, you should remove any files in `tmp/pids` on your local machine/host.

Now recreate the container so it removes the internal temp files:
```
docker-compose -f docker/dev/docker-compose.yml up --force-recreate
```

# Teardown
To remove all containers and associated anonymous volumes:
`docker-compose rm -v`

To completely remove all unused containers, volumes, networks, etc:
`docker system prune -f --all --volumes`

# Persisting data for local development
By default the data stored in the postgres database will be removed when the
postgres/database container is deleted.

To persist the data between deleted containers, you will need to enable the
volume information in the `docker-compose.yml` file that is currently commented
out in the definiton of the `database` service as well as the volume definition
at the bottom of the file.

```
database:
  image: ucsdlib/docker-postgres-damsrepo
    # volumes:
    #   - db-data:/var/lib/postgresql/data
...
...

# volumes:
#   db-data:
```


