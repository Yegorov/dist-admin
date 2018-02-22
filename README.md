DistAdmin
=========

Administrative panel for differentiation of access rights to distributed system

## System requirements

* Ruby 2.4.1 (2.5.0)
* Stable NodeJS

## How run app

```
$ git clone git@gitlab.com:Yegorov/dist-admin.git
$ cd dist-admin
$ rvm use 2.4.1 # swith to correct ruby version
$ bundle install
$ yarn install
$ bin/rails s
# Go to browser and open http://localhost:3000
```

## Test

In rails root directory run:

```
$ rspec
```

## TODO
Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
