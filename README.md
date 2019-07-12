[![CircleCI](https://circleci.com/gh/ucsdlib/damspas.svg?style=svg)](https://circleci.com/gh/ucsdlib/damspas)
[![Coverage Status](https://coveralls.io/repos/github/ucsdlib/damspas/badge.svg?branch=master)](https://coveralls.io/github/ucsdlib/damspas?branch=master)

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
