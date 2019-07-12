[![Code Climate](https://codeclimate.com/github/ucsdlib/damspas/badges/gpa.svg)](https://codeclimate.com/github/ucsdlib/damspas)

[![Test Coverage](https://codeclimate.com/github/ucsdlib/damspas/badges/coverage.svg)](https://codeclimate.com/github/ucsdlib/damspas/coverage)

[![Dependency Status](https://gemnasium.com/ucsdlib/damspas.svg)](https://gemnasium.com/ucsdlib/damspas)

[UC San Diego Library](https://library.ucsd.edu/ "UC San Diego Library") Digital Collections Public Access System.

A Hydra repository backed by [DAMS Repository](http://github.com/ucsdlib/damsrepo).

# Docker
You can use the provided helper script as below, or invoke `docker-compose`
commands directly against the files in `docker/`. See the [Docker README](docker/README.md) for more information.

``` sh
$ ./bin/dc up
$ ./bin/dc exec web rake db:setup
```
Then navigate to localhost:3000

# Virtual Reading Room

The application has a virtual reading room feature that depends on the Aeon REST
API to facilitate management of requests to ordinarily private materials.

The developer-focused documentation from Notch 8 is provided in [doc/UCSD-Virtual-Reading-Room.pdf](doc/UCSD-Virtual-Reading-Room.pdf)
