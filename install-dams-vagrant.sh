#!/bin/sh
set -x
set -e

if [ ! -e vagrant ]; then
  git clone git@github.com:ucsdlib/dams-vagrant.git
fi

cd dams-vagrant
vagrant up
