## Setup

### Windows
_Let's not go there._

### Apple/OSX
#### Setup Ruby/Rails (OSX)
1. Install [homebrew](http://mxcl.github.com/homebrew/)
2. Install automake
```
$ brew install automake
```

3. Install [RVM](https://rvm.io/rvm/install/)
4. Install Ruby 1.9.3 and set as default
```
$ rvm get head && rvm reload
$ rvm install 1.9.3
```

5. Confirm Ruby 1.9.3+ is default ruby
```
$ rvm list default
```

6. If the version shown is not 1.9.3+, set default directly. [more information about RVM defaults](https://rvm.io/rubies/default/)
```
$ rvm --default use 1.9.3
```

7. Install Rails 3.2.11+ (and confirm version)
```
$ gem install rails -v 3.2.9
$ rails -v
```

#### Prerequisites (confirm all commands below return correct versions)
* Ruby 1.9.3+ ```$ ruby -v```
* Rails 3.2.11+ ```$ rails -v```
* git ```$ git --version```

#### Check out DAMSPAS from GIT
1. Clone Project: ```git clone https://github.com/ucsdlib/damspas.git```
2. Open Project: ```cd damspas```
3. Copy DB Sample: ```cp database.yml.sample database.yml```
4. Copy Fedora Sample: ```cp fedora.yml.sample fedora.yml```
5. Copy Solr Sample: ```cp solr.yml.sample solr.yml```
6. Open solr.yml, copy gimili URL to development URL
7. Update DB: ```bundle exec rake db:migrate```
8. Install gems: ```bundle install```
9. Run local server using ```rails s``` or ```unicorn```
