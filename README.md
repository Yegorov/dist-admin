DistAdmin
=========

Administrative panel for differentiation of access rights to distributed system

## System requirements

* Ruby 2.4.1 (2.5.0)
* Stable NodeJS
* OpenSSL 1.0.2
* Hadoop 2.9.0

## How run app

```
$ git clone git@gitlab.com:Yegorov/dist-admin.git
$ cd dist-admin
$ rvm use 2.4.1 # swith to correct ruby version
$ bundle install
$ yarn install
$ bin/rails db:create db:migrate 
$ bin/rails db:seed ADMIN_PASSWORD=YOU_SECRET_PASS ADMIN_EMAIL=youemail@example.com # Init DB
$ bin/rails s
$ bin/delayed_job start
# Go to browser and open http://localhost:3000

# if you need available to upload file in dev mode:
$ sudo mkdir /userdata
$ sudo chown USERNAME /userdata
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

bin/rails db:drop db:create db:migrate db:seed

```
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production bin/rails db:drop db:create db:migrate db:seed
# restart postgres if db is lock: sudo service postgresql restart
hdfs namenode -format
hadoop fs -rm -R -skipTrash /userdata
```