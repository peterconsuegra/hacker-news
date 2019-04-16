# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
2.6.2
* System dependencies
DB: Postgresql
* Database creation
rake db:create
* Database initialization
rake db:migrate
* How to run the test suite
For macOS:
Download https://sites.google.com/a/chromium.org/chromedriver/
<br/>
mv chromedriver /usr/local/bin/chromedriver
<br/>
bundle install
<br/>
bundle exec cucumber --profile default --guess --tags @submit_link
