# Using Docker for development

- Install Docker
- `docker-compose up`

Setup rails databases:
- `docker-compose exec web bundle exec rake db:setup`

Load damsrepo predicates and setup base tables:
- `docker exec -i damspas_database_1 psql -U dams dams < docker/files/damsrepo/dams.triplestore`
