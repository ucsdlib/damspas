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
    - `docker-compose -f docker/dev/docker-compose.yml exec web bundle exec rake db:create db:migrate`
- Dependencies only:
    - `bundle exec rake db:create db:migrate`

Run damspas test suite:
- Self contained:
    - `docker-compose -f docker/dev/docker-compose.yml exec web bundle exec rake spec`
- Dependencies only:
    - `bundle exec rake spec`

# Teardown
To remove all containers:
`docker-compose rm`

To completely remove all unused containers, volumes, networks, etc:
`docker system prune`

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


