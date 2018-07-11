# Using Docker for testing

- Install Docker
- `docker-compose up`

Setup rails databases:
- `docker-compose exec web bundle exec rake db:setup`

Run damspas test suite:
- `docker-compose exec web bundle exec rake spec`

# Teardown
To remove all containers:
`docker-compose rm`

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


