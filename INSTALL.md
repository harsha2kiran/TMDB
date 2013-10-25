Ruby version: 2

Current version on development machine: 2.0.0p0 (2013-02-24 revision 39474) [x86_64-linux]

Rails version: 3.2.12


Setting development environment:

git clone https://github.com/trajkovvlatko/movies.git

cd movies/

bundle install

rails s


Problems during bundle install:

1. Nokogiri

Error:

  libxml2 is missing

Solution:

  sudo apt-get install build-essential

  sudo apt-get install libxslt-dev libxml2-dev


2. RMagick

Error:

  Cant find MagickWand.h.

Solution:

  sudo apt-get install libmagickwand-dev


3. Postgres (pg gem)

Problem:

  Adding new user with role and new database

Solution:

  Adding new user and setting role

  http://www.cyberciti.biz/faq/howto-add-postgresql-user-account/

  Database can be created using "rake db:create" command

  Other way is to login to psql and run CREATE DATABASE database_name;

  Tip, exit for psql is \q


Problem:

  The newly created user doesnt have permissions

Solution:

  http://linuxdesk.wordpress.com/2008/10/10/ident-authentication-failed-for-user-postgresql/

  sudo vim /etc/postgresql/9.1/main/pg_hba.conf

  Just edit the last part of rows to md5 or trust, so it will accept calls from local


Problem:

  Adding hstore extension to pg

Solution:

  Login to psql

  Go to the database that you want to work with.

  Add the extension

  Example:

  $ sudo su postgres

  psql -U movies -d movies_development

  CREATE EXTENSION hstore;

  \q

  Restart the postgres service after every change

  sudo /etc/init.d/postgresql restart


4. Memcached

Problem:

  gem installation fails with standard error that memcached is not installed

Solution:

  This is a step by step that works for php, but the process is almost the same

  https://www.digitalocean.com/community/articles/how-to-install-and-use-memcache-on-ubuntu-12-04


