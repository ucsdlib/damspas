[![Code Climate](https://codeclimate.com/github/ucsdlib/damspas/badges/gpa.svg)](https://codeclimate.com/github/ucsdlib/damspas)

[![Test Coverage](https://codeclimate.com/github/ucsdlib/damspas/badges/coverage.svg)](https://codeclimate.com/github/ucsdlib/damspas/coverage)

[![Dependency Status](https://gemnasium.com/ucsdlib/damspas.svg)](https://gemnasium.com/ucsdlib/damspas)

[UC San Diego Library](https://library.ucsd.edu/ "UC San Diego Library") Digital Collections Public Access System.

A Hydra repository backed by [DAMS Repository](http://github.com/ucsdlib/damsrepo).

# Docker
  You can below in Setup Instructions, or you can just do this:

  ``` sh
    $ ./bin/dc up
    $ ./bin/dc exec web rake db:setup
  ```

  Then navigate to localhost:3000

  
# Setup Instructions 

## Windows
_Let's not go there._

## Apple/OSX

### Install Command Line Tools
For Mavericks (10.9): run `sudo xcodebuild -license` and follow the instructions
to accept the XCode agreement.  Then run `xcode-select --install` in your
terminal and then click "Install".

[XCode Command Line Tools Homebrew Compatibility Chart](https://github.com/mxcl/homebrew/wiki/Xcode)

### Setup Ruby/Rails (OSX)
1. Install [homebrew](http://brew.sh/)

    ``` sh
    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ```

1. Run brew doctor and fix any issues that are reported before proceeding

   ``` sh
   $ brew doctor
   ```

1. Install automake

    ``` sh
    $ brew install automake
    ```

1. Install [rbenv](https://github.com/sstephenson/rbenv)

    ``` sh
    $ brew install rbenv ruby-build rbenv-gem-rehash
    ```

    or:

    ``` sh
    $ git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    $ git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    $ git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
    ```

1. Update your .bashrc to use rbenv by default:

    ```
    export PATH=$HOME/.rbenv/bin:$PATH
    eval "$(rbenv init -)"
    ```

1. Install Ruby 2.2.3 and set as default

    ``` sh
    $ rbenv install 2.2.3
    $ rbenv global 2.2.3
    $ gem install bundler
    ```

1. Confirm Ruby 2.2.3 is the default ruby

    ``` sh
    $ ruby --version
    ```

    _If the version shown is **not** 2.2.3+, set default directly.

2. Install [Node.js](http://nodejs.org/) (for updating Javascript libraries with bower)

    ``` sh
    $ brew install node
    ```

3. Install phantomJS

    ``` sh
    $ brew install phantomjs
    ```
### Prerequisites
Confirm all commands below return correct versions. Note this can easily get out of date. To be sure, look at the .ruby-version file in the repository.
* Ruby 2.2.3+ ```$ ruby -v```
* git ```$ git --version```
* node ```$ node --version```

### Check out DAMSPAS from GIT
1. Clone Project: ```git clone https://github.com/ucsdlib/damspas.git```
2. Open Project: ```cd damspas```
3. Check out develop branch: ```git checkout develop```
4. Install gems: ```bundle install```
    For RHEL, need to install packages: automake, gcc-c++, libxml2-devel, libxslt-devel, sqlite-devel.
5. Update DB: ```bundle exec rake db:migrate```
6. Update Test DB: ```bundle exec rake db:migrate RAILS_ENV=test```
7. Run Test Suite: ```bundle exec rake spec```

### Running DAMS PAS

#### WEBrick

The simplest Rails server is the built-in WEBrick.  Just run:

``` sh
$ rails s
```

And DAMS PAS will be available at http://localhost:3000/

WEBrick has some limitations, in particular it's single-threaded, slow and can't handle streaming large files.

#### Unicorn

For a faster, multi-threaded webserver that can handle large files, Unicorn is almost as easy:

``` sh
$ unicorn -p 8081
```

This will run DAMS PAS at http://localhost:8081/ -- you can specify any port you like, but the default port (8080) is also the default port for Jetty and Tomcat, so you probably need to specify something.

#### Passenger

Production deployment is typically done using Passenger (mod_rails) paired with Apache or Nginx.  This is more complicated to setup, but has the advantage of using the same stack in all environments and being able to use the same configuration.

1. Install or enable Apache.  On MacOSX 10.8 (Mountain Lion), this has been removed from the System Preferences Sharing panel, but can be done using the command line:

    ``` sh
    $ sudo defaults write /System/Library/LaunchDaemons/org.apache.httpd Disabled -bool false
    ```

2. Install Passenger gem:

    ``` sh
    $ gem install passenger
    ```

3. Install cURL development headers (needed by RHEL):

    ``` sh
    $ sudo yum install curl-devel
    ```

4. Install Apache module:

    ``` sh
    $ passenger-install-apache2-module
    ```

5. Configure Apache, taking the configuration directives from the module install output, and placing them in a file that will be loaded by Apache.  In MacOSX, the file should be in ```/etc/apache2/other/```, in RHEL, it should be in ```/etc/httpd/conf.d/```.  This should be named something ```passenger.conf``` and look like:

    ```
    LoadModule passenger_module /usr/local/var/rbenv/versions/2.0.0-p481/lib/ruby/gems/2.0.0/gems/passenger-4.0.44/buildout/apache2/mod_passenger.so
    PassengerRoot /usr/local/var/rbenv/versions/2.0.0-p481/lib/ruby/gems/2.0.0/gems/passenger-4.0.44
    PassengerDefaultRuby /usr/local/var/rbenv/versions/2.0.0-p481/bin/ruby
    PassengerBufferResponse off # disable buffering to allow streaming large files
    <Directory /var/www/html/damspas>
      Allow from all
      Options -MultiViews
      RackBaseURI /damspas
      RailsEnv "development"
    </Directory>
    ```

6. Omniauth ignores the ```RackBaseURI```, so you may want to rewrite the authentication callback URLs without the RackBaseURI:

   ```
   RewriteEngine On
   RewriteLog /var/log/apache2/rewrite.log
   RewriteLogLevel 9
   RewriteCond %{REQUEST_URI} /users
   RewriteRule ^/users(.*) /damspas/users/$1 [P,L]
   ```

6. Create a symlink from the web space to the ```public``` directory of DAMS PAS:

    ``` sh
    $ cd /var/www/html
    $ ln -s /path/to/damspas/public damspas
    ```

    On MacOSX, the web root will be in /Library/WebServer/Documents by default.

7. Restart Apache:

    ``` sh
    $ sudo apachectl restart
    ```

    DAMS PAS will be available at http://localhost/damspas/

### TODO
- Lookup works

- Rename processor
- move loop from rake run in processor
- conditional work authorizations link in header

#### Aeon queues
- link in footer to aeon queue if have permission
